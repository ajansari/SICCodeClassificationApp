# Design Document — SIC Code Classification

**Version:** 1 · **Date:** 2026-09-26 · **Sign-off:** AJ, 2026-09-26 · **From:** `docs/ProblemStatement.md`, `docs/ProjectParameters.md`, symbol file W1 28.5.54151.54677 (Base Application) / 28.5.54151.54178 (Application, Business Foundation) / 28.0.54016.0 (System)

# Part A — What and why

## A1. Purpose, scope, out of scope

**Purpose:** Give Business Central users a standard, government-defined way to classify Customers
by industry using SIC codes (Standard Industrial Classification, U.S. Dept. of Labor, 1987), which
BC does not ship natively.

**In scope:**
- A new **SIC Code** reference table holding the full OSHA SIC Manual hierarchy (~1,005 industry
  entries: Division, Major Group, Industry Group, Industry code + description).
- One new field on **Customer**: `SIC Code`, validated against the SIC Code table, plus a
  display-only `SIC Code Description` FlowField.
- A bundled, static data resource (the full code list) shipped with the extension.
- An **Assisted Setup Wizard** that imports the bundled list into the SIC Code table, re-runnable.
- A list page to browse/search the SIC Code table.

**Out of scope:** NAICS codes; SEC's shorter EDGAR SIC list; any live/networked refresh of the SIC
list at runtime; classification on any entity other than Customer.

## A2. Business objectives

- Replace ad hoc, unvalidated industry tracking (spreadsheets, CRM notes) with a validated,
  standard field on the Customer record.
- Ship a complete, correct SIC code list out of the box, with no manual data entry and no
  dependency on an external service being reachable at setup time.

## A3. Target consumers

Business Central users maintaining Customer master data (sales, credit, or compliance staff). No
other system or AI-tool consumer named; no API page is in scope (see B3 — no API caption-locking
section needed).

## A4. Platform requirements

Deployment Target: SaaS PTE. BC Application minimum: 28.0.0.0 (2026 release wave 1). AL runtime:
17.0. Localization: US. Namespace: `OnlyCopilotFans.SicClassification`. (All from
`docs/ProjectParameters.md`.)

## A5. Entity / object inventory

| Entity | Source table | Object type(s) | R / RW (Standards §2.2) | Notes |
|---|---|---|---|---|
| SIC Code | *(new)* | Table 77071 + Page 77072 (List) | RW | Master/reference data (Standards §2.2 treats master data as editable); normally populated by the Setup Wizard, but the standard master-data pattern (editable, `DelayedInsert = true`) applies rather than a special-cased read-only list. |
| Customer | Customer *(standard, verified via `al_symbolsearch`, namespace `Microsoft.Sales.Customer`)* | Table Extension 77073 + Page Extension 77074 | RW | Adds `SIC Code` (editable) and `SIC Code Description` (FlowField, read-only) to the existing editable Customer Card. |
| SIC Code Import | *(new, logic only)* | Codeunit 77075 | N/A | Reads the bundled resource, populates SIC Code table. |
| SIC Code Setup Wizard | *(new, UI only)* | Page 77076 (Assisted Setup) | N/A | Runs the import; re-runnable without duplicating records. |
| Permission sets | *(new)* | PermissionSet 77077 (VIEW), 77078 (EDIT) | N/A | Required — this extension owns a new table (Standards §5.3). |

Every Step 1 entity is mapped; nothing deferred.

## A6. Non-functional requirements

- Compiles with 0 errors, 0 warnings: CodeCop + UICop + PerTenantExtensionCop (SaaS PTE — never
  AppSourceCop), nothing suppressed.
- The Setup Wizard's import is **idempotent**: re-running it does not create duplicate SIC Code
  records (upsert by primary key `Code`).
- Import of ~1,005 records completes in a few seconds on a standard sandbox.
- No outbound network call at runtime — the entire feature works offline once installed (data is
  bundled, not fetched live).

## A7. Languages and markets

United States / `en-US` only. Source wording: US wording directly in source, no translation files
(chosen at Step 1 intake — Standards §8.1 applies as: since `en-US` is the sole target and this
isn't an AppSource submission, this simpler path is valid). No translation glossary needed (Part B10
below is N/A for this reason). No customer-facing documents or translatable user-entered text in
scope (Standards §8.9 — both answered "No" at intake).

---

# Part B — How

## B1. System identity (copied from `docs/ProjectParameters.md`)

| Parameter | Value |
|---|---|
| Publisher | OnlyCopilotFans |
| Namespace | OnlyCopilotFans.SicClassification |
| AL Object Prefix | ocpfsic |
| APIPublisher / APIGroup / APIVersion | onlyCopilotFans / ocpfsicClassification / v1.0 *(derived per Standards §2.7; unused in this version — no API pages)* |
| AL Runtime | 17.0 |
| BC Application Minimum | 28.0.0.0 |
| Object ID range | 77071–77099 (29 IDs, within the 50,000–99,999 PTE range — Standards §5.5) |
| Permission Set App Code | SIC |
| Permission Set Names | `OCPFSIC SIC, VIEW` / `OCPFSIC SIC, EDIT` |

## B2. ID allocation (sequential, buffer left at the end — Standards §5.2)

| ID | Object |
|---|---|
| 77071 | Table "ocpfsicSicCode" |
| 77072 | Page "ocpfsicSicCodes" (List) |
| 77073 | Table Extension "ocpfsicCustomerExt" |
| 77074 | Page Extension "ocpfsicCustomerCardExt" |
| 77075 | Codeunit "ocpfsicSicCodeImport" |
| 77076 | Page "ocpfsicSicCodeSetupWizard" (Assisted Setup) |
| 77077 | PermissionSet "ocpfsicSicView" |
| 77078 | PermissionSet "ocpfsicSicEdit" |
| 77090, 77091 | Table extension field IDs on "ocpfsicCustomerExt" (77073): `SIC Code`, `SIC Code Description` — field IDs share the app's `idRanges` pool but are a separate numbering space from object IDs, so they don't reduce the object buffer below. |
| 77079–77089, 77092–77099 | **Buffer — 19 IDs unallocated** (still well above the 10-ID minimum for a range this size, Standards §5.2), reserved for Step 6 gap-fill work and any further extension fields. |

## B3. Per-object specification

### B3.1 Table 77071 "ocpfsicSicCode"

| Property | Value |
|---|---|
| Source table (name / verified number) | New table — no source table. |
| Caption | "SIC Code" |
| DelayedInsert = true **or** Editable = false | N/A at table level — set on Page 77072 (Editable, `DelayedInsert = true`, per Standards §2.2 master-data pattern). |
| SourceTableView | N/A (table object). |
| `using` (from the symbol file) | None required — no standard BC references. |
| Deletion behaviour | **Block-if-referenced**: `OnDelete` trigger errors if any `Customer` row has `"SIC Code" = Rec.Code` — implemented via a `Customer.SetRange("SIC Code", Rec.Code)` existence check, so a code in use can't be silently orphaned. |
| Caption-locking group / decision / decided by | N/A — not an API object. |
| Parent link | N/A — not a child table. |
| Number series | N/A — primary key is the SIC industry code itself (an externally defined 4-digit standard code, not an auto-numbered document), so no `"No. Series"` field is used. |

#### Fields

| Source field | Identifier | Conversion | Included / excluded — reason | FlowField or stored |
|---|---|---|---|---|
| — | `Code` | New, `Code[4]` | Included — the 4-digit SIC industry code, primary key. | Stored |
| — | `Description` | New, `Text[150]` | Included — the industry's official description (e.g. "Wheat"). | Stored |
| — | `Division Code` | New, `Code[1]` | Included — one of 10 letters A–J, for filtering/grouping. | Stored |
| — | `Division Name` | New, `Text[100]` | Included — e.g. "Agriculture, Forestry, And Fishing" (verified against OSHA's SIC Manual, 10 fixed values). Set once by the Import codeunit from a fixed 10-entry map at import time (Standards Part 7 computed-field pattern: stored, seeded once, never overwritten by a validate trigger — so a manual correction, if ever made, survives a re-import only if the re-import explicitly skips populated rows; see B3.4). | Stored |
| — | `Major Group Code` | New, `Code[2]` | Included — 2-digit code within the Division, for filtering/grouping. | Stored |
| — | `Industry Group Code` | New, `Code[3]` | Included — 3-digit code within the Major Group. | Stored |
| — | `Division Name Overridden` | New, `Boolean` | Included — set to `true` the first time a user directly edits `Division Name` on the page; checked by the Import codeunit (B3.4) so a re-import never clobbers a manual correction. Not shown as a page column (internal bookkeeping only). | Stored |

No Major Group *name* field: OSHA's manual has ~83 major groups and no clean machine-readable name
list was found alongside the industry-level data (only Division names, 10 values, are reliably
sourced) — recorded as a design simplification, not an oversight; flagged in `docs/ChangeLog.md` if
revisited.

### B3.2 Page 77072 "ocpfsicSicCodes" (List)

| Property | Value |
|---|---|
| Source table | "ocpfsicSicCode" |
| PageType | List |
| APIGroup / EntityName / EntitySetName / ODataKeyFields | N/A — not an API page. |
| DelayedInsert = true **or** Editable = false | `DelayedInsert = true` (editable master-data list, Standards §2.2). |
| SourceTableView | `Order(Ascending)` on `Code` (no filter needed — single record type). |
| `using` | None. |
| Deletion behaviour | Delegates to the table's `OnDelete` (block-if-referenced, B3.1). |
| Caption-locking | N/A — not an API object. |

#### Fields shown
`Code`, `Description`, `Division Code`, `Division Name`, `Major Group Code`, `Industry Group Code`
— all as plain columns, editable per the page's `DelayedInsert = true`.

### B3.3 Table Extension 77073 "ocpfsicCustomerExt" extends Customer

| Property | Value |
|---|---|
| Source table (name / verified number) | Customer — verified via `al_symbolsearch` (`Microsoft.Sales.Customer.Customer`); table extensions reference the object by name, not by numeric ID, so the exact table number is not needed in AL source. |
| `using` (from the symbol file) | `Microsoft.Sales.Customer` |
| Deletion behaviour | Unchanged — no new constraint on deleting a Customer; the constraint lives on SIC Code (B3.1), blocking deletion of a code that's still referenced. |

#### Fields

| Source field | Identifier | Conversion | Included / excluded — reason | FlowField or stored |
|---|---|---|---|---|
| — | `SIC Code` | New, `Code[4]`, `TableRelation = "ocpfsicSicCode".Code` | Included — the field this whole extension exists to add. | Stored |
| — | `SIC Code Description` | New, `Text[150]`, `FlowField` | Included — at-a-glance display of the assigned code's description without opening the SIC Codes list; `CalcFormula = Lookup("ocpfsicSicCode".Description WHERE(Code = FIELD("SIC Code")))` (Standards Part 7: pure lookup of another table's field → FlowField, not stored). | FlowField |

### B3.4 Codeunit 77075 "ocpfsicSicCodeImport"

| Property | Value |
|---|---|
| Purpose | Reads the bundled SIC code resource — `resources/SicCodes.txt` on disk, declared via `app.json`'s `"resourceFolders": ["resources"]` (Microsoft Learn, *Adding and Accessing Resources*, BC 2024 release wave 2 update 25.2+ — comfortably covered by this project's BC 28.0 minimum), and read back as `NavApp.GetResourceAsText('SicCodes.txt', TextEncoding::UTF8)` — the `ResourceName` argument is relative to the declared resource folder, so it does **not** repeat the `resources/` prefix. Format: `Division\|MajorGroup\|IndustryGroup\|Code\|Description`, pipe-delimited rather than CSV: 358 of the 1,005 official descriptions contain literal commas, e.g. "Cash Grains, Not Elsewhere Classified", which would need a full RFC 4180 quoted-field parser in AL; no description contains a pipe, so a plain split is safe and verified against the actual dataset. Lines are split with the `Type Helper` codeunit's `CRLFSeparator()`/`LFSeparator()` (AL string literals have no escape sequences, so a literal `'\n'` would not match an actual newline). Parses the file and upserts into "ocpfsicSicCode" (insert if `Code` doesn't exist, modify existing `Description`/hierarchy fields, **never overwrite `Division Name`** if it was manually corrected after import — tracked with a boolean `Division Name Overridden` flag set the first time a user edits that field directly, checked before any re-import touches it). |
| `using` | None beyond base AL. |
| Deletion behaviour | N/A — logic-only object. |
| Events | Publishes none; subscribes to none (Standards Part 10) — this codeunit runs only from the Setup Wizard's own action, not hooked into another object's lifecycle, and no extension point is foreseeable for a v1 reference-data import. |

### B3.5 Page 77076 "ocpfsicSicCodeSetupWizard" (Assisted Setup)

| Property | Value |
|---|---|
| PageType | NavigatePage (wizard) |
| Purpose | Guides the user through running the import (calls Codeunit 77075), shows a count of codes loaded, and is safely re-runnable (the import is an upsert, per B3.4). Registered as a Guided Experience / Assisted Setup entry. |
| Deletion behaviour | N/A — UI-only object. |

### B3.6 PermissionSet 77077 "ocpfsicSicView" (`OCPFSIC SIC, VIEW`)

| Grant | Value |
|---|---|
| `tabledata "ocpfsicSicCode" = R` | Read only. |
| `Page "ocpfsicSicCodes" = X` | Execute (browse). |

### B3.7 PermissionSet 77078 "ocpfsicSicEdit" (`OCPFSIC SIC, EDIT`)

Includes `ocpfsicSicView`, plus:

| Grant | Value |
|---|---|
| `tabledata "ocpfsicSicCode" = RIMD` | Read/Insert/Modify/Delete. |
| `Codeunit "ocpfsicSicCodeImport" = X` | Execute. |
| `Page "ocpfsicSicCodeSetupWizard" = X` | Execute. |

## B4. Design patterns beyond the Standards Guide (cited)

- **Bundled static reference data, loaded via an Assisted Setup Wizard rather than a live web
  call** — a locked-in decision from Step 1 intake (`docs/ProblemStatement.md`), not a Standards
  Guide pattern; justified because neither public SIC source (OSHA, SEC) exposes a machine-readable
  API, and the list has been static since 1987.
- **Idempotent import (upsert, not insert-only)** — general AL Guidelines practice for any
  re-runnable setup routine (ALL ALONG → Reference Sources), so the wizard can be safely re-run
  after a fresh install or a data reset without erroring on duplicate keys.

## B5. Permission sets (grants enumerated)

See B3.6–B3.7 above — both sets fully enumerated, one table (`ocpfsicSicCode`) and this extension's
three own objects; the standard Customer permission sets already cover `Customer` itself, so no
grant is added there.

## B6. Upgrade and data migration

**No upgrade code needed.** This is the initial release (`app.json` version `1.0.0.0`) — per
Standards §9.1, "added a table, page, report, codeunit" and "added a field" only require upgrade
code from the *second* version onward, or once a first version has been installed somewhere real.
Neither applies yet. Revisit at the next version that changes what existing SIC Code or Customer
data must look like.

## B7. Events (verified in the symbol file)

**One subscription, to register the Assisted Setup entry; nothing published.** To make the Setup
Wizard (B3.5) appear on BC's standard **Assisted Setup** page (Page 1901), Codeunit 77075
"ocpfsicSicCodeImport" subscribes to `Codeunit "Guided Experience"`'s `OnRegisterAssistedSetup`
event (`System.Environment.Configuration` — verified via `al_symbolsearch` against the downloaded
symbols, not memory) and calls `InsertAssistedSetup`, guarded by `Exists(...)` so it isn't
re-registered on every startup:
- `Exists(GuidedExperienceType: Enum "Guided Experience Type"; ObjectType: ObjectType; ObjectID: Integer): Boolean` — signature confirmed in symbols.
- `InsertAssistedSetup(Title: Text[2048]; ShortTitle: Text[50]; Description: Text[1024]; ExpectedDuration: Integer; ObjectTypeToRun: ObjectType; ObjectIDToRun: Integer; AssistedSetupGroup: Enum "Assisted Setup Group"; VideoUrl: Text[250]; VideoCategory: Enum "Video Category"; HelpUrl: Text[250])` — signature confirmed in symbols.
- `Enum "Assisted Setup Group"` ships only `Uncategorized` (ordinal 0) out of the box, and its own
  doc comment invites extending it — this project uses `Uncategorized` rather than adding a ninth
  object (an enum extension) for a single wizard's own category.

No integration/business event is **published** by this extension — no extension point is
foreseeably needed by another app or PTE in v1. No other Microsoft event is subscribed to; the
import itself still runs only from the wizard's own explicit action, not from another object's
lifecycle (Customer posting, validation, etc.).

## B8. Special notes

- **Singletons:** none — SIC Code is a many-row reference table, not a setup singleton.
- **Header/line pairs:** none.
- **Naming conflicts:** none found — verified via `al_symbolsearch` that no object named "SIC"
  exists anywhere in the downloaded W1 symbols, and that BC's standard "Industry Group" /
  "Contact Industry Group" tables (`Microsoft.CRM.Setup` / `Microsoft.CRM.Contact`) are unrelated,
  generic classification tables with no official code list — no collision, no reuse opportunity.
- **Deletion behaviour summary:** SIC Code blocks deletion while referenced by any Customer (B3.1);
  Customer's own deletion behaviour is unchanged.

## B9. Translatable text

Source wording chosen at intake: **US wording directly in source, no translation files**
(`docs/ProjectParameters.md`). Standard AL practice is still followed for maintainability: every
user-facing message (wizard instructions, the "no records to import" case, the deletion-blocked
error) is a `Label` variable, not an inline string literal, so translation remains possible later
without a source rewrite. No `Locked` labels are needed (nothing is a fixed technical code). No
`Translations/*.xlf` file is produced, per the intake decision.

## B10. Translation glossary

N/A — no translation files (US wording only, chosen at Step 1 intake).

## B11. Object Register

| ID | Type | Name | Source table | R / RW |
|---|---|---|---|---|
| 77071 | Table | ocpfsicSicCode | *(new)* | RW |
| 77072 | Page (List) | ocpfsicSicCodes | ocpfsicSicCode | RW |
| 77073 | Table Extension | ocpfsicCustomerExt | Customer | RW |
| 77074 | Page Extension | ocpfsicCustomerCardExt | Customer Card | RW |
| 77075 | Codeunit | ocpfsicSicCodeImport | *(logic only)* | N/A |
| 77076 | Page (Assisted Setup) | ocpfsicSicCodeSetupWizard | *(UI only)* | N/A |
| 77077 | PermissionSet | ocpfsicSicView | — | N/A |
| 77078 | PermissionSet | ocpfsicSicEdit | — | N/A |

## Self-check

- [x] Every Step 1 entity maps to at least one object, or is explicitly deferred. (A5)
- [x] Every ID is inside the allocated range (77071–77099); 21-ID buffer left (well above the
      10-ID minimum for a range this size, Standards §5.2).
- [x] Every source table number and `using` namespace comes from the symbol file — Customer
      verified via `al_symbolsearch` (`Microsoft.Sales.Customer.Customer`); no other standard
      table is referenced.
- [x] Every field complies with Localization (US) — all new fields are extension-owned, no standard
      BC field inclusion/exclusion decision applies; no obsolete field is touched.
- [x] All names ≤ 30 characters (longest: `ocpfsicSicCodeSetupWizard`, 25 chars); R / RW matches
      actual mutability (B3, A5).
- [x] Permission sets enumerated and named with this extension's App Code (`SIC`) — B3.6–B3.7.
- [x] Every deletion behaviour decided (B3.1, B8); no API object exists, so no caption-locking
      decision is needed (A3, B3.2).
- [x] Target language: US/`en-US` only, no separate reviewer needed beyond the confirmed source
      wording decision; no regional term glossary needed (A7, B10 — both N/A for the stated
      reason).
