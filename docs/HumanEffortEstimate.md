# Human Effort Estimate — SIC Code Classification

**Date:** 2026-09-26 · **Estimated by:** Main role, Claude Sonnet 5 · **Basis:** `docs/DesignDoc.md` v1 · **Reviewed by:** pending

> **What this is.** The billable hours an **experienced senior AL developer** (5+ years of Business
> Central extension work, fluent in AL, the AL tools, and the standards this project applies) would
> need to deliver the same scope by hand, working from the same requirements. It is an **estimate**
> for reading next to the measured AI cost in `docs/UsageReport.md`, not a quote, not a timesheet,
> and not a claim about any particular developer. Every assumption is in §1 so the reader can
> change it.

## 1. Assumptions

| Assumption | Value used | Change it if |
|---|---|---|
| Developer profile | Senior AL developer, works alone, no ramp-up on BC | a team, or a developer new to BC |
| Working day | 8 billable hours | |
| Requirements | As complete as `docs/DesignDoc.md`; no re-discovery, including sourcing the SIC data itself | the human would also research SIC codes and locate/clean a source dataset from scratch (add 2–4h) |
| Testing | Manual sandbox testing by the developer | a separate QA function |
| Meetings, reviews, sign-offs | Included as *Review and sign-off* | |
| Baselines | Framework defaults, low end unless complexity says otherwise (this is a small, well-scoped extension) | your own rate card or history |
| Data acquisition | Bundling the ~1,005-row SIC dataset as a resource file is counted under the Import codeunit task, not separately | the dataset needs licensing/legal review |

## 2. Baselines used

| Task | Unit | Baseline (h) |
|---|---|---|
| Technical design (TDD-equivalent) | per 10 objects | 6 – 12 |
| New table | each | 2 – 4 |
| Table extension | each | 1 – 2 |
| List / card page | each | 2 – 4 |
| Page extension | each | 1 – 2 |
| Codeunit — helpers, simple validation | each | 2 – 4 |
| Permission set (VIEW + EDIT pair) | per pair | 1 – 2 |
| Assisted setup wizard | each feature | 4 – 8 |
| Compile / package / deploy troubleshooting | share of build hours | 10 – 20 % |
| Code review and fixes | share of build hours | 10 – 15 % |
| Documentation, user guide, test script | per project | 4 – 12 |
| Release testing support and fixes | per project | 2 – 6 |

## 3. Estimate by task

| # | Task | Object(s) / scope | Complexity and why | Hours | Framework step |
|---|---|---|---|---|---|
| 1 | Requirements & problem statement | Domain research (SIC structure, sources), scope decisions | Low-medium — small scope, but SIC domain knowledge and locating a usable dataset take real time for someone unfamiliar with it | 3 | Lite 1 |
| 2 | Technical design | 8 objects, full field/ID/permission spec | Low — small object count, no header/line, no number series, no upgrade code | 6 | Lite 2 |
| 3 | Table — ocpfsicSicCode (77071) | 1 table, 6 fields, block-if-referenced delete | Low-medium — simple schema, one non-trivial delete-guard trigger | 3 | Lite 4 |
| 4 | Page — ocpfsicSicCodes list (77072) | 1 list page | Low — plain list, no complex logic | 2 | Lite 4 |
| 5 | Table + page extension — Customer (77073/77074) | 1 table ext (2 fields incl. FlowField), 1 page ext | Low — small, standard pattern | 2 | Lite 4 |
| 6 | Codeunit — SIC Code Import (77075) | 1 codeunit, resource parsing, idempotent upsert, override-protection for Division Name | Medium — parsing ~1,005 rows correctly, upsert logic, and preserving manual edits on re-import add real care | 6 | Lite 4 |
| 7 | Assisted Setup Wizard (77076) | 1 wizard page | Medium — first-run UX, re-run safety, progress/result messaging | 5 | Lite 4 |
| 8 | Permission sets (77077/77078) | 1 VIEW/EDIT pair | Low | 1.5 | Lite 4 |
| 9 | Compile / package / deploy troubleshooting | Share of tasks 3–8 (19.5h) at 15% | 15% of 19.5h | 3 | Lite 5 |
| 10 | Code review and fixes | Share of tasks 3–8 (19.5h) at 12% | 12% of 19.5h | 2.5 | Lite 6 |
| 11 | Manual sandbox testing (functional pass) | Whole extension, single-language | Low — small scope, no upgrade path to test (first release) | 3 | Lite 5–7 |
| 12 | Documentation set | Docs.md, TestScript.md | Small project, one language | 4 | Lite 6 |

## 4. Totals

| Phase | Hours | Days (8 h) |
|---|---|---|
| DEFINE + DESIGN | 9 | 1.1 |
| BUILD | 22.5 | 2.8 |
| PROVE | 7 | 0.9 |
| **Total** | 38.5 | 4.8 |

## 5. What would move this estimate

- If a cleaner, officially machine-readable SIC dataset can't be found and one has to be scraped/
  cleaned from OSHA's HTML manual by hand, add 2–4h to task 1 and possibly task 6.
- If Major Group *names* (not just codes) are added later as a full 83-row breakdown, that's a new
  small reference table + import logic — add roughly 3–4h.
- If a second country/language is added later, translation setup and a glossary become required
  (Standards Part 8) — not included here since Step 1 chose US-only, no translation files.

## Before calling this done
- [x] Every object in the Object Register (`docs/DesignDoc.md` B11) appears in §3, alone or grouped.
- [x] Every row's hours can be traced to a §2 baseline and a stated complexity reason.
- [x] §1 lists every assumption a reader would need to change to reuse this estimate.
- [x] The step column lets `docs/UsageReport.md` sum these hours per framework step.
