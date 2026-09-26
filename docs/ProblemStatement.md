# Problem Statement — SICDemo

## Purpose

Give Business Central users a standard, government-defined way to classify Customers by
industry using **SIC codes** (Standard Industrial Classification, U.S. Department of Labor,
1987 — the classification system BC does not ship natively). Today a Customer has no
SIC classification at all; users who need one currently track it outside BC (spreadsheet, CRM
notes) with no validation and no consistent code list.

**Domain vocabulary** (SIC's own hierarchy, frozen since 1987 — not to be confused with BC's
existing free-text "Industry Code" on Contact/Customer, which is unrelated and unvalidated):
- **Division** — broadest sector, one letter, A–J (e.g. Division D = Manufacturing).
- **Major Group** — 2-digit code within a Division (e.g. 20 = Food and Kindred Products).
- **Industry Group** — 3-digit code within a Major Group.
- **Industry / "the SIC code"** — 4-digit code within an Industry Group; this is what people
  mean when they say "SIC code" and is the value recorded per Customer.

## Consumers

- **Users:** Business Central users maintaining Customer master data (sales, credit, or
  compliance staff) who need to record and look up a Customer's industry classification.
- **Other systems / reporting:** none named yet — the SIC Code becomes a standard filterable/
  reportable field on Customer once present.
- **Countries and languages:** not yet asked — pending Step 1 intake (Project Parameters).

## Scope

- A new **SIC Code** reference table holding the full official 4-level hierarchy (Division,
  Major Group, Industry Group, Industry code + description), sourced from OSHA's SIC Manual
  (the comprehensive ~1,005-entry list), bundled as a static resource with the extension.
- One new field on **Customer**: **SIC Code**, validated against the SIC Code table.
- An **Assisted Setup Wizard** that imports the bundled SIC code list into the SIC Code table
  (decision: bundle-and-import locally, not a live web fetch — see `docs/ChangeLog.md` intake
  decisions once recorded, and `runbookSteps` intake below).
- A list page to browse/search the SIC Code table, and a way to see a Customer's SIC
  classification (code + description, and its Division/Major Group context) from the Customer
  Card.

## Out of scope

- NAICS codes (the system that replaced SIC for federal statistics in 1997) — not requested.
- SEC's shorter EDGAR-filing SIC list — OSHA's fuller list was chosen as the master source.
- Any live/networked refresh of the SIC list at runtime — the list is bundled at build time
  because it has been static since 1987.
- Classification on any entity other than Customer (e.g. Vendor, Contact) — not requested; can
  be added later without disrupting this design if needed.

## Entity / object list (initial — confirmed against Standards Part 6 gap check below)

| # | Object (planned) | Type | Notes |
|---|---|---|---|
| 1 | SIC Code | Table (new) | Code (4-digit), Description, Division Code/Name, Major Group Code/Name, Industry Group Code. |
| 2 | SIC Codes | Page (List, new) | Browse/search the full list. |
| 3 | Customer | Table extension | Adds the `SIC Code` field, `TableRelation` to SIC Code. |
| 4 | Customer Card | Page extension | Surfaces the new field (and SIC description) on the Customer Card. |
| 5 | SIC Code Import/Setup | Codeunit (new) | Reads the bundled resource and populates the SIC Code table. |
| 6 | SIC Code Setup Wizard | Page (Assisted Setup, new) | Runs the import; re-runnable. |
| 7–8 | `<PREFIX> <APPCODE>, VIEW` / `, EDIT` | Permission sets (new) | Required — this extension owns a new table (Standards §5.3). |

8 objects total (excluding the bundled data resource itself), within Lite's ≤10-file guideline.

## Quick gap check (Standards Part 6)

- **6.1 Analytical detail tables:** N/A — SIC Code is reference data, not a transactional/ledger
  entity.
- **6.2 Posted/archived versions:** N/A — no document objects involved.
- **6.3 Reference/lookup tables:** SIC Code *is* the lookup table being added; no other lookup
  table is referenced that isn't already standard on Customer.
- **6.4 Secondary document types:** N/A.
- **6.5 Modern vs. legacy tables:** N/A — no sales/purchase pricing tables involved.
- **6.6 Tax framework tables:** N/A.
- **Standard-BC-table check:** BC ships a generic, free-text **Industry Code** table used by
  Contact/Customer in the Marketing/Relationship Management area. It is *not* the SIC standard
  (no official code list, no hierarchy, user-defined values) — flagged as an open question below
  to confirm via downloaded symbols rather than assumed from memory, per Operating Rule 2.

## Open questions — resolved

1. ~~Confirm via downloaded symbols whether BC's standard "Industry Code" table/field could be
   confused with, or should be referenced from, the new SIC Code table.~~ **Resolved:** verified
   against downloaded symbols (`al_symbolsearch`), not memory. BC ships `Table Industry Group`
   and `Table Contact Industry Group` (namespace `Microsoft.CRM.Setup` / `Microsoft.CRM.Contact`)
   — a generic, user-defined classification used on **Contact**, with no official code list and
   no hierarchy. No table, field, or object named "SIC" exists anywhere in the downloaded
   symbols. The new SIC Code table is distinct and doesn't collide.
2. ~~Deployment Target, publisher, prefix, ID range, and the rest of the Project Parameters
   sheet.~~ **Resolved:** see `docs/ProjectParameters.md`.
3. ~~Countries/languages.~~ **Resolved:** United States / en-US only (`docs/ProjectParameters.md`).
4. ~~Onboarding extras beyond the SIC import wizard.~~ **Resolved:** Assisted Setup Wizard only;
   no Role Center cues, no Departments placement (`docs/ProjectParameters.md`).

**Still open, to confirm at Step 2 (Design):**
- Symbols currently in `.alpackages/` are the **W1 (global)** feed — the AL MCP Server's download
  is W1-only. Localization is `US`, but nothing planned so far touches a country-specific table or
  field (Customer's core structure is common across localizations, and SIC Code is an entirely new
  table). Per Ops § Symbols, W1 is fine to start DESIGN on; a sandbox (US-specific) download is
  only needed if a country-specific table/field turns up during design or build.

## Decisions locked at intake (2026-09-26)

- **Master SIC list source:** OSHA's full SIC Manual (~1,005 codes, full hierarchy) — not SEC's
  shorter EDGAR list.
- **Load mechanism:** bundle a static dataset with the extension; the Assisted Setup Wizard
  imports it locally. No live web fetch at setup time (no official machine-readable API exists
  for either public source; a live fetch would be fragile and restricted on many BC tenants).
- **Customer representation:** one `SIC Code` field on Customer, validated via `TableRelation`
  against the new SIC Code table (not multiple denormalized fields).
