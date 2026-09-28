# Test Script — SIC Code Classification

**Version under test:** 1.0.1.0 (marked as release candidate `1.0.1.1` after passing — see §5) · **Package:** `outputAppPackage/SIC_Code_Classification_1.0.1.0.app` · **Environment:** Sandbox
Written for a tester who is not a developer.

## 1. Setup

| # | Precondition | How to check |
|---|---|---|
| 1 | The extension is installed on the sandbox. | Extension Management shows "SIC Code Classification", version 1.0.1.0. |
| 2 | You're assigned `OCPFSIC SIC, EDIT` (or `, VIEW` for the read-only cases). | Users → your user → Permission Sets. |
| 3 | The SIC code list has been imported at least once. | Search "SIC Codes" — the list isn't empty. |
| 4 | At least two test customers exist, neither with a SIC Code assigned yet. | Customers list. |

## 2. Green team — it works

### TC-1 Import the SIC code list (covers Design Doc §B3.4, §B3.5)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | Search "Import SIC Codes" and open it. | The wizard opens on step 1. | |
| 2 | Choose **Import**. | A result screen shows "Import complete. N SIC codes are ready to assign to customers." (N ≈ 1,005). | |
| 3 | Choose **Finish**. | Wizard closes. | |
| 4 | Open **SIC Codes**. | The list is populated with codes, descriptions, and division/group codes. | |

### TC-2 Assign a SIC code to a customer and see it refresh immediately (covers §B3.3, Issue 8)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | Open a test customer's Customer Card. | Card opens; **SIC Classification** section is visible. | |
| 2 | In **SIC Code**, look up and pick any valid code (e.g. `0111`). | The code is set. | |
| 3 | Without leaving the field or reopening the page, look at **SIC Code Description**. | The description fills in **immediately** — no need to close and reopen the card. | |

### TC-3 Browse SIC Codes and drill down to customers by SIC Code (covers §B3.2)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | Open **SIC Codes**. | List shows a **Customer Count** column. | |
| 2 | Find the code you assigned in TC-2. | Its **Customer Count** is at least 1. | |
| 3 | Select that row, choose the **Customers** action. | The standard Customer List opens, filtered to exactly the customer(s) with that SIC code. | |

### TC-4 Drill down by Division (covers §B3.8, §B3.9)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | Open **SIC Code Summary**. | List opens, defaulted to **By Division**, one row per Division letter with a name and a customer count. | |
| 2 | Select the Division containing the code from TC-2, choose **Customers**. | The standard Customer List opens, filtered to every customer whose SIC code falls under that Division. | |

### TC-5 Drill down by Major Group (covers §B3.8, §B3.9)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | On **SIC Code Summary**, choose **By Major Group**. | Rows switch to one per 2-digit Major Group code, with a customer count (no name column — by design, §B3.1). | |
| 2 | Select the Major Group containing the code from TC-2, choose **Customers**. | Customer List opens, filtered to that Major Group's customers. | |

### TC-6 Drill down by Industry Group (covers §B3.8, §B3.9)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | On **SIC Code Summary**, choose **By Industry Group**. | Rows switch to one per 3-digit Industry Group code, with a customer count. | |
| 2 | Select the Industry Group containing the code from TC-2, choose **Customers**. | Customer List opens, filtered to that Industry Group's customers. | |

### TC-7 Re-import preserves a manual Division Name correction (covers §B3.1, §B3.4)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | On **SIC Codes**, edit **Division Name** for any one row to a test value. | Value saves. | |
| 2 | Run **Import SIC Codes** again, choose **Import**. | Import completes. | |
| 3 | Check that same row's **Division Name**. | Your edited value is still there — not overwritten by the re-import. | |

### TC-8 API — read the SIC Code entity (covers §B3.10)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | `GET .../api/onlyCopilotFans/ocpfsicClassification/v1.0/companies(<id>)/ocpfsicSicCodes?$top=5` | Returns 5 SIC code records with `code`, `description`, `divisionCode`, `divisionName`, `majorGroupCode`, `industryGroupCode`, `customerCount`. | |
| 2 | `GET .../ocpfsicSicCodes?$filter=divisionCode eq 'A'` | Returns only Division A codes. | |

### TC-9 API — read and update the Customer entity (covers §B3.11)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | `GET .../ocpfsicCustomers?$filter=no eq '<test customer no.>'&$select=no,name,sicCode,sicCodeDescription` | Returns the customer with the SIC code assigned in TC-2 and its description. | |
| 2 | `PATCH .../ocpfsicCustomers(<SystemId>)` with `{ "sicCode": "<a different valid code>" }` | Update succeeds; a follow-up GET shows the new code and its (new) description. | |

## 3. Red team — it fails safely

### TC-10 Invalid SIC code rejected (validation)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | On a Customer Card, type a SIC Code that doesn't exist in the SIC Codes list (e.g. `0000`). | A clear validation error names the invalid code — the field doesn't silently accept it. | |

### TC-11 Deleting an in-use SIC code is blocked (deletion)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | On **SIC Codes**, try to delete the row for the code assigned in TC-2. | Blocked with: "You can't delete SIC Code X because it's assigned to at least one customer." — no partial deletion. | |

### TC-12 API — read-only field rejects a write (validation)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | `PATCH .../ocpfsicSicCodes(code='<any code>')` with `{ "customerCount": 999 }` | Fails gracefully with a clean, actionable error — `customerCount` is a FlowField and can't be written. | |

### TC-13 API — delete an in-use SIC code (deletion, boundary)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | `DELETE .../ocpfsicSicCodes(code='<code assigned to a customer>')` | Fails gracefully — the same block-if-referenced rule as TC-11, surfaced as an OData error, not a silent success or a server error. | |

### TC-14 API — permissions (permission)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | As a user with only `OCPFSIC SIC, VIEW`, `POST` a new record to `.../ocpfsicSicCodes`. | Rejected with a permissions error — `VIEW` grants only Read on `ocpfsicSicCode`. | |

### TC-15 API — invalid key (boundary)
| Step | Action | Expected result | Pass / Fail |
|---|---|---|---|
| 1 | `GET .../ocpfsicSicCodes(code='ZZZZ')` (a code that doesn't exist) | Returns a clean 404, not a server error. | |

## 4. Language pass

N/A — this project's only target language is US/`en-US`, written directly in source
(`docs/ProjectParameters.md`); no separate translation file exists to test against.

## 5. Results

| TC | Tester | Date | Result | ChangeLog entry (if failed) |
|---|---|---|---|---|
| TC-1 | AJ | 2026-09-27 | Pass | — |
| TC-2 | AJ | 2026-09-27 | Pass | — |
| TC-3 | AJ | 2026-09-27 | Pass | — |
| TC-4 | AJ | 2026-09-27 | Pass | — |
| TC-5 | AJ | 2026-09-27 | Pass | — |
| TC-6 | AJ | 2026-09-27 | Pass | — |
| TC-7 | AJ | 2026-09-27 | Pass | — |
| TC-8 | AJ | 2026-09-27 | Pass | — |
| TC-9 | AJ | 2026-09-27 | Pass | — |
| TC-10 | AJ | 2026-09-27 | Pass | — |
| TC-11 | AJ | 2026-09-27 | Pass | — |
| TC-12 | AJ | 2026-09-27 | Pass | — |
| TC-13 | AJ | 2026-09-27 | Pass | — |
| TC-14 | AJ | 2026-09-27 | Pass | — |
| TC-15 | AJ | 2026-09-27 | Pass | — |

**Result: all green-team tests passed; all red-team tests failed gracefully. No findings.**
Release candidate marked as `outputAppPackage/SIC_Code_Classification_1.0.1.1.app`
(`docs/ChangeLog.md`, Deferred 7).

## Before calling this done

- [x] Every parent→child entry point has a green-team TC — N/A, this extension has no header/line
      or parent/child page structure (Design Doc §B8).
- [x] Every number-series field has a green-team TC — N/A, SIC Code uses a natural key (the
      official 4-digit code), no number series (Design Doc §B3.1).
- [x] Every requirement in Part A has a TC (assign a code, browse, drill down by all 4 levels,
      import/re-import, both APIs); every rule in Part B a user can hit has a red-team TC
      (validation, deletion block, FlowField write, permissions, invalid key).
- [x] A non-developer can run every step — API cases (TC-8, TC-9, TC-12–TC-15) need a tool that can
      issue authenticated OData requests (e.g. Postman); say so if none is available in this
      environment (AJ confirmed at Step 5, Deferred 4, that testing happens from their own machine).
