# Quantitative Claim Audit (T6 Closure Pass)

## Scope
- Target file: `content/topics/topic01_copper/WRITEUP.qmd`
- Policy: local corpus only
- Coverage: retained quantitative claims (body + tables + Appendix A quantitative rows)

## Summary Counts
| Metric | Value |
|---|---:|
| Total retained quantitative claim rows audited | 18 |
| `status = anchored` | 18 |
| `appendix_a_present = yes` | 18 |
| Missing from Appendix A | 0 |
| Unresolved numeric claims | 0 |

## Claim-ID Distribution
| Claim ID | Rows |
|---|---:|
| C-005 | 9 |
| C-001 | 2 |
| C-002 | 4 |
| C-004 | 2 |
| C-007 | 1 |

## Audit Table
| claim_uid | claim_id | line_ref | quant_value | unit_or_metric | inline_source | page_anchor | appendix_a_present | status | resolution_action |
|---|---|---:|---|---|---|---|---|---|---|
| QCL-001 | C-005 | 19 | 28 -> 42 | Mt | S&P Global, 2026a | p. 9 | yes | anchored | retained_quantitative |
| QCL-002 | C-005 | 19 | 42.7 | Mtpa | Wood Mackenzie, 2025 | p. 3 | yes | anchored | retained_quantitative |
| QCL-003 | C-005 | 20 | 3.9; 12.0; 34.5 | TWh | AEMO and Oxford Economics, 2025 | p. 4 | yes | anchored | retained_quantitative |
| QCL-004 | C-001 | 21 | 12.565 -> 17.648 | A$ billion (nominal) | DISR, 2025 | p. 60 | yes | anchored | retained_quantitative |
| QCL-005 | C-002 | 23 | 20-25 | percent | Yang, Wu and Zhang, 2024 | p. 4 | yes | anchored | retained_quantitative |
| QCL-006 | C-007 | 24 | 18 | percent | Wu et al., 2025 | p. 7 | yes | anchored | retained_quantitative |
| QCL-007 | C-005 | 88 | 28 -> 42 | Mt | S&P Global, 2026a | p. 9 | yes | anchored | retained_quantitative |
| QCL-008 | C-005 | 88 | 42.7 | Mtpa | Wood Mackenzie, 2025 | p. 3 | yes | anchored | retained_quantitative |
| QCL-009 | C-005 | 96 | 3.9; 12.0; 34.5 | TWh | AEMO and Oxford Economics, 2025 | p. 4 | yes | anchored | retained_quantitative |
| QCL-010 | C-005 | 101 | 28 -> 42 | Mt | S&P Global, 2026a | p. 9 | yes | anchored | retained_quantitative |
| QCL-011 | C-005 | 102 | 42.7 | Mtpa | Wood Mackenzie, 2025 | p. 3 | yes | anchored | retained_quantitative |
| QCL-012 | C-005 | 103 | 3.9; 12.0; 34.5 | TWh | AEMO and Oxford Economics, 2025 | p. 4 | yes | anchored | retained_quantitative |
| QCL-013 | C-001 | 116 | 12.565 -> 17.648 | A$ billion (nominal) | DISR, 2025 | p. 60 | yes | anchored | retained_quantitative |
| QCL-014 | C-004 | 126 | 10; 40; 25 | percent | European Union, 2024 | p. 3 | yes | anchored | retained_quantitative |
| QCL-015 | C-002 | 139 | 20-25 | percent | Yang, Wu and Zhang, 2024 | p. 4 | yes | anchored | retained_quantitative |
| QCL-016 | C-002 | 200 | 20-25 | percent | Yang, Wu and Zhang, 2024 | p. 4 | yes | anchored | retained_quantitative |
| QCL-017 | C-002 | 533 | 20-25 | percent | Yang, Wu and Zhang, 2024 | p. 4 | yes | anchored | retained_quantitative |
| QCL-018 | C-004 | 534 | 10; 40; 25 | percent | European Union, 2024 | p. 3 | yes | anchored | retained_quantitative |

## Qualitative Downgrades Applied in This Pass
- Converted timeline-style numeric headings to qualitative wording in `T6` (`Near-term`, `Pilotable`, `Longer-horizon`) and removed numeric timeline phrasing in `T5.2`.
- Replaced date/count-style numeric register metadata in Appendix C with qualitative wording.
- Rephrased Oxford circularity sentence to remove an unsupported explicit year-bound numeric framing while retaining source-backed direction.
