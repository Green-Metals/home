#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

REQUIRE_TOOLS=0
if [[ "${1:-}" == "--require-tools" ]]; then
  REQUIRE_TOOLS=1
fi

PLAYWRIGHT_JS="tools/playwright/node_modules/playwright"
if [[ ! -d "$PLAYWRIGHT_JS" ]]; then
  if [[ "$REQUIRE_TOOLS" -eq 1 ]]; then
    echo "[ui][fail] missing $PLAYWRIGHT_JS"
    echo "[ui][fail] run: (cd tools/playwright && npm ci && npx playwright install chromium)"
    exit 1
  fi
  echo "[ui][skip] playwright dependencies not installed; skipping UI smoke"
  exit 0
fi

BASE_URL="${SITE_BASE_URL:-}"
PORT="${SITE_SMOKE_PORT:-8960}"
SAVE_ALL_SCREENSHOTS="${SAVE_UI_SMOKE_SCREENSHOTS:-0}"
SERVER_PID=""

cleanup() {
  if [[ -n "$SERVER_PID" ]]; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

if [[ -z "$BASE_URL" ]]; then
  echo "[ui] starting local server on port $PORT..."
  python3 -m http.server "$PORT" -d site/_site >/tmp/ui_smoke_server.log 2>&1 &
  SERVER_PID="$!"
  sleep 1
  BASE_URL="http://127.0.0.1:${PORT}"
fi

echo "[ui] running smoke checks against $BASE_URL ..."
BASE_URL="$BASE_URL" SAVE_ALL_SCREENSHOTS="$SAVE_ALL_SCREENSHOTS" node - <<'JS'
const fs = require("fs");
const path = require("path");
const { chromium, devices } = require("./tools/playwright/node_modules/playwright");

const root = process.cwd();
const outDir = path.join(root, "ops/qa-artifacts/screenshots/latest");
fs.mkdirSync(outDir, { recursive: true });
const saveAllScreenshots = process.env.SAVE_ALL_SCREENSHOTS === "1";

const base = process.env.BASE_URL;
const defaultPages = [
  "/index.html",
  "/docs/sample-page.html",
  "/docs/qa-checklist.html",
  "/topic00_landscape-briefing/WRITEUP.html",
  "/topic01_copper/WRITEUP.html",
  "/topic02_iron-steel/WRITEUP.html",
  "/topic03_alumina-aluminium/WRITEUP.html",
];
const routesFile = process.env.UI_SMOKE_ROUTES_FILE || "";
const routesCsv = process.env.UI_SMOKE_ROUTES || "";
let pages = [...defaultPages];
const normalizeRoutes = (routes) =>
  routes.map((route) => (route.startsWith("/") ? route : `/${route}`));

if (routesFile) {
  if (!fs.existsSync(routesFile)) {
    console.error(`[ui][fail] UI_SMOKE_ROUTES_FILE not found: ${routesFile}`);
    process.exit(1);
  }
  const parsed = fs
    .readFileSync(routesFile, "utf8")
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));
  if (parsed.length > 0) {
    pages = normalizeRoutes(parsed);
  }
} else if (routesCsv) {
  const parsed = routesCsv
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);
  if (parsed.length > 0) {
    pages = normalizeRoutes(parsed);
  }
}

function keyFromRoute(route, suffix) {
  return `ui-smoke-${route.replace(/^\//, "").replace(/[\/]/g, "__").replace(/\.html$/, "")}-${suffix}.png`;
}

(function prunePreviousUiSmokePngs() {
  const files = fs.readdirSync(outDir);
  for (const name of files) {
    if (name.startsWith("ui-smoke-") && name.endsWith(".png")) {
      fs.unlinkSync(path.join(outDir, name));
    }
  }
})();

async function checkDrawer(page, route) {
  const r = {
    route,
    menu_present: false,
    menu_open_ok: false,
    menu_close_ok: false,
    menu_links_total: 0,
    menu_qmd_links: 0,
    toc_links: 0
  };

  const menuBtn = page.locator(".menu-trigger").first();
  if (await menuBtn.count()) {
    r.menu_present = true;
    await menuBtn.click();
    await page.waitForSelector("#menu-drawer.is-open", { timeout: 5000 });
    r.menu_open_ok = true;
    const links = await page.$$eval("#menu-drawer-list a.menu-drawer-link", els =>
      els.map(a => ({ text: (a.textContent || "").trim(), href: a.getAttribute("href") || "" }))
    );
    r.menu_links_total = links.length;
    r.menu_qmd_links = links.filter(x => /\.qmd($|[?#])/i.test(x.href)).length;
    await page.keyboard.press("Escape");
    await page.waitForSelector("#menu-drawer.is-open", { state: "detached", timeout: 5000 });
    r.menu_close_ok = true;
  }

  r.toc_links = await page.$$eval("nav[role='doc-toc'] .nav-link, #TOC .nav-link", els => els.length);
  return r;
}

(async () => {
  const report = {
    generated_at: new Date().toISOString(),
    base_url: base,
    screenshot_policy: saveAllScreenshots ? "full" : "failures-only",
    desktop: [],
    mobile: []
  };
  const failures = [];

  const browser = await chromium.launch({ headless: true });

  const desktopCtx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const desktop = await desktopCtx.newPage();
  for (const route of pages) {
    const row = { route, status: "pass" };
    try {
      const resp = await desktop.goto(base + route, { waitUntil: "networkidle", timeout: 30000 });
      row.http_status = resp ? resp.status() : null;
      if (row.http_status !== 200) {
        throw new Error(`HTTP ${row.http_status} for ${route}`);
      }
      Object.assign(row, await checkDrawer(desktop, route));
      if (!row.menu_present) {
        throw new Error(`menu trigger missing for ${route}`);
      }
      if (!row.menu_open_ok || !row.menu_close_ok) {
        throw new Error(`menu open/close interaction failed for ${route}`);
      }
      if (row.menu_links_total < 7) {
        throw new Error(`menu link set incomplete for ${route}`);
      }
      if (row.menu_qmd_links > 0) {
        throw new Error(`menu contains source .qmd links for ${route}`);
      }
      if (route.includes("/WRITEUP.html") && row.toc_links === 0) {
        throw new Error(`no TOC links found on writeup page ${route}`);
      }
      if (saveAllScreenshots) {
        const p = path.join(outDir, keyFromRoute(route, "desktop"));
        await desktop.screenshot({ path: p, fullPage: true });
        row.screenshot = path.relative(root, p);
      }
    } catch (e) {
      row.status = "fail";
      row.error = String(e && e.message ? e.message : e);
      failures.push(row.error);
      try {
        const p = path.join(outDir, keyFromRoute(route, "desktop-fail"));
        await desktop.screenshot({ path: p, fullPage: true });
        row.screenshot = path.relative(root, p);
      } catch (_) {}
    }
    report.desktop.push(row);
  }

  const mobileRoutes = [];
  if (pages.includes("/index.html")) {
    mobileRoutes.push("/index.html");
  }
  const firstTopicRoute = pages.find((r) => /^\/topic[0-9]{2}[^/]+\/WRITEUP\.html$/.test(r));
  if (firstTopicRoute) {
    mobileRoutes.push(firstTopicRoute);
  } else {
    mobileRoutes.push("/topic01_copper/WRITEUP.html");
  }
  const uniqueMobileRoutes = [...new Set(mobileRoutes)];

  const mobileCtx = await browser.newContext({ ...devices["iPhone 13"] });
  const mobile = await mobileCtx.newPage();
  for (const route of uniqueMobileRoutes) {
    const row = { route, status: "pass" };
    try {
      const resp = await mobile.goto(base + route, { waitUntil: "networkidle", timeout: 30000 });
      row.http_status = resp ? resp.status() : null;
      if (row.http_status !== 200) {
        throw new Error(`HTTP ${row.http_status} for ${route}`);
      }
      row.menu_present = (await mobile.locator(".menu-trigger").first().count()) > 0;
      if (!row.menu_present) {
        throw new Error(`mobile menu trigger missing for ${route}`);
      }
      row.toc_links = await mobile.$$eval("nav[role='doc-toc'] .nav-link, #TOC .nav-link", els => els.length);
      if (saveAllScreenshots) {
        const p = path.join(outDir, keyFromRoute(route, "mobile"));
        await mobile.screenshot({ path: p, fullPage: true });
        row.screenshot = path.relative(root, p);
      }
    } catch (e) {
      row.status = "fail";
      row.error = String(e && e.message ? e.message : e);
      failures.push(row.error);
      try {
        const p = path.join(outDir, keyFromRoute(route, "mobile-fail"));
        await mobile.screenshot({ path: p, fullPage: true });
        row.screenshot = path.relative(root, p);
      } catch (_) {}
    }
    report.mobile.push(row);
  }

  await browser.close();

  const out = path.join(outDir, "ui-smoke-report.json");
  fs.writeFileSync(out, JSON.stringify(report, null, 2));
  console.log(`[ui] wrote ${path.relative(root, out)}`);
  if (failures.length > 0) {
    console.error("[ui][fail] smoke check failures:");
    for (const f of failures) console.error(`- ${f}`);
    process.exit(1);
  }
  console.log("[ui] smoke checks passed");
})();
JS

echo "[ui] all checks passed"
