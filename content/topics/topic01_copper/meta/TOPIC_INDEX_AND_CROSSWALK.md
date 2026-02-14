# Topic Index and Crosswalk

## Purpose
This artifact defines the canonical topic IDs (`T1`-`T6`) and maps legacy section structure to the remapped two-lane operating model.

## Canonical Topic Index
| topic_id | topic_name | boundary_notes |
|---|---|---|
| T1 | Demand Pull + Australia Value-Chain Structure | Demand/flow architecture only; separate from process-route mechanics |
| T2 | Processing Pathways Across Primary/Secondary Feeds and Co-products | Route logic, bottlenecks, and mission work packages |
| T3 | Science 101 Technology Primer | Fundamentals only; no policy/program framing |
| T4 | Research and Collaboration Landscape | Capability and partner landscape (AU + selected global comparators) |
| T5 | Policy, Funding, and Programs | Funding mechanisms, policy architecture, implementation pathways |
| T6 | Evidence Quality, Gaps, and Confidence | Confidence/gap controls only; no new thematic argument |

## Interface Contract
### Topic-ID interface
- Required IDs: `T1`, `T2`, `T3`, `T4`, `T5`, `T6`.
- `WRITEUP.qmd`: each thematic block maps to one primary topic ID.
- `WORKING_NOTE.md` Lane B tracker: each row includes one primary topic ID and optional secondary topic ID.

### Crosswalk interface
For each mapped row:
- `legacy_section`
- `new_topic_id`
- `module_file` (or `N/A` for operational-only content)
- `final_writeup_location` (or `N/A` for operational-only content)
- `status` (`moved`, `split`, `retained_operational`, `deferred`)

### Priority interface
Lane B rows include:
- `decision_risk` (`high`, `medium`, `low`)
- `evidence_readiness` (`ready`, `partial`, `weak`)
- `next_action`

## Crosswalk: WORKING_NOTE.md
| legacy_section | new_topic_id | module_file | final_writeup_location | status |
|---|---|---|---|---|
| Current Snapshot | T1,T2,T4 | N/A | N/A | split |
| Decision Scope | T1,T2,T4 | N/A | N/A | retained_operational |
| Locked Decisions | T1,T2 | N/A | N/A | split |
| Formal Writeup Guardrails | T6 | N/A | N/A | retained_operational |
| Document Role Contract | T6 | N/A | N/A | retained_operational |
| Ingestion Batch | T6 | N/A | N/A | retained_operational |
| Working Hypotheses | T2,T6 | N/A | N/A | split |
| Next Actions | T1,T2,T3,T4,T5,T6 | N/A | N/A | moved |
| Reading Queue | T6 | N/A | N/A | retained_operational |
| Source Access Table | T6 | N/A | N/A | retained_operational |
| Citation Map | T1,T2,T3,T4,T5,T6 | N/A | N/A | split |
| Source Log | T6 | N/A | N/A | retained_operational |
| What We Can Already Include in the Strategy | T1,T2,T4,T5 | N/A | N/A | split |
| Uncertain or Incomplete | T6 | N/A | N/A | moved |
| Australia Copper Value-Chain Collaboration Register | T4,T5 | N/A | N/A | split |
| Important Papers and Reports Found | T1,T2,T5 | N/A | N/A | retained_operational |
| Broad Source Universe | T1,T2,T3,T4,T5,T6 | N/A | N/A | retained_operational |
| Deferred (Out of Scope) | T6 | N/A | N/A | split |
| Distilled Knowledge | T1,T2,T4,T5 | N/A | N/A | moved |
| Claim Ledger (Draft) | T6 | N/A | N/A | moved |
| Draft Mission Set (Working) | T2 | N/A | N/A | moved |
| Pilot/Testbed Asset Notes | T2,T4 | N/A | N/A | split |
| Daily Log | T6 | N/A | N/A | retained_operational |

## Crosswalk: WRITEUP.qmd
| legacy_section | new_topic_id | module_file | final_writeup_location | status |
|---|---|---|---|---|
| Abstract + Executive Summary + Introduction + Methods + Topic Interface | T6 (control framing) | `00_overview.md` | top sections before `T1` | moved |
| Scientific 101: Technology Primers | T3 | `03_T3_science-101.md` | `T3` section | moved |
| Demand Context and End-Use Framing | T1 | `01_T1_demand-and-value-chain.md` | `T1.1`-`T1.3` | moved |
| Australia Copper Value Chain: Baseline and Structural Nodes | T1 | `01_T1_demand-and-value-chain.md` | `T1.4` series | moved |
| Copper Research Landscape and Strategic Alignment (6.1, 6.2) | T4 | `04_T4_research-and-collaboration-landscape.md` | `T4.1`, `T4.2` | moved |
| Funding and support mechanisms aligned to prior sectioning (6.3) | T5 | `05_T5_policy-funding-programs.md` | `T5.1` | moved |
| Implications for prior scope sectioning (6.4) | T5 | `05_T5_policy-funding-programs.md` | `T5.2` | moved |
| Bottlenecks and Value-Capture Hypotheses | T2 | `02_T2_processing-pathways.md` | `T2.1`, `T2.2` | moved |
| Research Missions and Work Packages | T2 | `02_T2_processing-pathways.md` | `T2.3` and mission subblocks | moved |
| Partnership Positioning | T4 | `04_T4_research-and-collaboration-landscape.md` | `T4.3` | moved |
| Roadmap and Deliverables (Evidence-Gap Closing) | T6 | `06_T6_evidence-quality-gaps-confidence.md` | `T6.1`-`T6.3` | moved |
| Confidence posture and implications section | T6 | `06_T6_evidence-quality-gaps-confidence.md` | `T6.4`, `T6.5` | moved |
| References + Appendix A/B/C | T4,T5,T6 | `90_references-and-appendices.md` | References + Appendix A/B/C | moved |

## Unresolved Placements
- None unresolved at this pass.
- Deferred content remains explicitly marked in `WORKING_NOTE.md` (`Deferred` section) and treated as `T6` control content until promoted.

## Validation Checklist
- Every legacy section in the crosswalk has exactly one status entry.
- Topic IDs are constrained to `T1`-`T6`.
- Lane A (operational) and Lane B (thematic tracker) are explicitly separated in `WORKING_NOTE.md`.
- `WRITEUP.qmd` thematic structure is mapped to `T1`-`T6` and confidence/gap controls are under `T6`.
- `WRITEUP.qmd` module-source map points to `00`-`06` and `90` files.
