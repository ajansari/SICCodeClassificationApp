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
