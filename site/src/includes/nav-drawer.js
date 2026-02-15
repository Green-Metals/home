<script>
(function () {
  "use strict";

  function normalizePath(path) {
    return (path || "")
      .replace(/\/index\.html$/, "/")
      .replace(/\/$/, "")
      .toLowerCase();
  }

  function normalizeText(text) {
    return (text || "").replace(/\s+/g, " ").trim();
  }

  function normalizeHrefToHtml(href) {
    if (!href) return href;
    // Include only rendered pages; skip source-only qmd links in drawer navigation.
    return href.replace(/\.qmd(?=([?#].*)?$)/i, ".html");
  }

  function pathnameFromHref(href) {
    if (!href) return "";
    try {
      return normalizePath(new URL(href, window.location.href).pathname);
    } catch (_err) {
      return "";
    }
  }

  function currentPath() {
    return normalizePath(window.location.pathname);
  }

  function currentTopicSlug(pathname) {
    var match = normalizePath(pathname).match(/\/(topic\d{2}_[^/]+)/);
    return match ? match[1] : null;
  }

  function collectSidebarLinks() {
    var links = Array.prototype.slice.call(
      document.querySelectorAll("#quarto-sidebar a.sidebar-link[href]")
    );
    var seen = new Set();

    return links
      .map(function (link) {
        var href = normalizeHrefToHtml(link.getAttribute("href"));
        if (!href) return null;
        var label = normalizeText(link.textContent);
        var pathname = pathnameFromHref(href);
        if (!label || !pathname) return null;
        var key = label + "::" + pathname;
        if (seen.has(key)) return null;
        seen.add(key);
        return {
          label: label,
          href: href,
          pathname: pathname
        };
      })
      .filter(Boolean);
  }

  function collectSidebarSections() {
    var sections = Array.prototype.slice.call(
      document.querySelectorAll("#quarto-sidebar li.sidebar-item-section")
    );

    return sections
      .map(function (section) {
        var headerLabelEl = section.querySelector(
          ".sidebar-item-container > a.sidebar-link .menu-text"
        );
        var firstHrefEl = section.querySelector("ul a.sidebar-link[href]");
        var label = normalizeText(headerLabelEl ? headerLabelEl.textContent : "");
        if (!label || !firstHrefEl) return null;
        var href = normalizeHrefToHtml(firstHrefEl.getAttribute("href"));
        var pathname = pathnameFromHref(href);
        if (!href || !pathname) return null;
        return {
          label: label,
          href: href,
          pathname: pathname
        };
      })
      .filter(Boolean);
  }

  function findByLabel(links, label) {
    var target = normalizeText(label);
    for (var i = 0; i < links.length; i += 1) {
      if (links[i].label === target) {
        return links[i];
      }
    }
    return null;
  }

  function findByPathSuffix(links, suffix) {
    var target = (suffix || "").toLowerCase();
    if (target.length > 1 && target.endsWith("/")) {
      target = target.slice(0, -1);
    }
    for (var i = 0; i < links.length; i += 1) {
      var candidate = (links[i].pathname || "").toLowerCase();
      if (candidate.length > 1 && candidate.endsWith("/")) {
        candidate = candidate.slice(0, -1);
      }
      if (candidate === target) {
        return links[i];
      }
      if (target === "/index.html" && candidate === "/") {
        return links[i];
      }
      if (target !== "" && candidate.endsWith(target)) {
        return links[i];
      }
    }
    return null;
  }

  function makeItem(config) {
    var li = document.createElement("li");
    var a = document.createElement("a");
    a.className = "menu-drawer-link" + (config.compact ? " is-compact" : "");
    a.href = new URL(config.href, window.location.href).toString();
    a.textContent = config.label;
    if (config.active) {
      a.classList.add("is-active");
    }
    li.appendChild(a);
    return {
      li: li,
      link: a
    };
  }

  function buildMenuItems() {
    var sidebarLinks = collectSidebarLinks();
    var sidebarSections = collectSidebarSections();
    var pathNow = currentPath();
    var topicSlug = currentTopicSlug(pathNow);
    var brandLink = document.querySelector(".navbar-brand");
    var siteHomeHref = brandLink && brandLink.getAttribute("href") ? brandLink.getAttribute("href") : "./index.html";
    var siteHomeUrl = new URL(siteHomeHref, window.location.href);
    var baseTargets = [
      { label: "Home", suffix: "/index.html", rel: "./index.html" },
      { label: "Design Demo", suffix: "/docs/sample-page.html", rel: "./docs/sample-page.html" },
      { label: "QA Checklist", suffix: "/docs/qa-checklist.html", rel: "./docs/qa-checklist.html" },
      { label: "Landscape Briefing", suffix: "/topic00_landscape-briefing/topic00_agent_writeup.html", rel: "./topic00_landscape-briefing/topic00_agent_writeup.html" },
      { label: "Topic 01 Copper", suffix: "/topic01_copper/topic01_agent_writeup.html", rel: "./topic01_copper/topic01_agent_writeup.html" },
      { label: "Topic 02 Iron-Steel", suffix: "/topic02_iron-steel/topic02_agent_writeup.html", rel: "./topic02_iron-steel/topic02_agent_writeup.html" },
      { label: "Topic 03 Alumina-Aluminium", suffix: "/topic03_alumina-aluminium/topic03_agent_writeup.html", rel: "./topic03_alumina-aluminium/topic03_agent_writeup.html" }
    ];
    var items = [];

    baseTargets.forEach(function (target) {
      var found = findByPathSuffix(sidebarLinks, target.suffix);
      if (!found) {
        found = findByLabel(sidebarLinks, target.label);
      }
      if (!found) {
        found = findByPathSuffix(sidebarSections, target.suffix);
      }
      if (!found) {
        found = findByLabel(sidebarSections, target.label);
      }
      if (!found) {
        var fallbackUrl = new URL(target.rel, siteHomeUrl).toString();
        found = {
          label: target.label,
          href: fallbackUrl,
          pathname: normalizePath(new URL(fallbackUrl).pathname)
        };
      }
      items.push({
        label: target.label,
        href: found.href,
        active: found.pathname === pathNow,
        compact: false
      });
    });

    if (topicSlug) {
      var existingPaths = new Set(
        items.map(function (item) {
          return normalizePath(new URL(item.href, window.location.href).pathname);
        })
      );
      var topicScoped = sidebarLinks.filter(function (link) {
        return link.pathname.indexOf("/" + topicSlug + "/") !== -1;
      });
      topicScoped.forEach(function (link) {
        if (link.label === "Writeup" || /^(?:\d{2}\s)/.test(link.label)) {
          if (existingPaths.has(link.pathname)) {
            return;
          }
          items.push({
            label: link.label,
            href: link.href,
            active: link.pathname === pathNow,
            compact: true
          });
        }
      });
    }

    return items;
  }

  function buildMenuList(onLinkClick) {
    var list = document.getElementById("menu-drawer-list");
    var items = buildMenuItems();

    if (!list) return;
    list.innerHTML = "";

    items.forEach(function (item) {
      var entry = makeItem(item);
      if (onLinkClick) {
        entry.link.addEventListener("click", onLinkClick);
      }
      list.appendChild(entry.li);
    });
  }

  function getFocusable(root) {
    var selector = [
      "a[href]",
      "button:not([disabled])",
      "textarea:not([disabled])",
      "input:not([disabled])",
      "select:not([disabled])",
      "[tabindex]:not([tabindex='-1'])"
    ].join(",");
    return Array.prototype.slice
      .call(root.querySelectorAll(selector))
      .filter(function (el) {
        return el.offsetParent !== null;
      });
  }

  function initDrawer() {
    var drawer = document.getElementById("menu-drawer");
    var overlay = document.getElementById("menu-drawer-overlay");
    var closeBtn = document.getElementById("menu-drawer-close");
    var navbarTools = document.querySelector(".quarto-navbar-tools");
    var isOpen = false;
    var lastFocused = null;

    if (!drawer || !overlay || !navbarTools) return;

    // Force deterministic layering because Quarto theme stacks can vary by page.
    drawer.style.zIndex = "3000";
    overlay.style.zIndex = "2990";
    overlay.style.pointerEvents = "none";

    var openBtn = navbarTools.querySelector(".menu-trigger");
    if (!openBtn) {
      openBtn = document.createElement("button");
      openBtn.type = "button";
      openBtn.className = "text-button menu-trigger";
      openBtn.setAttribute("aria-controls", "menu-drawer");
      openBtn.setAttribute("aria-expanded", "false");
      openBtn.textContent = "MENU";
      navbarTools.appendChild(openBtn);
    }

    function closeDrawer() {
      if (!isOpen) return;
      isOpen = false;
      drawer.classList.remove("is-open");
      drawer.setAttribute("aria-hidden", "true");
      overlay.hidden = true;
      overlay.style.pointerEvents = "none";
      openBtn.setAttribute("aria-expanded", "false");
      document.body.classList.remove("drawer-open");
      if (lastFocused) {
        lastFocused.focus();
      }
    }

    function openDrawer() {
      if (isOpen) return;
      isOpen = true;
      lastFocused = document.activeElement;
      drawer.classList.add("is-open");
      drawer.setAttribute("aria-hidden", "false");
      overlay.hidden = false;
      overlay.style.pointerEvents = "auto";
      openBtn.setAttribute("aria-expanded", "true");
      document.body.classList.add("drawer-open");
      var focusable = getFocusable(drawer);
      if (focusable.length > 0) {
        focusable[0].focus();
      }
    }

    buildMenuList(closeDrawer);

    if (openBtn.dataset.menuBound !== "true") {
      openBtn.addEventListener("click", function () {
        if (isOpen) closeDrawer();
        else openDrawer();
      });
      openBtn.dataset.menuBound = "true";
    }

    if (closeBtn.dataset.menuBound !== "true") {
      closeBtn.addEventListener("click", closeDrawer);
      closeBtn.dataset.menuBound = "true";
    }
    if (overlay.dataset.menuBound !== "true") {
      overlay.addEventListener("click", closeDrawer);
      overlay.dataset.menuBound = "true";
    }

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeDrawer();
        return;
      }

      if (!isOpen || event.key !== "Tab") return;
      var focusable = getFocusable(drawer);
      if (focusable.length === 0) return;

      var first = focusable[0];
      var last = focusable[focusable.length - 1];

      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    });
  }

  function initHeaderScroll() {
    var header = document.getElementById("quarto-header");
    if (!header) return;

    function sync() {
      if (window.scrollY > 2) header.classList.add("is-scrolled");
      else header.classList.remove("is-scrolled");
    }

    sync();
    window.addEventListener("scroll", sync, { passive: true });
  }

  window.addEventListener("DOMContentLoaded", function () {
    initDrawer();
    initHeaderScroll();
  });
})();
</script>
