# Working Note: Australia Copper Strategy

## Current Snapshot
- Objective: develop an Australia-focused copper research and partnership strategy across the full value chain.
- Focus: research prioritization and industry partnership positioning.
- Strategic framing: value capture across mine/concentrate, smelting/refining, alloys/semi-fab, manufacturing/end-use, and recycling/circularity.
- Status: first-pass evidence pack loaded, plus a new user-supplied paywalled corpus ingested and canonicalized.
- Continuity: major session decisions are preserved in `Daily Log`, with structure decisions also mirrored in `topic01_copper/meta/TOPIC_INDEX_AND_CROSSWALK.md`.

## Output Sync Rule (Locked)
- When `WRITEUP.qmd` changes, regenerate `WRITEUP.pdf` in the same folder for distribution readiness.

## Decision Scope
- What research missions should be prioritized in copper over the next 3-7 years?
- Which partner types and specific organizations should be prioritized first?
- Which pilot/testbed assets are most important for near-term proof points (12-24 months)?

## Locked Decisions (Confirmed 2026-02-09)
- Demand-side priority: data center infrastructure is first-priority for partner pull and use-case framing.
- Secondary end-use scan: grid, EV supply chain, electronics, defense, and construction.
- System boundary: copper plus co-products where economics materially depend on co-product value/revenue.

## Formal Writeup Guardrails (Standing Rules)
### Document Type Default
- Unless explicitly requested otherwise, produce a **proper research report** (not a memo) that is readable standalone by the internal group.

### House Style (Readability Rules)
- Prefer short paragraphs with a clear topic sentence.
- Narrative-first: prefer paragraphs and short dot points over big tables.
- Use tables sparingly in the main body (aim for <= 2 small tables). Put detailed matrices in appendices.
- Avoid repeated “Research question / University work / Deliverables” templates in the main body; move that level of detail to an appendix if needed.
- Any technology discussed in `WRITEUP.qmd` must have a short “Scientific 101” primer subsection (unless explicitly deferred as out of scope).
- For every section, include an explicit “So what for Australia?” sentence.
- Use consistent terms: `midstream` (smelting/refining), `circular` (secondary feeds, scrap/e-waste), `downstream pull` (specs/offtake/standards).
- Avoid “decision requests / approvals” language unless explicitly requested; prefer “implications” and “near-term baseline work”.

### Required Inputs Before Drafting
- Audience.
- Length target.
- Citation style.
- Deliverables required (research report, one-page executive summary if needed, references style).
- Scope exclusions and deferred items.

### Quality Gate (Must Pass Before Delivery)
- No placeholder text (`CITATION NEEDED`, `TBD`, `to be added`).
- Clear section flow: finding -> evidence -> implication -> action.
- Quantitative claims include page-anchored citations and appear in the WRITEUP evidence table.
- Major claims map to claim-ledger keys.
- Section opening sentences are readable standalone.
- No “wall of bullets”: if a section has >7 bullets, split into subheadings and paragraphs (use tables only if compact and essential).
- No “Decision requests” section in `WRITEUP.qmd` unless explicitly requested.
- No large work-package tables in the main body; work packages must be readable as paragraphs + dot points.

### Evidence Pack Requirements (Non-Negotiable for WRITEUP)
- Every quantitative claim in `WRITEUP.qmd` must have an in-text page anchor `(Author, Year, p. X)` and a corresponding row in `WRITEUP.qmd` Appendix A (evidence table).
- If a claim cannot be page-anchored from the local corpus, it must be phrased qualitatively or deferred as a baseline deliverable.
- Web sources are allowed for context and partner signals, but do not replace page-anchored PDF evidence for quantitative claims.

### Citation Standard
- Use formal report citation style (Harvard author-date).
- Use page anchors for key claims (for example, `(Author, Year, p. X)`).
- For shareable outputs, include references directly in `WRITEUP.qmd`.

### Delivery Package Default
- `WRITEUP.qmd` as the single standalone shareable report (includes abstract, executive summary, methods, evidence table appendix, and references).

### Completion Report (Mandatory)
- Completed.
- Partial.
- Deferred (with reason).
- Next actions (ordered).

## Document Role Contract (Strict Separation)
### WORKING_NOTE.md is the research driver
- Keep: research workflow, reading queue, source log, claim ledger, uncertainties, blockers, and session-by-session progress.
- Keep: evolving hypotheses, evidence maturity, and decisions not yet distilled.
- Keep: internal operational planning and task sequencing.

### WRITEUP.qmd is the distilled report
- Keep: evidence-backed findings, strategic implications, prioritized recommendations, and implications/near-term baseline work.
- Keep: formal report narrative and references needed for standalone sharing.
- Exclude: reading queue, source ingestion logs, claim-confidence workflow notes, daily logs, and internal process instructions.

### Transfer rule
- If content describes how research is being managed, it belongs in `WORKING_NOTE.md`.
- If content describes what is now known and what it implies (including near-term baseline work), it belongs in `WRITEUP.qmd`.

## Two-Lane Structure (Locked 2026-02-13)
### Lane A: Operational Control (keep in WORKING_NOTE.md)
- Keep workflow controls, source ingestion/access state, citation map, source log, quality gates, next actions, and daily log.
- Keep this lane concise and execution-oriented so session handover remains fast.

### Lane B: Thematic Research Tracker (T1-T6)
- Track evidence maturity by canonical topic IDs rather than ad hoc sections.
- For each topic block, record: `primary_topic_id`, `secondary_topic_id` (optional), `decision_risk`, `evidence_readiness`, and `next_action`.
- Keep thematic synthesis paragraphs in `WRITEUP.qmd`; keep tracker summaries and risk queue in `WORKING_NOTE.md`.

### Canonical Topic IDs (Locked)
- `T1`: Demand Pull + Australia Value-Chain Structure.
- `T2`: Processing Pathways Across Primary/Secondary Feeds and Co-products.
- `T3`: Science 101 Technology Primer (standalone, cross-cutting).
- `T4`: Research and Collaboration Landscape (AU + selected global comparators).
- `T5`: Policy, Funding, and Programs.
- `T6`: Evidence Quality, Gaps, and Confidence.

### Module Architecture and Sync Rule (Locked 2026-02-13)
- Topic modules: `00_overview.md`, `01_T1_demand-and-value-chain.md`, `02_T2_processing-pathways.md`, `03_T3_science-101.md`, `04_T4_research-and-collaboration-landscape.md`, `05_T5_policy-funding-programs.md`, `06_T6_evidence-quality-gaps-confidence.md`, and `90_references-and-appendices.md`.
- Source-of-truth for thematic drafting is the module pack above.
- Distribution artifact remains `WRITEUP.qmd` as a full standalone report.
- Update rule (mandatory): edit module file(s) first, then sync corresponding sections in `WRITEUP.qmd`, then update crosswalk rows if section locations changed.

## Ingestion Batch (2026-02-09, User-Supplied PDFs)
- S&P Global - 2026 - Copper in the Age of AI Challenges of Electrification.pdf
- S&P Global - 2026 - The Copper Conundrum Why Meeting AI-Era Electrification Demands Is a Race Against Time.pdf
- Wood Mackenzie - 2025 - High-wire Act Is Soaring Copper Demand an Obstacle to Future Growth.pdf
- Fastmarkets - 2024 - Copper Cathode Premium Methodology and Price Specifications.pdf
- Fastmarkets - 2025 - Copper Concentrates Index Methodology and Price Specifications.pdf
- Lane et al. - 2016 - Selective Leaching of Penalty Elements from Copper Concentrates A Review.pdf
- Yang et al. - 2024 - Towards Resource Regeneration A Focus on Copper Recovery from Electronic Waste.pdf
- Torrubia et al. - 2024 - Recovery of Copper from Electronic Waste An Energy Transition Approach to Decarbonise the Industry.pdf
- Dong et al. - 2020 - Comprehensive Recoveries of Selenium Copper Gold Silver and Lead from a Copper Anode Slime with a Clean and Economical Hydrometallurgical Process.pdf
- Jadoun et al. - 2025 - Recovery of Metals from E-waste Facts Methods Challenges Case Studies and Sustainable Solutions.pdf
- Wu et al. - 2025 - Scaling Bioleaching from Lab to Industry A Life Cycle Assessment of Cathode Copper Production.pdf

## Working Hypotheses (to test with evidence)
- H1: Midstream (smelting/refining flexibility, impurities, low-carbon energy) is the key Australian value-capture bottleneck.
- H2: Complex scrap/e-waste upgrading is a high-leverage circularity opportunity for onshore value retention.

## Next Actions (Short List)
- `[High][T1]` Complete harmonized Australia value-chain table (mine/concentrate/midstream/downstream/circular) with evidence keys.
- `[High][T6]` Maintain `topic01_copper/meta/quantitative_claim_audit.csv`/`topic01_copper/meta/quantitative_claim_audit.md` and keep Appendix A synced whenever new quantitative claims are introduced.
- `[High][T2]` Convert current processing hypotheses into a scored bottleneck matrix (impact x feasibility x partner pull).
- `[Medium][T5]` Resolve subsidy/funding uncertainty fields in collaboration records where amounts are currently partial.
- `[Medium][T4]` Convert collaboration landscape into a ranked partner map linked to topic IDs and feed/constraint access.
- `[Medium][T3]` Keep Science 101 primer aligned to T2 route choices; remove non-essential overlap with policy/program content.

## Reading Queue
- [x] Australian copper production/trade outlook baselines (REQ, IEA, ICSG, USGS).
- [x] Operator disclosures for Australian processing assets and constraints (Glencore, BHP, ministerial releases).
- [x] Global benchmark programs (EU CRMA/ERMA, US DOE critical materials framing).
- [x] Circular copper and complex scrap processing: add 3-5 more papers focused on scale-up economics.
- [x] Data-center copper intensity and demand trajectories (AU/APAC buildout lens) for demand-side partner case (first pass).
- [x] Extract page-anchored quotes/tables from newly added PDFs for WRITEUP insertion.

## Source Access Table
| Source | Type | Access | Status | Notes |
|---|---|---|---|---|
| AU government datasets | Data | Available | In progress | REQ Dec 2025 baseline loaded; add ABS/DFAT trade detail next |
| Company reports | Industry | Available | In progress | Glencore + BHP pages loaded; asset and capacity claims partly verified |
| EU benchmark docs | Policy/program | Available | In progress | CRMA and ERMA baseline loaded |
| US benchmark docs | Policy/program | Available | In progress | DOE 2023 critical materials assessment + USGS 2026 MCS loaded |
| Academic papers | Research | Available | In progress | Circularity + midstream impurity/processing papers loaded |
| Paywalled industry reports | Industry | Available | Loaded | S&P 2026 and WoodMac 2025 PDF reports now local |
| Price methodology docs | Market | Available | Loaded | Fastmarkets copper concentrates/cathode premium methodology PDFs now local |
| Paywalled technical papers | Research | Available | Loaded | JCP/ACS/CEJ/Minerals Engineering PDFs now local |

## Citation Map
| Key | Provisional Topic | Use in Synthesis | Status |
|---|---|---|---|
| AUVC-01 | Australia copper value chain baseline | Core baseline | Placeholder |
| MID-01 | Midstream capacity and constraints | Bottleneck analysis | Placeholder |
| CIR-01 | Circular copper and complex scrap | Mission 2 evidence | Placeholder |
| BENCH-EU-01 | EU benchmark model | International comparator | Placeholder |
| BENCH-US-01 | US benchmark model | International comparator | Placeholder |
| AU-REQ-2025DEC | AU copper exports, earnings, price outlook | Baseline demand/supply narrative | Loaded |
| GLOB-IEA-2025 | Global copper deficit risk and demand outlook | Global context and urgency | Loaded |
| AU-GLEN-OPS | Glencore Mount Isa-Townsville integrated chain | Midstream/operator mapping | Loaded |
| AU-GLEN-HOA-2025 | 2025 support package for Mount Isa/Townsville | Midstream fragility and policy relevance | Loaded |
| AU-BHP-SA-2024 | BHP SA copper expansion to early/mid-2030s | Competing midstream growth pathway | Loaded |
| EU-CRMA-2024 | EU Critical Raw Materials Act | Benchmark policy architecture | Loaded |
| EU-ERMA-2020 | ERMA ecosystem model | Benchmark partnership architecture | Loaded |
| US-DOE-CMA-2023 | DOE critical materials assessment | US benchmark framing | Loaded |
| USGS-MCS-2026 | USGS commodity baseline reference | Global comparator datapoints | Loaded |
| TECH-CIR-2026-RSC | PCB-to-copper hydro route + LCA | Mission 2 technical evidence | Loaded |
| AU-GLEN-HOA-2025 | Mount Isa/Townsville support package | AU midstream node relevance | Loaded |
| AU-BHP-SA-2024 | BHP SA processing/refining expansion | AU midstream pathway | Loaded |
| TECH-REV-2024-RSTA | Review on non-ferrous extraction/recycling | Cross-mission background review | Loaded |
| PAY-SP-AGEAI-2026 | S&P full report on AI/electrification copper demand | Data-center demand and macro context | Loaded |
| PAY-SP-CONUN-2026 | S&P copper conundrum report | Data-center demand and supply-risk narrative | Loaded |
| PAY-WM-HIGHWIRE-2025 | WoodMac copper demand/supply outlook report | Industry market comparator | Loaded |
| PAY-FM-CATHPREM-2024 | Fastmarkets cathode premium methodology | Midstream market signal framework | Loaded |
| PAY-FM-CONC-2025 | Fastmarkets concentrates index methodology | TC/RC market signal framework | Loaded |
| PAY-LANE-2016 | Selective leaching of penalty elements review | Mission 1 impurity handling evidence | Loaded |
| PAY-YANG-2024 | Copper recovery from e-waste review | Mission 2 recovery route synthesis | Loaded |
| PAY-TORRUBIA-2024 | E-waste copper recovery and decarbonisation | Mission 2 process and transition evidence | Loaded |
| PAY-DONG-2020 | Copper anode slime hydrometallurgical recovery | Mission 1/2 co-product and refining evidence | Loaded |
| PAY-JADOUN-2025 | E-waste metals recovery review (ACS ES&T Lett.) | Mission 2 broader evidence base | Loaded |
| PAY-WU-2025 | Bioleaching LCA for cathode copper | Mission 1/2 low-carbon process evidence | Loaded |
| DC-AEMO-OX-2025 | AEMO/Oxford data-center energy demand report | Data-center demand-side evidence | Loaded |
| AU-UQ-BANKSIA-2025 | UQ copper process startup (Banksia) and Trailblazer support | AU research landscape and commercialization pathway | Loaded |
| AU-UQ-ARC-2023 | UQ ARC Linkage announcement (incl. copper processing project) | AU research/funding mechanisms | Loaded |
| AU-UQ-HYDROMET | UQ Hydrometallurgy Group profile | AU capability mapping (hydromet) | Loaded |
| AU-UNSW-IID-2025 | UNSW IID value-adding minerals feature | AU value-add framing and policy/economic context | Loaded |
| AU-UNSW-MICROFACTORY-2018 | UNSW e-waste microfactory launch page | Circular copper/e-waste capability signals | Loaded |
| AU-UNSW-ARC-MICROREC | UNSW ARC Microrecycling Hub page | AU recycling R&D program evidence | Loaded |
| AU-CURTIN-C3MET-2024 | Curtin C3MET group page | AU research capability mapping | Loaded |
| AU-CURTIN-TRAILBLAZER | Curtin RTCM Trailblazer page | National commercialization/partnership mechanism | Loaded |
| AU-CURTIN-KAL-2021 | Curtin Kalgoorlie metals research lab release | Pilot-scale decarbonized pyromet capability | Loaded |
| AU-ADEL-CUHUB | Adelaide ARC Copper-Uranium Hub page | AU historical consortium precedent | Loaded |
| AU-CSIRO-GMIN-2025 | CSIRO Green Metals Innovation Network release | AU green-metals collaboration mechanism | Loaded |
| AU-HILT-GMIN-2025 | HILT CRC GMIN announcement | AU CRC collaboration signal | Loaded |
| AU-MINISTER-GMIN-2025 | Ministerial release on CSIRO/HILT GMIN | AU policy and funding signal | Loaded |
| GLOB-MICCUR | Linnaeus MiCCuR project page | EU/international biomining consortium benchmark | Loaded |
| GLOB-MIT-2017 | MIT molten sulfide electrolysis article | Long-horizon zero-SO2 process pathway | Loaded |
| GLOB-OXFORD-2023 | Oxford Smith School circular economy article | Circularity limit framing (recycling not sufficient alone) | Loaded |
| GLOB-IMMINING-2022 | International Mining summary of OZM challenge | Open-innovation and cross-border pilot pathway | Loaded |
| GLOB-REMADE | REMADE Institute site | US circular manufacturing funding/program signal | Loaded |
| FUND-ARC-LINKAGE | ARC Linkage program page | AU co-funded research pathway | Loaded |
| FUND-EDU-TRAILBLAZER | Education Trailblazer program page | AU commercialization pathway | Loaded |
| FUND-EDU-NIPHD | Education National Industry PhD page | AU workforce-industry linkage pathway | Loaded |

## Source Log
| Date | Source Key | Notes | Use in Synthesis |
|---|---|---|---|
| 2026-02-09 | SESSION-INIT | Seeded from discussion summary and planning scaffold | Yes |
| 2026-02-09 | AU-REQ-2025DEC | REQ Dec 2025 gives Australia copper exports and earnings outlook | Yes |
| 2026-02-09 | GLOB-IEA-2025 | IEA flags major copper supply-demand risk through 2035 | Yes |
| 2026-02-09 | AU-GLEN-OPS | Glencore confirms integrated Mount Isa smelter-Townsville refinery chain and refinery capacity statement | Yes |
| 2026-02-09 | AU-GLEN-HOA-2025 | Government support package indicates strategic but economically stressed midstream node | Yes |
| 2026-02-09 | AU-BHP-SA-2024 | BHP outlines SA smelter/refinery expansion pathway | Yes |
| 2026-02-09 | EU-CRMA-2024 | EU Act gives concrete extraction/processing/recycling governance template | Yes |
| 2026-02-09 | EU-ERMA-2020 | ERMA provides alliance-style partner coordination model | Yes |
| 2026-02-09 | US-DOE-CMA-2023 | Copper appears in DOE critical-material framing (energy relevance) | Yes |
| 2026-02-09 | TECH-CIR-2026-RSC | High-purity recovery from PCB route with LCA detail | Yes |
| 2026-02-09 | TECH-DIG-2025-MINENG | ML-based flotation performance prediction with interpretability | No (deferred; out of scope for this report) |
| 2026-02-09 | TECH-SORT-2024-MINENG | Copper bulk sorting field trial evidence for sensing-led preconcentration | No (deferred; out of scope for this report) |
| 2026-02-09 | TECH-REV-2024-RSTA | Broad review on non-ferrous extraction and recycling pathways | Yes |
| 2026-02-09 | PAY-SP-AGEAI-2026 | Full S&P copper/AI report added as local PDF | Yes |
| 2026-02-09 | PAY-SP-CONUN-2026 | S&P copper conundrum report added as local PDF | Yes |
| 2026-02-09 | PAY-WM-HIGHWIRE-2025 | WoodMac Horizons report added as local PDF | Yes |
| 2026-02-09 | PAY-FM-CATHPREM-2024 | Fastmarkets cathode premium methodology PDF added | Yes |
| 2026-02-09 | PAY-FM-CONC-2025 | Fastmarkets concentrates index methodology PDF added | Yes |
| 2026-02-09 | PAY-LANE-2016 | Minerals Engineering review PDF added and canonicalized | Yes |
| 2026-02-09 | PAY-YANG-2024 | JCP review PDF added and canonicalized | Yes |
| 2026-02-09 | PAY-TORRUBIA-2024 | JCP article PDF added and canonicalized | Yes |
| 2026-02-09 | PAY-DONG-2020 | CEJ article PDF added and canonicalized | Yes |
| 2026-02-09 | PAY-JADOUN-2025 | ACS ES&T Letters review PDF added and canonicalized | Yes |
| 2026-02-09 | PAY-WU-2025 | ACS Sustainable Chem Eng LCA PDF added and canonicalized | Yes |
| 2026-02-09 | DC-AEMO-OX-2025 | AEMO/Oxford data-center demand report downloaded to local folder | Yes |
| 2026-02-09 | AU-REQ-2025DEC | REQ Dec 2025 report downloaded as local PDF copy | Yes |
| 2026-02-09 | USGS-MCS-2026 | USGS MCS 2026 downloaded as local PDF copy | Yes |
| 2026-02-09 | EU-CRMA-2024 | EU CRMA legal text downloaded from EU Publications Office | Yes |
| 2026-02-10 | AU-UQ-BANKSIA-2025 | UQ startup page confirms Banksia, Vaughan, and Trailblazer-linked support context | Yes |
| 2026-02-10 | AU-UQ-ARC-2023 | UQ ARC Linkage page confirms copper ore processing project announcement | Yes |
| 2026-02-10 | AU-UQ-HYDROMET | UQ hydromet group page used for capability mapping (not quantitative claims) | Yes |
| 2026-02-10 | AU-UNSW-IID-2025 | UNSW IID feature used as value-add and industrial decarbonization context | Yes |
| 2026-02-10 | AU-UNSW-MICROFACTORY-2018 | UNSW microfactory page used for circular metallurgy narrative | Yes |
| 2026-02-10 | AU-UNSW-ARC-MICROREC | UNSW ARC Microrecycling Hub page used for current program evidence | Yes |
| 2026-02-10 | AU-CURTIN-C3MET-2024 | Curtin C3MET page confirms group scope and staffing signal | Yes |
| 2026-02-10 | AU-CURTIN-TRAILBLAZER | Curtin Trailblazer page used for commercialization-partnership pathway | Yes |
| 2026-02-10 | AU-CURTIN-KAL-2021 | Curtin Kalgoorlie lab release used for pilot-scale decarbonized pyro capability | Yes |
| 2026-02-10 | AU-ADEL-CUHUB | Adelaide Copper-Uranium Hub page confirms consortium composition and objective | Yes |
| 2026-02-10 | AU-CSIRO-GMIN-2025 | CSIRO GMIN release confirms $10m network and collaboration intent | Yes |
| 2026-02-10 | AU-HILT-GMIN-2025 | HILT GMIN page used as corroborating partner source | Yes |
| 2026-02-10 | AU-MINISTER-GMIN-2025 | Ministerial release used as policy-funding corroboration | Yes |
| 2026-02-10 | GLOB-MICCUR | MiCCuR project page confirms participants, timeframe, and pilot orientation | Yes |
| 2026-02-10 | GLOB-MIT-2017 | MIT page used as early-stage direct electrolysis pathway context | Yes |
| 2026-02-10 | GLOB-OXFORD-2023 | Oxford page used for circularity-limit framing in long-horizon demand scenarios | Yes |
| 2026-02-10 | GLOB-IMMINING-2022 | IM Mining page used to evidence open innovation challenge participation | Yes |
| 2026-02-10 | GLOB-REMADE | REMADE page used as US circular-manufacturing institutional signal | Yes |
| 2026-02-10 | FUND-ARC-LINKAGE | ARC program page used for funding mechanism description | Yes |
| 2026-02-10 | FUND-EDU-TRAILBLAZER | Education page used for Trailblazer program framing | Yes |
| 2026-02-10 | FUND-EDU-NIPHD | Education page used for National Industry PhD pathway framing | Yes |
| 2026-02-12 | AU-MINISTER-LANDMARK-2025 | Ministerial release used to verify support-package quantum for Glencore Mt Isa/Townsville node | Yes |
| 2026-02-12 | AU-BHP-SA-2025-EPCM | BHP EPCM contract release used to distinguish corporate capex from public subsidy signals | Yes |
| 2026-02-12 | AU-CURTIN-MPS-2024 | Curtin + MPS partnership release used to verify project-level co-funding quantum and copper-topic linkage | Yes |
| 2026-02-12 | AU-UNSW-ARC-HUB-2023 | UNSW hub-launch release used to verify ARC + industry funding structure for microrecycling program | Yes |
| 2026-02-12 | DATA-AU-CU-VC-CSV-2026 | Created value-chain collaboration register CSV with stage tags, named leads, and funding evidence-status fields | Yes |
| 2026-02-13 | T6-QA-CLOSURE-2026 | Completed full retained-quantitative claim audit for `WRITEUP.qmd`; created CSV/Markdown audit artifacts and synchronized Appendix A coverage wording | Yes |

## Lane B: Thematic Research Tracker (T1-T6)
| primary_topic_id | secondary_topic_id | focus | current_evidence (keys) | key_claims_under_test | major_gaps | decision_risk | evidence_readiness | next_action |
|---|---|---|---|---|---|---|---|---|
| T1 | T6 | Demand pull and AU value-chain structure | AU-REQ-2025DEC, GLOB-IEA-2025, AU-GLEN-OPS, AU-BHP-SA-2024, DC-AEMO-OX-2025 | C-001, C-005 | Harmonized AU capacity/flow table still incomplete | high | partial | Build one evidence-keyed flow map and align it with Appendix A quantitative claims |
| T2 | T3 | Primary/secondary route pathways and co-product-aware processing | PAY-LANE-2016, PAY-DONG-2020, PAY-YANG-2024, PAY-TORRUBIA-2024, PAY-WU-2025 | C-002, C-006, C-007 | AU-specific TEA assumptions and pilot-scale integration constraints | high | partial | Convert route options into bottleneck matrix and define one pilotable pathway per route family |
| T3 | T2 | Science 101 cross-cutting technology fundamentals | PAY-LANE-2016, PAY-WU-2025, PAY-YANG-2024, PAY-DONG-2020 | Supports C-006, C-007 | Risk of duplication with thematic/policy sections | medium | ready | Keep primer scoped to technical mechanisms; cross-reference T2/T6 only |
| T4 | T5 | AU/global research and collaboration landscape | AU-UQ-BANKSIA-2025, AU-UNSW-ARC-MICROREC, AU-CURTIN-C3MET-2024, AU-ADEL-CUHUB, GLOB-MICCUR | C-008 | Incomplete named leads and partner-specific constraints in several programs | medium | partial | Build ranked collaboration map with lead names, constraint access, and topic fit |
| T5 | T4 | Policy/program/funding pathways | FUND-ARC-LINKAGE, FUND-EDU-TRAILBLAZER, FUND-EDU-NIPHD, AU-CSIRO-GMIN-2025, AU-MINISTER-GMIN-2025 | C-004, C-008 | Project-level funding splits and mechanism-to-TRL mapping gaps | medium | partial | Map each funding mechanism to topic-specific research maturity stages |
| T6 | T1 | Evidence quality, gaps, and confidence controls | Claim ledger + Appendix A + Source Log + quantitative claim audit artifacts | C-001, C-002, C-004, C-005, C-006, C-007, C-008 | Harmonized AU capacity/flow table remains incomplete; maintain claim-audit sync as report evolves | high | ready | Keep quantitative-claim audit artifacts current and prioritize AU baseline quantification gaps in T1 |

## What We Can Already Include in the Strategy (High Utility Now)
- Australia framing: value capture depends on midstream competitiveness plus circularity, not only mining output.
- Global urgency: multiple authoritative outlooks point to structurally tight copper supply versus electrification demand.
- Midstream strategic-node argument: current Australian assets are economically sensitive but nationally significant.
- Research implication: mission design should be tied to near-term pilotability and operator pain points.
- Benchmark implication: EU/US examples are most useful as governance and portfolio models, not direct asset templates.

## Uncertain or Incomplete (Need Clarification / More Evidence)
- Exact and current Australian mine/smelt/refine capacity split by operator in one consistent dataset.
- Australia trade-flow detail by product class (concentrate vs refined vs semi-fabricated) in one harmonized table.
- Unit economics for candidate circular-copper pathways at pilot and early commercial scale.
- Data-center demand quantification suitable for partner engagement (loads, build pipeline, copper intensity ranges).
- Co-product treatment method for portfolio modeling (what is counted, baseline assumptions, sensitivity ranges).
- Downstream demand-pull partners: AU cable/tube/alloy and data-center supply-chain actors and their specification drivers.

## Australia Copper Value-Chain Collaboration Register (2026-02-12)
- Artifact: `topic01_copper/meta/au_copper_value_chain_collaboration_register.csv`.
- Scope: Australia-local copper value-chain collaborations with explicit stage mapping (`upstream`, `midstream`, `circular`) and publicly named leads where available.
- Coverage: 8 records spanning industry operators, startup commercialization, and industry-university/CRC-style programs.
- Fields captured: company/program, value-chain stage, named company lead, named academic/research lead, collaborators, topic, subsidy/funding amount, funding mechanism, evidence status, and sources.
- Data-quality rule used: if amounts or partner names are not explicitly public in cited sources, record as `Partially evidenced` rather than inferred.

## Important Papers and Reports Found (Initial Shortlist)
### Policy and Market (Priority A)
- AU-REQ-2025DEC: Department of Industry, Science and Resources, *Resources and Energy Quarterly: December 2025* ([link](https://www.industry.gov.au/publications/resources-and-energy-quarterly-december-2025)).
  - Why important: current Australia copper export/earnings outlook and demand narrative.
- GLOB-IEA-2025: IEA, *Global Critical Minerals Outlook 2025* copper sections ([overview](https://www.iea.org/reports/global-critical-minerals-outlook-2025/overview-of-outlook-for-key-minerals), [copper](https://www.iea.org/reports/copper-2)).
  - Why important: widely used global demand/supply framing; quantifies 2035 risk.
- EU-CRMA-2024: EU Council, final approval of the Critical Raw Materials Act (18 March 2024) ([link](https://www.consilium.europa.eu/en/press/press-releases/2024/03/18/strategic-autonomy-council-gives-its-final-approval-on-the-critical-raw-materials-act/)).
  - Why important: practical benchmark for value-chain risk governance and targets.
- US-DOE-CMA-2023: US DOE, *2023 Critical Materials Assessment* ([link](https://www.energy.gov/eere/ammto/articles/2023-doe-critical-materials-assessment)).
  - Why important: benchmark for portfolio logic linking energy transition to materials criticality.

### Australia Industry Structure (Priority A)
- AU-GLEN-OPS: Glencore operations pages for Mount Isa smelter + Townsville refinery ([refinery page](https://www.glencore.com.au/operations-and-projects/qld-metals/operations/copper-refineries)).
  - Why important: direct operator source for integrated midstream chain and process route.
- AU-GLEN-HOA-2025: Glencore release + joint ministerial release (8 Oct 2025) on support package ([Glencore](https://www.glencore.com.au/media-and-insights/news/agreement-reached-on-mount-isa-copper-smelter-and-townsville-copper-refinery), [Minister](https://www.minister.industry.gov.au/ministers/timayres/media-releases/landmark-deal-protect-regional-queensland-jobs-and-strengthen-australias-copper-capability)).
  - Why important: evidence that midstream is strategically important and economically exposed.
- AU-BHP-SA-2024: BHP media release (30 Aug 2024) on SA smelter/refinery expansion pathway ([link](https://www.bhp.com/es/news/media-centre/releases/2024/08/bhp-takes-next-step-in-smelter-and-refinery-expansion-at-copper-south-australia)).
  - Why important: second anchor pathway for domestic refining growth and partner engagement.

### Technical Evidence for Missions (Priority A/B)
- TECH-CIR-2026-RSC: Kelly et al. (2026), *Environmental Science: Advances*, DOI: 10.1039/D5VA00348B ([link](https://pubs.rsc.org/en/content/articlelanding/2026/va/d5va00348b)).
  - Why important: recent end-to-end copper recovery from PCB with LCA and scale-up implications.
- TECH-REV-2024-RSTA: Gerold et al. (2024), *Philosophical Transactions A*, DOI: 10.1098/rsta.2024.0173 ([link](https://pubmed.ncbi.nlm.nih.gov/39489176/)).
  - Why important: broad review for extraction/recycling options and sustainability framing.

## Broad Source Universe (Papers, Reports, Webpages)
### 1) Core market and policy baselines (open/public)
- IEA, *Global Critical Minerals Outlook 2025* ([overview](https://www.iea.org/reports/global-critical-minerals-outlook-2025/overview-of-outlook-for-key-minerals), [executive summary](https://www.iea.org/reports/global-critical-minerals-outlook-2025/executive-summary), [copper](https://www.iea.org/reports/copper-2)).
- USGS, *Mineral Commodity Summaries 2026* ([publication page](https://www.usgs.gov/publications/mineral-commodity-summaries-2026), [DOI landing](https://pubs.usgs.gov/publication/mcs2026)).
- ICSG, *World Copper Factbook 2025* ([link](https://icsg.org/copper-factbook/)).
- DISR (Australia), *Resources and Energy Quarterly: December 2025* ([link](https://www.industry.gov.au/publications/resources-and-energy-quarterly-december-2025)).
- Geoscience Australia, AIMR and preliminary tables ([AIMR](https://www.ga.gov.au/aimr2024/australias-identified-mineral-resources), [preliminary tables](https://www.ga.gov.au/scientific-topics/minerals/aimr/preliminary-tables)).
- ABS, *International Trade in Goods* ([latest release](https://www.abs.gov.au/statistics/economy/international-trade/international-trade-goods/latest-release)).
- WITS/UN Comtrade product-level trade (HS 260300) ([AU exports 2024](https://wits.worldbank.org/trade/comtrade/en/country/AUS/year/2024/tradeflow/Exports/partner/ALL/product/260300)).
- UN Comtrade bulk interface (alternative to WITS) ([portal](https://comtradeplus.un.org/)).
- World Bank, *Minerals for Climate Action: The Mineral Intensity of the Clean Energy Transition* ([link](https://www.worldbank.org/en/topic/extractiveindustries/publication/minerals-for-climate-action-the-mineral-intensity-of-the-clean-energy-transition)).
- OECD, *Global Material Resources Outlook to 2060* ([landing page](https://www.oecd.org/en/publications/global-material-resources-outlook-to-2060_9789264307452-en.html)).

### 2) Australia operator and value-chain pages (open/public)
- Glencore Townsville refinery and IsaKIDD process ([link](https://www.glencore.com.au/operations-and-projects/qld-metals/operations/copper-refineries)).
- Glencore + government support package (8 Oct 2025) ([Glencore](https://www.glencore.com.au/media-and-insights/news/agreement-reached-on-mount-isa-copper-smelter-and-townsville-copper-refinery), [Ministerial release](https://www.minister.industry.gov.au/ministers/timayres/media-releases/landmark-deal-protect-regional-queensland-jobs-and-strengthen-australias-copper-capability)).
- BHP smelter/refinery expansion pathway (30 Aug 2024) ([link](https://www.bhp.com/es/news/media-centre/releases/2024/08/bhp-takes-next-step-in-smelter-and-refinery-expansion-at-copper-south-australia)).
- BHP logistics for Copper SA (16 Jun 2025) ([link](https://www.bhp.com/news/media-centre/releases/2025/06/copper-sa-creates-major-logistics-solution-with-aurizon)).
- SA Government copper updates (context) ([link](https://www.energymining.sa.gov.au/home/news/latest/south-australia-accelerates-its-copper-to-the-world-as-demand-booms)).
- Australian Government, Critical Minerals (policy and programs hub) ([link](https://www.industry.gov.au/policies-and-initiatives/critical-minerals)).

### 2A) Australia research landscape and consortium mechanisms (open/public)
- UQ News (2025), Banksia copper process startup and commercialization context ([link](https://news.uq.edu.au/2025-02-17-uq-copper-processing-start-help-unlock-global-resources)).
- UQ Hydrometallurgy Group page ([link](https://chemeng.uq.edu.au/research/metallurgy-and-minerals-processing/hydrometallurgy-group)).
- UQ ARC Linkage awards page (includes copper processing project mention) ([link](https://news.uq.edu.au/2023-11-15-uq-researchers-awarded-arc-linkage-projects-funding)).
- UNSW Institute for Industrial Decarbonisation feature on value-adding mineral endowments ([link](https://www.unsw.edu.au/research/iid/features/value-adding-australian-mineral-endowments)).
- UNSW e-waste microfactory launch page ([link](https://www.unsw.edu.au/newsroom/news/2018/04/world-first-e-waste-microfactory-launched-at-unsw)).
- UNSW ARC Microrecycling Research Hub page ([link](https://www.smart.unsw.edu.au/research-programs/arc-microrecycling-research-hub)).
- Curtin C3MET group page ([link](https://research.curtin.edu.au/critical-minerals-metals-and-materials-for-the-energy-transition/)).
- Curtin Resources Technology and Critical Minerals Trailblazer page ([link](https://research.curtin.edu.au/trailblazer/)).
- Curtin Kalgoorlie research hub release (pilot pyromet context) ([link](https://www.curtin.edu.au/news/media-release/tomorrows-miners-help-map-greener-future-at-new-curtin-research-hub/)).
- University of Adelaide ARC Research Hub for Australian Copper-Uranium ([link](https://www.adelaide.edu.au/copper-uranium-research/)).
- CSIRO Green Metals Innovation Network release ([link](https://www.csiro.au/en/news/All/News/2025/June/Green-Metals-Innovation-Network)).
- HILT CRC matching announcement ([link](https://hiltcrc.com.au/news/csiro-and-hilt-crc-join-forces-to-accelerate-australias-green-metals-future/)).
- Ministerial release on CSIRO/HILT collaboration ([link](https://www.minister.industry.gov.au/ministers/timayres/media-releases/csiro-and-hilt-crc-lead-aussie-made-metals-collaboration)).

### 3) Data-center demand and copper relevance (open/public + industry)
- IEA, *Energy and AI* (2025) ([overview](https://www.iea.org/reports/energy-and-ai), [energy demand from AI](https://www.iea.org/reports/energy-and-ai/energy-demand-from-ai), [energy supply for AI](https://www.iea.org/reports/energy-and-ai/energy-supply-for-ai)).
- Berkeley Lab, *2024 United States Data Center Energy Usage Report* (DOI 10.71468/P1WC7Q) ([publication page](https://eta.lbl.gov/publications/2024-lbnl-data-center-energy-usage-report), [full report URL](https://escholarship.org/uc/item/32d6m0d1)).
- AEMO demand-forecasting update (data center growth to 2050) ([link](https://www.aemo.com.au/newsroom/news-updates/aemos-updated-forecasting-methodology-targets-rapidly-growing-electricity-loads)).
- Oxford Economics report for AEMO (data-center demand and "phantom demand") ([pdf](https://www.aemo.com.au/-/media/files/stakeholder_consultation/consultations/nem-consultations/2024/2025-iasr-scenarios/final-docs/oxford-economics-australia-data-centre-energy-consumption-report.pdf?la=en)).
- BHP insights on AI/data centers and copper intensity assumptions ([how copper will shape our future](https://www.bhp.com/news/bhp-insights/2024/09/how-copper-will-shape-our-future), [AI tools and data centres](https://www.bhp.com/news/bhp-insights/2025/01/why-ai-tools-and-data-centres-are-driving-copper-demand)).
- IEA, *Electricity 2024* (baseline electricity demand framing often used alongside data-centre narratives) ([link](https://www.iea.org/reports/electricity-2024)).

### 4) Circularity, recycling, and e-waste baselines (open/public)
- UNITAR/ITU, *Global E-waste Monitor 2024* ([overview](https://unitar.org/about/news-stories/press/global-e-waste-monitor-2024-electronic-waste-rising-five-times-faster-documented-e-waste-recycling), [publication page](https://www.itu.int/pub/D-GEN-E_WASTE.01)).
- ICSG copper recycling page ([link](https://icsg.org/copper-recycling/)).
- International Copper Association, copper recycling resource page ([link](https://internationalcopper.org/resource/copper-recycling/)).
- Australian Government (DCCEEW), National Television and Computer Recycling Scheme (NTCRS) overview ([link](https://www.dcceew.gov.au/environment/protection/waste/product-stewardship/television-and-computer-recycling-scheme)).

### 5) International benchmark architecture (EU/US)
- EU Critical Raw Materials Act legal text (Regulation (EU) 2024/1252) ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2024/1252/oj)).
- ERMA ecosystem pages ([homepage](https://erma.eu/), [about](https://erma.eu/about-us/)).
- US DOE, *2023 Critical Materials Assessment* ([link](https://www.energy.gov/eere/ammto/articles/2023-doe-critical-materials-assessment)).
- DOE Critical Materials Innovation Hub pages ([DOE page](https://www.energy.gov/eere/ammto/critical-materials-institute-energy-innovation-hub), [Ames page](https://www.ameslab.gov/cmi)).

### 5A) Global research landscape comparators (open/public)
- Linnaeus University MiCCuR project page (EU ERA-MIN/Horizon context) ([link](https://lnu.se/en/research/research-projects/project-microbial-consortia-for-enhanced-copper-recovery-miccur/)).
- MIT News (2017) on molten sulfide electrolysis route for copper and co-metals ([link](https://news.mit.edu/2017/new-way-of-extracting-copper-0628)).
- Oxford Smith School article on circular economy limits for copper demand (~50% by 2050 context) ([link](https://www.smithschool.ox.ac.uk/news/what-role-can-circular-economy-play-meeting-growing-demand-copper-and-other-critical-minerals)).
- International Mining summary of OZ Minerals Ingenious Extraction challenge ([link](https://im-mining.com/2022/06/10/oz-minerals-ingenious-extraction-challenge-throws-up-some-possible-answers-to-better-copper-recovery/)).
- REMADE Institute program site ([link](https://remadeinstitute.org/)).

### 5B) Funding and workforce pathways (open/public)
- ARC Linkage Projects program page ([link](https://www.arc.gov.au/linkage-projects)).
- Department of Education Trailblazer Universities Program ([link](https://www.education.gov.au/trailblazer-universities-program)).
- Department of Education National Industry PhD Program ([link](https://www.education.gov.au/national-industry-phd-program)).

### 6) Standards and market quality references
- LME copper contract page ([link](https://www.lme.com/en/metals/non-ferrous/lme-copper)).
- LME rulebook release showing Grade A quality references ([release PDF](https://www.lme.com/-/media/Files/Company/Market-regulation/Rulebook/Rulebook-revisions/Release-122.pdf)).
- ASTM B115-24 electrolytic copper cathode standard (paywalled standard text) ([store page](https://store.astm.org/b0115-24.html)).
- The Copper Mark assurance framework ([assurance](https://coppermark.org/assurance/), [about](https://coppermark.org/about/)).
- ISO 14040/14044 life cycle assessment standards (overview pages) ([ISO 14040](https://www.iso.org/standard/37456.html), [ISO 14044](https://www.iso.org/standard/38498.html)).
- ISO 14067 carbon footprint of products (overview page) ([link](https://www.iso.org/standard/71206.html)).

### 7) Technical paper universe (broad, mixed access)
- Kelly et al. (2026), PCB copper recovery + LCA, *Environmental Science: Advances*, DOI: 10.1039/D5VA00348B ([link](https://pubs.rsc.org/en/content/articlelanding/2026/va/d5va00348b)).
- Journal of Cleaner Production (2024), copper recovery from e-waste and decarbonisation, DOI: 10.1016/j.jclepro.2024.144349 ([link](https://www.sciencedirect.com/science/article/pii/S0959652624037983)).
- Journal of Cleaner Production (2024), review on copper recovery from e-waste, DOI: 10.1016/j.jclepro.2024.144286 ([link](https://www.sciencedirect.com/science/article/abs/pii/S0959652624037351)).
- ACS ES&T Letters (2024), metals recovery from e-waste review, DOI: 10.1021/acs.estlett.4c00696 ([link](https://pubs.acs.org/doi/10.1021/acs.estlett.4c00696)).
- ACS Sustainable Chem. Eng. (2025), LCA of cathode copper via bioleaching, DOI: 10.1021/acssuschemeng.5c06793 ([link](https://pubs.acs.org/doi/10.1021/acssuschemeng.5c06793)).
- Moosavi-Khoonsari and Tripathi (2024), copper anode slime processing review, *Processes*, DOI: 10.3390/pr12122686 ([link](https://www.mdpi.com/2227-9717/12/12/2686)).
- CEJ (2020), comprehensive recovery from copper anode slime, DOI: 10.1016/j.cej.2020.124762 ([link](https://www.sciencedirect.com/science/article/abs/pii/S1385894720307531)).
- Minerals Engineering (2016), selective leaching of penalty elements review, DOI: 10.1016/j.mineng.2016.08.006 ([link](https://www.sciencedirect.com/science/article/abs/pii/S0892687516302564)).
- Nature Geoscience (2020), mining-to-metal GHG transparency, DOI: 10.1038/s41561-020-0531-3 ([link](https://www.nature.com/articles/s41561-020-0531-3)).

### 8) Deferred (Out of Scope for This Report; Keep for Later)
The following items are useful for future work but are explicitly **out of scope** for the current report (no digital/sensing mission).

### Digital process control / sensing / ore sorting (deferred)
- TECH-DIG-2025-MINENG: *Minerals Engineering* (2025), DOI: 10.1016/j.mineng.2025.109492 ([link](https://www.sciencedirect.com/science/article/pii/S0892687525003206)).
- TECH-SORT-2024-MINENG: *Minerals Engineering* (2024), DOI: 10.1016/j.mineng.2024.108664 ([link](https://doi.org/10.1016/j.mineng.2024.108664)).
- TECH-SENSOR-2022: Peukert et al. (2022), *Minerals*, DOI: 10.3390/min12111364 ([link](https://doi.org/10.3390/min12111364)).
- Szmigiel et al. (2024), ML in flotation review, *Minerals*, DOI: 10.3390/min14040331 ([link](https://www.mdpi.com/2075-163X/14/4/331)).
- Minerals Engineering (2024), deep-learning mineralogy in copper flotation pulp, DOI: 10.1016/j.mineng.2023.108481 ([link](https://www.sciencedirect.com/science/article/pii/S0892687523004958)).
- BHP refining automation case (30 Jan 2026) ([link](https://www.bhp.com/news/articles/2026/01/automation-delivers-a-safer-more-inclusive-future-for-copper-refining)).

### 8) Paywall Priority List (If user can share PDFs)
- Received and ingested: S&P 2026 reports, WoodMac 2025 report, Fastmarkets methodology PDFs, and key JCP/ACS/CEJ/ME papers.
- CRU, *Copper Monitor* and *Copper Raw Materials Monitor* (subscription products; TC/RC and market balances).
- Fastmarkets full paid data history for TC/RC and cathode premia (methodology pages are public; data series are paid).
- ASTM B115-24 full text (standard details beyond store metadata).
- Additional plant-level smelter/refinery benchmark data (if available from subscription databases).

## Distilled Knowledge
- Current framing emphasizes not just upstream extraction but end-to-end value capture.
- Australian midstream appears structurally important and potentially constrained relative to concentrate output.
- Circular copper opportunity likely depends on technical capability for complex feed separation and metallurgy.
- Research strategy must be tightly coupled to partner strategy; missions should be designed with co-development paths.
- New market intelligence corpus materially strengthens data-center demand and copper deficit narratives.
- New technical corpus broadens Mission 2 evidence from lab studies to process-pathway and LCA-based comparisons.
- Remaining quantitative gap is less about direction and more about harmonized Australia-specific capacity, trade, and cost tables.

## Claim Ledger (Draft)
| Claim ID | Claim | Evidence Keys | Confidence | Status |
|---|---|---|---|---|
| C-001 | Australia has a midstream pinch point that limits domestic value capture. | MID-01, AUVC-01, AU-GLEN-HOA-2025, AU-BHP-SA-2024 | Medium | Supported, refine with quantitative table |
| C-002 | Circular copper from complex scrap is underdeveloped but high-leverage. | CIR-01, TECH-CIR-2026-RSC, TECH-REV-2024-RSTA | Medium | Supported, needs AU-specific economics |
| C-004 | EU/US benchmarks are useful for portfolio and partnership architecture. | BENCH-EU-01, BENCH-US-01, EU-CRMA-2024, EU-ERMA-2020, US-DOE-CMA-2023 | Medium | Supported |
| C-005 | Data-center buildout is the primary demand-side anchor for near-term copper partnership positioning. | PAY-SP-AGEAI-2026, PAY-SP-CONUN-2026, PAY-WM-HIGHWIRE-2025, GLOB-IEA-2025, DC-AEMO-OX-2025 | Medium | Supported with page anchors; maintain scenario-spread caveat |
| C-006 | Impurity management and secondary-feed metallurgy are central to midstream and circular economics. | PAY-LANE-2016, PAY-DONG-2020, PAY-YANG-2024, PAY-TORRUBIA-2024 | Medium | Supported; map to project TRLs |
| C-007 | Low-carbon process routes (including bioleaching pathways) can contribute but require scale and cost validation. | PAY-WU-2025, TECH-CIR-2026-RSC, TECH-REV-2024-RSTA | Medium | Supported; requires AU scaling assumptions |
| C-008 | Two-mission framing (midstream + circular) maximizes AU research leverage and partner pull. | C-001, C-002, C-005, C-006 | Medium | Strategy structure locked for report |

## Draft Mission Set (Working)
1. Low-carbon, impurity-tolerant midstream processing and competitiveness.
2. Circular copper and alloy loops from complex secondary feeds.

## Pilot/Testbed Asset Notes
- To map: industry plants, university labs, pilot infrastructure, data platforms, and missing capability.
- Output needed: near-term demonstrators (12-24 months) + strategic bets (3-7 years).

## Daily Log
### 2026-02-09
- Worked on:
  - Initialized literature review workspace and split-document workflow.
  - Captured scope, hypotheses, action list, and mission skeleton from prior discussion.
  - Loaded first-pass source pack (policy/industry/technical) and mapped it to claims.
  - Added "include-now" content, uncertainty list, and important-paper shortlist.
- Planned next steps:
  - Build a one-page value-chain + trade-flow table with evidence keys.
  - Add page-anchored citations into WRITEUP for each validated claim.
  - Build first-pass data-center demand evidence pack and define co-product accounting method.
  - Expand technical reading on circular economics and Australian deployment cases.
- Blocked by:
  - None (end-use priority and system boundary confirmed).

### 2026-02-09 (Ingestion Update)
- Worked on:
  - Ingested new user-supplied paywalled reports/papers into `topic01_copper/`.
  - Renamed all non-canonical PDFs to canonical `Author et al. - YEAR - Title.pdf` format.
  - Updated citation map, source log, and claim ledger with new evidence keys.
- Planned next steps:
  - Extract page-anchored quotes/tables from S&P, WoodMac, Fastmarkets, and key JCP/ACS papers.
  - Insert high-confidence citations into `WRITEUP.qmd` and add a formal references block.
  - Build one harmonized table for AU capacity/trade/cost signals linked to C-001/C-005/C-006.
- Blocked by:
  - CRU paid datasets and full ASTM text still pending access.

### 2026-02-09 (Open-Source Download Update)
- Worked on:
  - Downloaded open-reference PDFs directly into `topic01_copper/` (REQ 2025, USGS MCS 2026, AEMO/Oxford data-center report, EU CRMA text).
  - Confirmed digital process control/sensing is out of scope for this report; moved related items to `Deferred` to avoid scope creep.
- Planned next steps:
  - Move straight to page-anchored extraction from the high-priority local PDFs for WRITEUP evidence insertion.
- Blocked by:
  - Berkeley Lab data-center report PDF download endpoint was not directly accessible from this environment.

### 2026-02-09 (Formal Rewrite Implementation)
- Worked on:
  - Added standing formal-writeup guardrails near the top of this working note.
  - Rewrote `WRITEUP.qmd` into a standalone, readable research report structure.
  - Replaced placeholder citation markers with page-anchored citations for key claims.
- Planned next steps:
  - Run a final technical edit pass for phrasing consistency and citation density balance.
  - Export the report to PDF for circulation if needed.
- Blocked by:
  - None for current report package.

### 2026-02-09 (Strict Role-Separation Refactor)
- Worked on:
  - Enforced strict split between research driver and distilled output using a new `Document Role Contract`.
  - Refactored `WRITEUP.qmd` into a standalone shareable report with integrated executive summary and integrated references.
  - Removed workflow/process-management content from `WRITEUP.qmd` and kept those controls in `WORKING_NOTE.md`.
  - Consolidated into a single shareable artifact: `WRITEUP.qmd` (derivative summary/reference files removed to avoid confusion).
- Planned next steps:
  - Perform one final style pass for tone/flow consistency before circulation.
  - Export standalone `WRITEUP.qmd` to PDF when ready.
- Blocked by:
  - None for current standalone writeup delivery.

### 2026-02-09 (Narrative Report Revision)
- Worked on:
  - Removed “Decision requests” language/sections from `WRITEUP.qmd` and rewrote the report to be narrative-first (logic and facts), with dot points used only where helpful.
  - Reduced main-body table density (kept only small “Demand numbers” and “Structural nodes” tables; kept evidence traceability as Appendix A).
  - Updated `WORKING_NOTE.md` guardrails to enforce narrative-first, table-light report style going forward.
- Planned next steps:
  - Build the AU baseline table (capacities/flows/constraints) and insert it into Section 4 with evidence keys.
  - Expand Appendix A to cover any new quantitative statements added in future revisions.
- Blocked by:
  - AU owner/operator and capacity/flow harmonisation is still incomplete in the current corpus.

### 2026-02-10 (Landscape Expansion for Formal Report)
- Worked on:
  - Added a new research-landscape evidence pack (Australia institutions, global comparators, and funding pathways) to the working-note citation map and source log.
  - Scoped additions for `WRITEUP.qmd` to be narrative-first with minimal tables and no internal decision-language.
  - Reconfirmed scope lock that digital process control/sensing remains deferred in this report.
- Planned next steps:
  - Insert and integrate a full `Research Landscape and Strategic Alignment` section in `WRITEUP.qmd`.
  - Renumber report sections and refresh references to include the new web sources used in the narrative.
  - Re-run verification and regenerate `WRITEUP.pdf`.
- Blocked by:
  - No blocker for report revision; some global examples remain illustrative because primary technical datasets are not locally held.

### 2026-02-10 (Scientific 101 + Report Readability Pass)
- Worked on:
  - Inserted a main-body `Scientific 101: Technology Primers` section into `WRITEUP.qmd` to explain the core process routes and analytical toolchain in plain language.
  - Renumbered the report and refactored work packages into narrative-first text with fewer repeated templates, cross-linked to the primers.
- Planned next steps:
  - Regenerate `WRITEUP.pdf` and do a quick consistency pass (section numbers, references, and any remaining “template-y” phrasing).
  - Decide whether to expand the AU baseline with a harmonized capacity/flow table (evidence-keyed) in the next session.
- Blocked by:
  - None for the current report revision package.

### 2026-02-12 (Value-Chain Collaboration Register + Subsidy Verification)
- Worked on:
  - Re-reviewed Australia-local collaboration evidence with explicit copper value-chain tagging.
  - Verified named-lead and funding/subsidy fields against primary pages; separated `Directly evidenced` vs `Partially evidenced` records.
  - Created `topic01_copper/meta/au_copper_value_chain_collaboration_register.csv` (8 records) for operational partner mapping.
  - Updated `WRITEUP.qmd` to reference the register as a maintained evidence artifact for partnership positioning.
- Planned next steps:
  - Add missing partner-level details where public disclosures are currently incomplete (especially project-level grant splits and named industry R&D leads).
  - Convert the CSV into a ranked engagement list (impact x feasibility x partner pull) for mission execution planning.
- Blocked by:
  - Several programs publish support/funding signals without full project-level amount splits or named company research leads.

### 2026-02-13 (Two-Lane Remap + T1-T6 Tracker)
- Worked on:
  - Locked a two-lane operating model in `WORKING_NOTE.md` with explicit separation of operational control (Lane A) and thematic tracking (Lane B).
  - Implemented canonical topic IDs (`T1`-`T6`) and added a structured tracker with required fields: risk, readiness, and next action.
  - Rewrote next actions into a risk-first queue linked to topic IDs.
- Planned next steps:
  - Apply the same topic-ID structure to `WRITEUP.qmd` section architecture.
  - Publish a topic-index crosswalk artifact for legacy-to-new section traceability.
  - Run final traceability check across `WRITEUP` claims, Appendix A anchors, and source-log keys.
- Blocked by:
  - None for the remap implementation itself; remaining blockers are evidence-completeness related (already tracked under T6).

### 2026-02-13 (WRITEUP Modularization Pack)
- Worked on:
  - Split `WRITEUP` content into ordered modules (`00`-`06` + `90`) while keeping `WRITEUP.qmd` as full standalone narrative.
  - Rebuilt `WRITEUP.qmd` in the locked topic sequence (`T1` -> `T2` -> `T3` -> `T4` -> `T5` -> `T6`) with centralized references/appendices still included inline.
  - Updated crosswalk structure to include module-file and final-report location fields.
- Planned next steps:
  - Keep module-first editing discipline for all topic updates and run periodic drift checks (`module` vs `WRITEUP.qmd`).
  - Expand Appendix A page-anchors as T6 high-risk evidence actions are closed.
- Blocked by:
  - No structural blocker; remaining constraints are evidence availability and partial public disclosures in selected funding/partner records.

### 2026-02-13 (Session Closure Handover)
- Worked on:
  - Preserved session context for restart by confirming all major planning decisions are logged in this file and in `topic01_copper/meta/TOPIC_INDEX_AND_CROSSWALK.md`.
  - Removed institution-specific narrative framing from `WORKING_NOTE.md`, `WRITEUP.qmd`, `04_T4_research-and-collaboration-landscape.md`, and `topic01_copper/meta/notes.md`.
  - Kept factual collaborator references in `topic01_copper/meta/au_copper_value_chain_collaboration_register.csv` where they are evidence-bearing fields.
- Planned next steps:
  - On restart, continue from the existing risk-first queue (`T1`, `T6`, then `T2`) and maintain module-first update discipline.
  - Keep `WORKING_NOTE.md` as the operational control plane and `WRITEUP.qmd` as the standalone synthesis artifact.
- Blocked by:
  - No operational blocker; remaining limits are evidence granularity and partially disclosed funding splits in public sources.

### 2026-02-13 (T6 Quantitative Evidence Closure Pass)
- Worked on:
  - Completed a full retained-quantitative claim audit over `WRITEUP.qmd` and generated `topic01_copper/meta/quantitative_claim_audit.csv` plus `topic01_copper/meta/quantitative_claim_audit.md`.
  - Updated module files first (`00`, `04`, `05`, `06`, `90`) and synced corresponding sections in `WRITEUP.qmd`.
  - Reframed non-source-anchored numeric wording as qualitative where required (timeline/count-style statements), while preserving page-anchored quantitative evidence claims.
  - Updated Appendix A coverage language to explicit retained-quantitative scope and aligned claim-location notes.
- Planned next steps:
  - Keep audit artifacts synchronized as claims evolve and re-run quick line-level checks after each writeup edit pass.
  - Prioritize T1 harmonized AU capacity/flow quantification to move `C-001` from directional to stronger quantitative support.
  - Build the T2 bottleneck matrix with impact/feasibility/partner-pull scoring linked to existing claim IDs.
- Blocked by:
  - No operational blocker for traceability controls; remaining blocker is missing harmonized AU capacity/flow baselines for deeper quantification.
