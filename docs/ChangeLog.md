# ChangeLog — SIC Code Classification

Ground truth for what was actually built and why. Every deviation from the design, every root-cause
fix, every decision — logged before the next batch begins, newest first within a step. Name the
person, never a role. Superseded decisions stay, marked superseded.

**Lite entry format** (Issue / Feedback / Deferred in one log):
```
## <Type> <SeqNo> — <Short Description>
**Problem:** What was wrong, missing, or requested.
**Root cause:** Why it happened (Issue/Feedback only).
**Resolution:** What was changed, or why it was deferred/rejected.
**Files affected:** List of changed files.
**Design Doc updated:** yes/no.
```

---

## Deferred 7 — Step 7 closed: functional test pass green, release candidate marked (2026-09-27)

**Problem:** N/A — recording the exit-gate confirmation and release marking, not a defect.
**Root cause:** N/A.
**Resolution:** AJ ran `docs/TestScript.md` end to end against
`outputAppPackage/SIC_Code_Classification_1.0.1.0.app` on the sandbox: every green-team case
(TC-1–TC-9) passed and every red-team case (TC-10–TC-15) failed gracefully, with no findings.
Language pass N/A (US wording only, no translation files). Upgrade-path testing N/A — this is the
first release; no prior version has been installed anywhere real (Standards §9.6, Design Doc B6).
Permission sets verified as part of the same pass: `OCPFSIC SIC, VIEW` reads everywhere;
`OCPFSIC SIC, EDIT` reads and writes on the editable pages.
Per the Step 7 exit gate, the tested package is now marked as the release candidate: `app.json`
bumped `1.0.1.0` → `1.0.1.1` (Revision segment only, no code change) and rebuilt — 0 errors,
0 warnings — as `outputAppPackage/SIC_Code_Classification_1.0.1.1.app`, so the exact artifact that
passed testing stays permanently identifiable, distinct from any future rebuild that might reuse
the `1.0.1.0` filename. `1.0.0.0` and `1.0.1.0` remain on disk, untouched, per Ops § Packaging.
**Schema Sync Mode for this deploy:** **Add** — this release only adds tables, fields, and pages
since the extension has never been in a production tenant; nothing is removed, shrunk, retyped, or
re-keyed.
**Files affected:** `app.json` (version), `outputAppPackage/SIC_Code_Classification_1.0.1.1.app`
(new), `docs/Docs.md` (§3 Deployment), `docs/TestScript.md` (§5 Results).
**Design Doc updated:** No — release marking, not a design change.

## Issue 9 — API and summary page fields missing `ApplicationArea = All` (Step 6 code review)

**Problem:** Step 6's code review (Standards §1.4: `Caption`, `ToolTip`, and `ApplicationArea = All`
are mandatory on every field, no exceptions) found `ApplicationArea = All` missing from every field
on the two new API pages (77081, 77082) and the `systemId` field on both.
**Root cause:** The API page fields were generated focused on `Caption`/`ToolTip` (what OData
`$metadata` surfaces) and the property was overlooked; it doesn't affect OData behavior directly, so
the compiler doesn't flag it, but the Standards Guide requires it unconditionally, including on API
pages (Anti-Patterns, Standards Part 7: "Missing `ApplicationArea = All`" → "Fields hidden in API
context").
**Resolution:** Added `ApplicationArea = All;` to every field on `ocpfsicSicCodeApi` (77081) and
`ocpfsicCustomerApi` (77082), including `systemId`. Recompiled clean: 0 errors, 0 warnings.
Repackaged at the same version (`1.0.1.0`) — not yet redeployed/retested by AJ, so this is a build
still in the current testing round, not a new version (Ops § Packaging).
**Files affected:** `src/Pages/ocpfsicSicCodeApi.Page.al`, `src/Pages/ocpfsicCustomerApi.Page.al`.
**Design Doc updated:** No — property-level compliance, not a structural change.

## Deferred 6 — API caption locking (Standards §8.6) recorded as not applicable

**Problem:** N/A — a classification decision, not a defect. Standards §8.6 asks every API page to
be classified Business / Technical-admin / Technical-plumbing and to set `EntityCaption`/
`EntitySetCaption` (translatable) or `Locked = true` (locked).
**Root cause:** N/A.
**Resolution:** Part 8's own scope note limits it to "every project with at least one target
language recorded at runbook Step 01" (§1.7's no-ML-syntax rule is the only always-on exception).
This project records no target language beyond source (`docs/ProjectParameters.md`: "None beyond
source — United States / en-US only"), so §8.6 doesn't apply; `ocpfsicSicCodeApi` (77081) and
`ocpfsicCustomerApi` (77082) set neither `EntityCaption`/`EntitySetCaption` nor `Locked = true`.
Revisit if a target language is ever added.
**Files affected:** None.
**Design Doc updated:** Yes — recorded in B3.10/B3.11.

## Deferred 5 — Step 5 closed: sandbox testing confirmed clean (2026-09-27)

**Problem:** N/A — recording the exit-gate confirmation, not a defect.
**Root cause:** N/A.
**Resolution:** AJ republished `outputAppPackage/SIC_Code_Classification_1.0.1.0.app` and confirmed
sandbox testing clean, covering the Issue 8 FlowField fix and the Feedback 1 drill-down/API
additions. Step 5 exit gate met: extension compiles 0 errors/0 warnings with the required
analyzers, human confirms sandbox testing clean, no known systemic issue outstanding, translation
checks N/A (US wording only). Moving to Step 6 (Review, Gap-Check & Finalize Docs).
**Files affected:** None.
**Design Doc updated:** No.

## Issue 8 — SIC Code Description didn't refresh on the Customer Card until leaving and returning

**Problem:** AJ's sandbox testing found that after picking a SIC Code on the Customer Card, the
`SIC Code Description` FlowField stayed blank until the page was closed and reopened.
**Root cause:** Business Central's client only recalculates a page's FlowFields when a record is
freshly read — editing a sibling field via `Validate` doesn't trigger a client-side refresh of
other bound controls on its own. `ocpfsicCustomerCardExt`'s `SIC Code` field had no `OnValidate`
trigger to force one.
**Resolution:** Added `trigger OnValidate() begin CurrPage.Update(false); end;` to the `SIC Code`
field in the page extension, so picking a code immediately refreshes the description.
**Files affected:** `src/PageExtensions/ocpfsicCustomerCardExt.PageExt.al`.
**Design Doc updated:** No — this is page-trigger behaviour, not a structural design change.

## Feedback 1 — Customer-count drill-down and two new API pages (2026-09-27)

**Problem:** N/A — new scope requested directly by AJ during Step 5 testing, not a defect:
(1) always be able to see a customer count, with drill-down to the customer list, by Industry
Group, Major Group, Division, and SIC Code — interactive lookup only, no report objects; (2) a
Read/Write API page for the SIC Code table; (3) a new, self-contained Read/Write Customer API page
exposing every applicable Customer field plus SIC Code and its description.
**Root cause:** N/A — scope addition.
**Resolution:** Added field 8 `Customer Count` (FlowField) to Table 77071; added a `Customers`
drill-down action + that field to Page 77072 for SIC-Code-level lookup; added Table 77079
"ocpfsicSicSummary" (temporary buffer) and Page 77080 (List) for Division / Major Group / Industry
Group drill-down, each level rebuilt in AL from `"ocpfsicSicCode"` since a two-hop aggregate
(Customer → SIC Code → group) can't be expressed as a single FlowField; added Page 77081
"ocpfsicSicCodeApi" (API, Read/Write) and Page 77082 "ocpfsicCustomerApi" (API, Read/Write, all 159
applicable Customer fields per Standards Part 3 plus SIC Code/SIC Code Description). AJ was asked
whether to extend Microsoft's standard Customer API page (leaner, reuses the entity most
integrations already call) or build a new self-contained one as originally requested; AJ chose the
new self-contained page. Full field list verified against the downloaded Base Application symbols
(`al_symbolsearch` and the bundled `Customer.Table.al` source), not memory — 18 localization-range
fields, 4 `FlowFilter` fields, and 2 obsolete fields excluded per Standards §3.2.
**Files affected:** `src/Tables/ocpfsicSicCode.Table.al`, `src/Tables/ocpfsicSicSummary.Table.al`
(new), `src/Pages/ocpfsicSicCodes.Page.al`, `src/Pages/ocpfsicSicSummary.Page.al` (new),
`src/Pages/ocpfsicSicCodeApi.Page.al` (new), `src/Pages/ocpfsicCustomerApi.Page.al` (new),
`src/PermissionSets/OCPFSICSICVIEW.PermissionSet.al`, `app.json` (version), `docs/DesignDoc.md` (B2,
B3.1, B3.2, new B3.8–B3.11, B5, B11).
**Design Doc updated:** Yes.
**Packaging:** this batch's first build wrongly overwrote `outputAppPackage/SIC_Code_Classification_1.0.0.0.app`
in place — a violation of Ops § Packaging's never-delete-or-overwrite-a-different-version rule.
Caught and corrected immediately: the original 1.0.0.0 package was restored from git, `app.json`
bumped to `1.0.1.0` (Build segment, at AJ's explicit direction), and this batch repackaged as
`outputAppPackage/SIC_Code_Classification_1.0.1.0.app` beside it. Both packages are now git-tracked
as separate files.

---

## Deferred 4 — Publishing and sandbox testing done by AJ, not the agent (Step 5)

**Problem:** N/A — recording an environment constraint and AJ's decision, not a defect.
**Root cause:** N/A.
**Resolution:** Publishing to a BC sandbox requires an interactive Microsoft browser sign-in; this
session runs in a headless GitHub Codespace with no browser (`xdg-open` fails outright — there is
no display, not just a missing token), so the AL MCP Server's `al_publish`/`al_auth_login` cannot
complete sign-in from here. AJ chose to publish `outputAppPackage/SIC_Code_Classification_1.0.0.0.app`
and run sandbox testing from their own machine, then report findings back. No API pages exist in
this extension, so Step 5's agent-run API-checklist question doesn't apply either way.
**Files affected:** None.
**Design Doc updated:** No.

## Issue 7 — First compile: two namespace errors and one property conflict

**Problem:** The first mandatory compile (Step 5, CodeCop+UICop+PerTenantExtensionCop) failed with
three errors: `Enum 'Video Category' is missing` and `Codeunit 'Type Helper' is missing` (both
`using`'d under `System.Environment.Configuration`, which is wrong for them), and
`DataClassification` set on a `FlowField` (`AL0223` — the property is invalid on a FlowField since
it has no storage of its own; the underlying field's classification already applies).
**Root cause:** `Video Category` is actually namespace `System.Media` and `Type Helper` is
`System.Reflection` — verified via `al_symbolsearch`, not assumed from their grouping in Microsoft
Learn's training example. The FlowField property was carried over by habit from the stored field
above it.
**Resolution:** Added `using System.Media;` and `using System.Reflection;`; removed
`DataClassification` from `"SIC Code Description"`. Recompiled clean: 0 errors, 0 warnings.
**Files affected:** `src/Codeunits/ocpfsicSicCodeImport.Codeunit.al`,
`src/TableExtensions/ocpfsicCustomerExt.TableExt.al`, `docs/DesignDoc.md` (B7).
**Design Doc updated:** Yes.

## Issue 6 — Design Doc said no events were needed; the wizard needs one subscription

**Problem:** B7 originally said no Microsoft event needed subscribing. But to appear on BC's
standard Assisted Setup page (as the design always intended for B3.5), the extension must subscribe
to `Codeunit "Guided Experience"`'s `OnRegisterAssistedSetup` event and call `InsertAssistedSetup`.
**Root cause:** B7 was written before checking how an Assisted Setup entry actually gets registered
with the platform; the mechanism was assumed to be automatic from the page's `PageType`.
**Resolution:** Verified `OnRegisterAssistedSetup`, `Exists`, and `InsertAssistedSetup`'s exact
signatures via `al_symbolsearch` against the downloaded symbols (not memory), and updated B7.
Registration uses the built-in `Assisted Setup Group::Uncategorized` rather than adding a ninth
object (an enum extension) for one wizard's own category.
**Files affected:** `docs/DesignDoc.md` (B7).
**Design Doc updated:** Yes — fixed in place before generating the codeunit's subscriber.

## Issue 5 — Division Name field too short for the actual data

**Problem:** `Division Name` was specified as `Text[50]`, but Division E's official name
("Transportation, Communications, Electric, Gas, And Sanitary Services", verified against OSHA's
SIC Manual) is 68 characters.
**Root cause:** The field length was estimated without measuring the actual (short) list of 10
division names before writing them into code.
**Resolution:** Widened `Division Name` to `Text[100]` in the table and `GetDivisionName`'s return
type in the Import codeunit, before finishing that codeunit.
**Files affected:** `docs/DesignDoc.md` (B3.1), `src/Tables/ocpfsicSicCode.Table.al`,
`src/Codeunits/ocpfsicSicCodeImport.Codeunit.al`.
**Design Doc updated:** Yes — fixed in place.

## Issue 4 — Resource bundling mechanics corrected while writing the Import codeunit

**Problem:** The Design Doc didn't account for two real AL mechanics: (1) `app.json` must declare
`"resourceFolders"` naming which project folders are packaged as resources — a bare file under the
project root isn't automatically bundled; (2) the `ResourceName` argument to
`NavApp.GetResourceAsText` is relative to the declared resource folder, so it must be `'SicCodes.txt'`,
not `'resources/SicCodes.txt'`. A draft of the codeunit also used `'\n'`/`'\r'` as if they were
escape sequences, which AL string literals don't support — verified against Microsoft Learn
(*Adding and Accessing Resources*) and corrected to the `Type Helper` codeunit's
`CRLFSeparator()`/`LFSeparator()` methods before this was written into the actual file.
**Root cause:** These are AL-platform mechanics not covered by the Standards/Ops guides; verified
against Microsoft Learn while writing the codeunit rather than assumed from memory (Operating
Rule 2's spirit, applied beyond just symbol verification).
**Resolution:** Added `"resourceFolders": ["resources"]` to `app.json`; corrected the
`NavApp.GetResourceAsText` call to `'SicCodes.txt'`; used `Type Helper` for line-splitting.
**Files affected:** `app.json`, `src/Codeunits/ocpfsicSicCodeImport.Codeunit.al`, `docs/DesignDoc.md` (B3.4).
**Design Doc updated:** Yes — fixed in place before finishing the Import codeunit.

## Issue 3 — Bundled resource format changed from CSV to pipe-delimited

**Problem:** The Design Doc specified a CSV resource (`SicCodes.csv`). While preparing the actual
data for bundling, 358 of the 1,005 official descriptions turned out to contain literal commas
(e.g. "Cash Grains, Not Elsewhere Classified") inside CSV-quoted fields — parsing that correctly in
AL needs a full RFC 4180 quoted-field parser, real complexity for a Lite-scope import codeunit.
**Root cause:** The design assumed a naive comma-split would be sufficient without having checked
the actual data for embedded commas.
**Resolution:** Converted the bundled resource to pipe-delimited (`resources/SicCodes.txt`,
`Division|MajorGroup|IndustryGroup|Code|Description`) before generating the Import codeunit —
verified no description contains a `|` character, so a plain `split('|')` per line is safe.
**Files affected:** `docs/DesignDoc.md` (B3.4), `resources/SicCodes.txt` (replaces the CSV).
**Design Doc updated:** Yes — fixed in place before generating the Import codeunit.

## Issue 2 — Design Doc referenced a field it never declared

**Problem:** B3.4 (Codeunit spec) described a `Division Name Overridden` flag protecting manual
edits from being overwritten on re-import, but B3.1 (the SIC Code table's field list) never
declared that field.
**Root cause:** The mechanism was designed narratively in the codeunit's prose before the field
list was cross-checked against it.
**Resolution:** Added `Division Name Overridden` (`Boolean`) to B3.1's field table, internal-only
(not shown on the list page), before generating any code.
**Files affected:** `docs/DesignDoc.md` (B3.1).
**Design Doc updated:** Yes — fixed in place before Step 4 code generation started.

## Issue 1 — Description field too short for the actual dataset

**Problem:** `docs/DesignDoc.md` specified `Description` (SIC Code table) and `SIC Code
Description` (Customer FlowField) as `Text[100]`, but the longest description in the actual
bundled dataset (`resources/SicCodes.csv`, SIC 3823, Division D) is 103 characters.
**Root cause:** The field length was estimated during design before the actual dataset was
downloaded and measured; the real data wasn't checked against the spec until Step 4's
pre-generation pre-flight pass.
**Resolution:** Both fields widened to `Text[150]` (headroom above the measured 103-character
maximum) before generating any AL code.
**Files affected:** `docs/DesignDoc.md` (B3.1, B3.3).
**Design Doc updated:** Yes — fixed in place before Step 4 code generation started.

## Deferred 1 — Batch plan approved (Step 3)

**Problem:** N/A — recording the approval decision, not a defect.
**Root cause:** N/A.
**Resolution:** AJ approved a single batch of all 8 objects (no natural split — small extension, no
header/line structure). Generation order: Table "ocpfsicSicCode" (77071) → Page "ocpfsicSicCodes"
(77072) → Table Extension "ocpfsicCustomerExt" (77073) → Page Extension "ocpfsicCustomerCardExt"
(77074) → Codeunit "ocpfsicSicCodeImport" (77075) → Page "ocpfsicSicCodeSetupWizard" (77076) →
PermissionSet "ocpfsicSicView" (77077) → PermissionSet "ocpfsicSicEdit" (77078) — lookups before the
things that reference them, per Operating Rule 3.
**Files affected:** None yet — this governs Step 4.
**Design Doc updated:** No — matches `docs/DesignDoc.md` B2/B11 exactly.

## Deferred 2 — Extension Name changed from the app.json default (Step 1)

**Problem:** The pre-existing `app.json` on disk (from `AL: Go!`/template scaffolding) had
placeholder values: `name: "SICDemo"`, `publisher: "Default Publisher"`, ID range `50100-50149`.
**Root cause:** These are the AL extension's own template defaults, not project-specific decisions.
**Resolution:** AJ chose `name: "SIC Code Classification"`, `publisher: "OnlyCopilotFans"`, and ID
range `77071-77099` at Step 1 intake (`docs/ProjectParameters.md`); `app.json` was rewritten to
match, keeping the original `id` GUID.
**Files affected:** `app.json`.
**Design Doc updated:** No — Design Doc was written after this decision, so it already reflects it.

## Deferred 3 — No Major Group name field (Step 2)

**Problem:** A full breakdown of SIC's hierarchy would normally include Major Group *names*
(~83 values), not just their 2-digit codes.
**Root cause:** No clean, machine-readable source for the 83 Major Group names was found alongside
the industry-level dataset (OSHA's manual lists them only in prose/HTML, not in the same structured
form as the 1,005 industry rows); only the 10 Division names were reliably sourced and verified.
**Resolution:** AJ signed off on including only Major Group *codes* (for filtering/grouping) in v1,
with Division codes *and* names. Flagged as a candidate follow-up in
`docs/HumanEffortEstimate.md` §5 if a clean Major Group name source turns up later.
**Files affected:** `docs/DesignDoc.md` (B3.1).
**Design Doc updated:** Yes — this is the as-designed state, not a later deviation from it.
