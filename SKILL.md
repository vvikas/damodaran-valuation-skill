---
name: damodaran-valuation
description: "Perform intrinsic valuation using Aswath Damodaran's methodology. Creates Excel DCF models with historical analysis. Handles non-financial companies (FCFF/DCF with ROIC, Sales/Capital ratio, reinvestment) and financial companies (Excess Return / Equity DDM using ROE, Tier 1 capital, book value). For distressed firms where DCF yields negative equity, adds option-based valuation (equity as call option via Black-Scholes). Supports natural resource options and patent options. Fetches financial data online when possible. USE THIS SKILL when user asks to value a company, build a DCF model, do intrinsic valuation, estimate fair value per share, analyze a stock fundamentally, or mentions Damodaran valuation. Also trigger for ROIC analysis, WACC calculation, reinvestment rate analysis. Even partial requests like 'what's the fair value of X' or 'is X overvalued' should trigger this skill."
---

# Damodaran Intrinsic Valuation Skill

Build rigorous intrinsic valuations following Aswath Damodaran's framework. Output is a professional Excel workbook with historical analysis and a full DCF/valuation model.

## Overall Workflow

1. **Identify the company** and determine if it is Financial or Non-Financial
2. **Gather financial data** — search online first, ask user if unavailable
3. **Classify** and select the valuation approach
4. **Compute historical metrics** — ROIC, Revenue Growth, Reinvestment Rate, S/C ratio (or ROE, Payout, Tier 1 for financials)
5. **Build the Excel model** with historical analysis + forward projections
6. **Check for distress / optionality** — if DCF equity value is negative or firm has undeveloped resources/patents, add Option Valuation sheet
7. **Present the output** with a summary of value per share and key assumptions

## Step 1: Company Classification

This decision drives the entire valuation. Damodaran treats financial companies fundamentally differently because debt is their raw material, not a financing choice.

**Non-Financial Companies** → FCFF (Free Cash Flow to Firm) DCF:
- Manufacturing, Tech, Consumer, Pharma, Energy, Telecom, Industrials, etc.
- Key drivers: Revenue growth, Operating margin, ROIC, Sales-to-Capital ratio, Reinvestment

**Financial Companies** → Equity valuation (FCFE / Excess Return / DDM):
- Banks, NBFCs, Insurance, Asset Management, Brokerages
- Key drivers: ROE, Cost of Equity, Book Value of Equity, Tier 1 Capital, Regulatory capital
- NEVER use FCFF for financials — debt is raw material, not financing

**Option-Based Valuation** → Added automatically when any of these are detected:
- DCF yields negative equity value but stock trades at positive price
- Book value of equity is negative
- Debt exceeds estimated firm value (deeply distressed / near-bankruptcy)
- Firm has significant undeveloped natural resources (oil/gas/mining reserves)
- Firm has major patents or products in pipeline not yet commercialized (biotech, pharma)
- User explicitly asks about option value, distress valuation, or equity as option
- Option valuation is a **complement to DCF, not a replacement** — both are always presented

Read the appropriate reference files:
- Non-Financial: Read `references/non-financial-valuation.md`
- Financial: Read `references/financial-valuation.md`
- Option-Based / Distress: Read `references/option-based-valuation.md`

**Always read for WACC construction (ALL companies, ALL markets):**
- Read `references/country-risk-parameters.md` — governs geographic revenue weighting, blended ERP, CRP lookup, and currency rules.

For Indian market specifics (tax rates, data sources, G-Sec benchmarks): Read `references/indian-market-specifics.md`

## Step 2: Data Gathering — Latest Filing + Source Tracking

### Determine the Latest Filing

**Always use the most recent financial data available.** The priority order:

1. **Check for latest quarterly filing first** (10-Q for US, Quarterly Results for India)
2. **If the latest filing is an annual report** (10-K for US, Annual Report for India), use that directly
3. **If quarterly is more recent**, compute Trailing Twelve Months (TTM) numbers

**Search strategy to find the latest filing:**
- For US: Search `"{company name}" 10-Q OR 10-K SEC EDGAR {current year}` — EDGAR shows filing dates, pick the most recent
- For India: Search `"{company name}" quarterly results {latest quarter} {year} site:bseindia.com` and `"{company name}" annual report {year}`
- Compare filing dates to determine which is latest

### TTM (Trailing Twelve Months) Computation

When the latest filing is a quarterly report, compute TTM for income statement / cash flow items:

**TTM = Last Annual Value + (Current YTD from latest quarter) - (Same YTD from prior year)**

Example: If latest is Q3 FY2025 (9 months ended Dec 2024) and last annual is FY2024 (March 2024):
- TTM Revenue = FY2024 Revenue + Q1-Q3 FY2025 Revenue - Q1-Q3 FY2024 Revenue

For balance sheet items (Debt, Cash, Equity, Invested Capital):
- Use the **latest quarter-end values** directly (no TTM needed — balance sheet is a snapshot)

For shares outstanding:
- Use the **latest quarter-end** number (most current dilution picture)

### Data Sources — Search in This Order

**For Indian companies:**
1. `{company name} screener.in` — Screener.in has clean historical + quarterly financials
2. `{company name} quarterly results {quarter} {year}` — BSE/NSE filings
3. `{company name} annual report {year}` on BSE/NSE sites
4. `{company name} financials moneycontrol`
5. Fetch the pages and extract data tables

**For US companies:**
1. `{company name} 10-Q OR 10-K SEC EDGAR` — Latest filing
2. `{company name} financials macrotrends` — Clean historical data
3. Yahoo Finance for current market data (price, shares, beta)

### Source Tracking — CRITICAL

**Every single number in the model must have a source citation.** This is non-negotiable.

When extracting data, record for each number:
- **Source document**: e.g., "10-K FY2024", "Q3 FY2025 Quarterly Results", "Screener.in"
- **Page / Section**: e.g., "Income Statement", "Balance Sheet", "Notes to Accounts pg 145"
- **Filing date**: When the document was filed/published
- **URL**: Where the data was found online

This source information goes into the "Sources" column in the Inputs sheet (see Sheet 1 structure below).

### Geographic Revenue Breakdown — CRITICAL for WACC

**Always gather geographic revenue segmentation.** This is non-negotiable because it directly determines the correct WACC via country-weighted ERP. A company earning 60% of revenue in the US and 40% in India faces different risks than a pure-play in either market.

**How to find it:**
- For Indian companies: Annual report → "Segment Information" (Ind AS 108) or "Notes to Accounts — Geographical Segments". Also check Screener.in segment tab, Tijori Finance.
- For US companies: 10-K → Note on "Segment Information" or "Geographic Information" (ASC 280). Also try Macrotrends or SEC EDGAR full-text search.
- Search: `"{company name}" geographic revenue segment {year}` or `"{company name}" revenue by region {year}`

**Record for each geography:**
| Geography | Revenue (TTM) | % of Total | Country/Region Code |
|-----------|--------------|------------|---------------------|
| India | ₹X | 45% | IND |
| USA | ₹Y | 30% | USA |
| Europe | ₹Z | 15% | EU |
| Rest of World | ₹W | 10% | ROW |

**If geographic breakdown is unavailable:**
- Check if company is purely domestic (100% one country) — use that country's parameters
- If export-oriented but no breakdown: estimate from management commentary, analyst reports
- If truly unavailable: note the limitation prominently in the model and default to company's primary listing country
- For conglomerates: try to get segment-level geography, not just consolidated

**Read `references/country-risk-parameters.md` for ERP and CRP parameters across major markets.**

### Data Needed — Non-Financial (minimum 5 years historical, prefer 10)

**Income Statement items** (use TTM if quarterly is latest):
Revenue, Operating Income (EBIT), Interest Expense, Tax Expense, Pre-tax Income, Stock-based Compensation

**Balance Sheet items** (use latest quarter-end snapshot):
Total Debt (short-term + long-term), Cash & Equivalents, Book Value of Equity, Total Assets, Current Assets, Current Liabilities

**Cash Flow Statement items** (use TTM if quarterly is latest):
CapEx, Depreciation & Amortization, Change in Working Capital

**Share Data** (latest available):
Shares Outstanding (basic + diluted), Options outstanding, RSUs pending, Weighted average strike price

**Derived**:
Invested Capital = BV Equity + BV Debt - Cash
Effective Tax Rate = Tax Expense / Pre-tax Income

### Data Needed — Financial (minimum 5 years historical)

**Use latest quarter-end for balance sheet, TTM for income items:**
Book Value of Equity, Net Income (TTM), Dividends Paid (TTM), Tier 1 Capital / CET1 Ratio, Risk-Weighted Assets, NPA ratios, Capital Adequacy Ratio, Shares Outstanding

**If data cannot be found online**, present what was found and ask the user to fill gaps. Be specific about which numbers are missing and which filing they'd come from.

## Step 3: Historical Analysis (Critical — do this before projecting)

Damodaran emphasizes: understand the past before projecting the future. Compute historical metrics for all available years.

### Non-Financial — Year-by-year metrics:

| Metric | Formula |
|--------|---------|
| Revenue Growth | (Revenue_t - Revenue_{t-1}) / Revenue_{t-1} |
| Operating Margin | EBIT / Revenue |
| Effective Tax Rate | Taxes Paid / Pre-tax Income |
| ROIC | EBIT × (1-t) / Invested Capital |
| Sales-to-Capital Ratio | ΔRevenue / ΔInvested Capital (incremental) or Revenue / Invested Capital |
| Reinvestment Rate | (CapEx - D&A + ΔWC) / EBIT(1-t) |
| Reinvestment | CapEx - D&A + ΔWC |
| FCFF | EBIT(1-t) - Reinvestment |

Compute averages, medians, and spot trends. These inform projection assumptions.

**Incremental Sales-to-Capital** is preferred by Damodaran: how much revenue did each rupee/dollar of new capital generate? This is more forward-looking than the level ratio.

### Financial — Year-by-year metrics:

| Metric | Formula |
|--------|---------|
| ROE | Net Income / Average Book Value of Equity |
| Payout Ratio | Dividends / Net Income |
| Retention Ratio | 1 - Payout Ratio |
| Sustainable Growth | ROE × Retention Ratio |
| Tier 1 Ratio | Tier 1 Capital / Risk-Weighted Assets |
| NPA Ratio | Net NPAs / Total Advances |

## Step 4: Build the Excel Model

Use openpyxl to construct the workbook. If the `xlsx` skill is available in your context, follow its guidelines; otherwise use openpyxl directly with the formatting rules below:
- ALL calculations as Excel formulas (never hardcoded Python-computed values)
- Blue text (RGB: 0,0,255) for hardcoded inputs
- Black text for formulas
- Yellow highlight for key assumptions the user should adjust
- Proper number formatting throughout
- Freeze panes on header rows
- Run the xlsx recalc script after creation

### Workbook Structure — Non-Financial (7-8 sheets)

Modeled after Damodaran's **fcffsimpleginzu.xlsx** structure with enhancements.
Sheet 8 ("Option Valuation") is added automatically when distress/optionality is detected.

**Sheet 1: "Inputs & Assumptions"** — Mirrors Damodaran's single-page input design. All user-facing inputs on one sheet, with default assumptions that can be overridden.

**CRITICAL: Source Citation Layout**
Every input row has 3 columns: **Value | Source | Filing Period**
- Value: The number (blue text for hardcoded inputs)
- Source: Where the number came from (e.g., "10-K FY2024 pg 55", "Q3 FY2025 Results", "Screener.in", "Damodaran Jan 2025 dataset")
- Filing Period: Which period the number covers (e.g., "FY2024", "TTM Q3 FY2025", "As of Dec 31 2024")
- Source and Filing Period columns use gray italic text, smaller font (9pt) to keep focus on the numbers

Section A — Company Financials:
- Row: Filing Basis = "Annual (10-K)" or "Quarterly (10-Q) — TTM Computed" (auto-set based on data used)
- Row: Latest Filing Date (e.g., "Q3 FY2025 filed Jan 28, 2025")
- Row: Annual Report Used (e.g., "10-K FY2024 filed Feb 15, 2024")
- Company name, ticker, valuation date, currency
- Revenues (TTM if quarterly is latest) | Source | Period
- Operating Income (EBIT) (TTM) | Source | Period
- Interest Expense (TTM) | Source | Period
- Book Value of Equity (latest quarter-end) | Source | Period
- Book Value of Debt (latest quarter-end) | Source | Period
- Cash and Marketable Securities (latest quarter-end) | Source | Period
- Invested Capital (= BV Equity + BV Debt - Cash) | "Computed" | Period
- Current Stock Price | Source (e.g., "NSE Feb 10 2025") | Date
- Number of Shares Outstanding (basic) | Source | Period
- Effective Tax Rate (from financials) | Source | Period
- Stock-based Compensation (annual/TTM) | Source | Period
- Options: Number outstanding, strike, maturity | Source | Period
- RSUs: Number of unvested RSUs | Source | Period

If TTM was computed, include a small sub-table showing the TTM calculation:
```
TTM Revenue = FY2024 Revenue + Q1-Q3 FY2025 - Q1-Q3 FY2024
            = [value]       + [value]        - [value]
            = [TTM value]
```
This makes the TTM computation transparent and auditable.

Section B — Geographic Revenue Breakdown (NEW — drives blended WACC):

| Geography | Revenue (TTM) | % of Total | ERP to Use | CRP | Source |
|-----------|--------------|------------|------------|-----|--------|
| [Country 1] | [value] | =formula | [from ref] | [from Damodaran] | [filing] |
| [Country 2] | ... | ... | ... | ... | ... |
| Total | =SUM | =SUM | | | |

- Minimum 2 rows, maximum 6 (group small geographies into "ROW")
- All percentages as Excel formulas (Revenue_i / Total Revenue)
- ERP and CRP values sourced from Damodaran's country risk table (search at valuation date)
- Add a note: "ERP = Mature Market ERP + Country Risk Premium. Source: Damodaran [month year] update"
- If company is 100% domestic: single row, note "Pure domestic — no geographic WACC blending needed"

Section D_Risk — Market / Risk Inputs (each with Source column):
- Risk-free Rate (primary currency) | Source (e.g., "India 10Y G-Sec yield, RBI, Feb 10 2025") | Date
  - INR valuation → Indian G-Sec. USD valuation → US T-bond. Use the currency your FCFF is in.
- Mature Market ERP | Source (e.g., "Damodaran Jan 2025: 4.60%") | Date
- Blended ERP | "Computed from geo revenue table in Section B" | —
  - = Σ (Revenue Weight_i × (Mature ERP + CRP_i))
  - This is what goes into the CAPM — NOT a single flat ERP
- Unlevered Beta | Source (e.g., "Damodaran Emerging Mkt Industrials Jan 2025") | Sector
- Levered Beta (= Unlevered × (1 + (1-t) × D/E)) | "Computed" | —
- Pre-tax Cost of Debt: Default = synthetic rating method (Interest Coverage → Rating → Default Spread + Risk-free). Override with actual rate if known. | Source | —

Section E — Growth & Margin Assumptions (each with Basis column explaining rationale):
- Revenue Growth Rate (high-growth phase, Year 1) | Basis (e.g., "5Y CAGR = 12%, recent deceleration, using 10%")
- Number of High-Growth Years (default: 5-10 depending on company maturity) | Basis
- Target Operating Margin in Stable State | Basis (e.g., "Industry median = 15%, company at 18%, targeting 16%")
- Sales-to-Capital Ratio | Basis (e.g., "5Y median incremental S/C = 2.1, using 2.0")
- Marginal Tax Rate (for stable state — statutory rate) | Source (e.g., "India new regime 25.17%")

Section F — Default Assumptions with Override (Damodaran's signature pattern):
Each has a "Use Default? (Y/N)" toggle and an override cell:
- Stable growth rate: Default = Risk-free Rate (Damodaran's rule). Override if justified.
- Converge ROIC to WACC in stable state? Default: Yes (Beta → 1, Reinvestment Rate = g/ROIC)
- Converge Beta to 1.0 in stable state? Default: Yes
- Converge D/E to industry average in stable state? Default: Yes  
- Probability of Failure: Default = 0%. Set to 10-30% for distressed companies. Value adjustment = (1 - P_fail) × DCF Value + P_fail × Distress Proceeds
- Treatment of Cash: Default = Add to value at face value. Override for discount.
- Operating Lease Adjustment: Default = No. Set to Yes and input lease commitments if significant.

**Sheet 2: "Historical Analysis"** — 5-10 years of data and computed ratios. This is the "reading the tea leaves" sheet Damodaran emphasizes.
- **Source Row at top**: For each year column, note the source document (e.g., "FY2020: 10-K filed Mar 2021", "FY2024: 10-K filed Feb 2025", "FY2025 TTM: Computed from Q3 FY2025 + FY2024")
- Raw Data Table: Revenue, EBIT, Tax Rate, CapEx, D&A, ΔWC, Invested Capital (BV Equity + BV Debt - Cash), Shares Outstanding — for each historical year
- Computed Metrics Table (all as Excel formulas):
  - Revenue Growth (YoY)
  - Operating Margin (EBIT / Revenue)
  - Effective Tax Rate
  - After-tax Operating Income: EBIT × (1-t)
  - ROIC: EBIT(1-t) / Invested Capital (beginning of year)
  - Reinvestment: CapEx - D&A + ΔWC
  - Reinvestment Rate: Reinvestment / After-tax EBIT
  - FCFF: After-tax EBIT - Reinvestment
  - Sales-to-Capital (incremental): ΔRevenue / ΔInvested Capital
- Summary Row: 3-year average, 5-year average, median for each metric
- This sheet grounds the assumptions — ROIC tells you quality, S/C tells you efficiency, margin trend tells you direction

**Sheet 3: "Cost of Capital"** — Full WACC computation following Damodaran's wacccalc.xls and ratings.xls approach, extended with geographic revenue weighting.

**Section A: Geographic Revenue Weights (from Inputs)**

| Geography | Revenue | Weight | Country Code |
|-----------|---------|--------|--------------|
| [Country 1] | [₹/$/€] | [%] | [Code] |
| [Country 2] | ... | ... | ... |
| Total | =SUM | 100% | |

All weights used as Excel formulas referencing the Inputs sheet geo-revenue table.

**Section B: Country-Level Risk Parameters**

For EACH geography with >5% revenue weight, compute a row:

| Parameter | Country 1 | Country 2 | ... |
|-----------|-----------|-----------|-----|
| Risk-free Rate (Rf) | [G-Sec/Treasury/Bund] | ... | |
| Mature Market ERP | [Damodaran latest] | ... | |
| Country Risk Premium (CRP) | [Damodaran latest] | ... | |
| Total ERP = Mature ERP + CRP | =formula | ... | |
| Country-level Ke = Rf + Beta × Total ERP | =formula | ... | |

**CRP sourcing rules:**
- India: Damodaran India CRP (search "Damodaran country risk premium India [year]")
- USA: CRP = 0 (mature market — it IS the benchmark)
- EU countries: Use country-specific CRP from Damodaran's table (Germany ≈ 0%, Italy ~1.5%, etc.)
- China: Damodaran China CRP (typically 1.5-3.0% depending on period)
- ROW aggregate: Revenue-weighted average of constituent country CRPs, or use region proxy

**Damodaran's Lambda approach for CRP (preferred for multinationals):**

Instead of adding a flat CRP to every company's Ke, Damodaran recommends scaling by Lambda:
- Lambda = company's exposure to country risk relative to average firm
- Lambda = (% revenue from country) / (average % revenue from country for market)
- For a company earning 40% in India vs. average Indian company earning 80% in India: Lambda = 0.40/0.80 = 0.5
- Ke = Rf + Beta × Mature ERP + Lambda × CRP
- This prevents overstating risk for companies that earn less in a risky country than the typical local firm

**For simplicity (acceptable shortcut):** Use revenue-weighted blended ERP directly in a single Ke (Section C below). Note which approach is used.

**Section C: Blended Cost of Equity**

**Method 1 — Revenue-Weighted Blended ERP (recommended for most cases):**
```
Blended ERP = Σ (Revenue Weight_i × Total ERP_i)
            = w1 × ERP_1 + w2 × ERP_2 + ...

Blended Rf  = Use primary listing currency's risk-free rate
              (This is the currency the valuation is done in)

Ke = Rf_primary + Levered Beta × Blended ERP
```

**Method 2 — Lambda (for companies with very different geographic mix from their listing market):**
```
Lambda_country = Revenue_%_in_country / Market_avg_%_in_country
Ke = Rf + Beta × Mature ERP + Σ (Lambda_i × CRP_i)
```

Levered Beta (from Inputs — auto-computed from unlevered + D/E):
- Levered Beta = Unlevered Beta × (1 + (1-t) × D/E)

**Section D: Cost of Debt**

Synthetic Rating & Cost of Debt (Damodaran's ratings.xls approach):
- Interest Coverage Ratio = EBIT / Interest Expense
- Lookup table: ICR → Synthetic Rating → Default Spread
  (Include Damodaran's lookup table directly in the sheet as a reference range)
- Pre-tax Kd = Risk-free (primary currency) + Default Spread
- After-tax Kd = Kd × (1 - tax rate)
- Override with actual borrowing rate if preferred

**Note on multi-currency debt:** If the company has significant foreign-currency debt (e.g., USD ECBs for an Indian company), note it. For valuation purposes, use the company's weighted average cost of debt across currencies, or the primary-currency equivalent rate.

**Section E: Capital Structure (at market values)**

- Market Cap = Price × Shares
- Market Debt ≈ Book Debt (or adjust if rates have shifted significantly)
- Equity Weight = Market Cap / (Market Cap + Debt)
- Debt Weight = Debt / (Market Cap + Debt)

**Section F: Final WACC**

```
WACC = Ke × E/(E+D) + Kd(1-t) × D/(E+D)
     = [Ke from Section C] × [Equity Weight] + [After-tax Kd] × [Debt Weight]
```

**Geographic WACC Decomposition (for transparency — add a callout box):**
```
Geography          | Revenue Wt | ERP used | Contribution to Ke
India              | 45%        | 8.5%     | 45% × Beta × 8.5% = X%
USA                | 30%        | 5.0%     | 30% × Beta × 5.0% = Y%
Europe             | 15%        | 5.5%     | 15% × Beta × 5.5% = Z%
ROW                | 10%        | 7.0%     | 10% × Beta × 7.0% = W%
                   |            |          |
Blended ERP:       |            | X+Y+Z+W  |
Rf (primary curr): |            | 7.0%     |
Beta (levered):    |            | 1.1      |
Ke = 7.0% + 1.1 × Blended ERP = [result]
```

Stable Period WACC (if convergence defaults are Yes):
- Stable Beta → 1.0 (or close to it)
- Stable D/E → industry average
- Stable geographic mix → may shift (e.g., company going more global) — note assumption
- Re-compute Ke_stable using stable blended ERP, WACC_stable

**Sheet 4: "Revenue & FCFF Projection"** — The core DCF engine (Year 1 through Year n + Terminal Year). This follows Damodaran's fcffsimpleginzu layout closely.

Column layout: Year 0 (Base) | Year 1 | Year 2 | ... | Year n | Terminal Year

Row-by-row computation (all Excel formulas):
1. Revenue Growth Rate — fading linearly from initial to stable: g_t = g_initial - (g_initial - g_stable) × (t-1)/(n-1)
2. Revenue — = Prior Revenue × (1 + growth rate)
3. Operating Margin — converging from current to target: margin_t = current + (target - current) × t/n
4. EBIT — = Revenue × Operating Margin
5. Tax Rate — transitioning from effective to marginal: tax_t = effective + (marginal - effective) × t/n
6. EBIT(1-t) — = EBIT × (1 - tax rate)
7. Reinvestment — = ΔRevenue / Sales-to-Capital ratio
8. FCFF — = EBIT(1-t) - Reinvestment
9. WACC for this year — (from Cost of Capital sheet, transitioning to stable WACC)
10. Cumulative Discount Factor — = prior × (1 + WACC_t)
11. PV of FCFF — = FCFF / Cumulative Discount Factor

Terminal Year (Year n+1):
- Stable growth rate from Inputs
- Reinvestment Rate_stable = g_stable / ROIC_stable (where ROIC_stable converges to WACC if default is Yes)
- FCFF_terminal = EBIT_terminal × (1-t) × (1 - Reinvestment Rate_stable)
- Terminal Value = FCFF_terminal / (WACC_stable - g_stable)
- PV of Terminal Value = Terminal Value / Cumulative Discount Factor

Implied Metrics Check (at bottom of sheet — Damodaran's impliedROC&ROE concept):
- Implied ROIC in terminal year = After-tax margin × S/C ratio
- Implied Reinvestment Rate = g_stable / ROIC_implied
- Flag if ROIC_implied < WACC (growth is destroying value!)
- Flag if Terminal Value > 85% of total value (needs scrutiny)

**Sheet 5: "Bridge to Equity"** — From operating asset value to value per share. Follows Damodaran's exact bridge logic.

```
Value of Operating Assets:        =SUM(PV of FCFFs) + PV of Terminal Value
+ Cash and Marketable Securities: (from Inputs)
+ Value of Cross-Holdings:        (if any — at market value)
- Total Debt:                     (from Inputs — book value)
- Minority Interest:              (if applicable)
= Value of Equity (all claims):   [formula]

Options/RSU Adjustment Section:
  Options Outstanding:             (from Inputs)
  Estimated Value per Share (1st pass): = Equity Value / (Shares + RSUs)
  Option Value per option:         = MAX(0, Value_per_share - Strike Price)
  Total Option Value:              = Options × Value per option
  RSUs:                           (from Inputs — count added to shares)

- Value of Options:               [formula]
= Equity Value to Common:         [formula]

Probability of Failure Adjustment:
  Distress Sale Value:            = (some % of book value, typically 30-50%)
  Adjusted Value:                 = (1 - P_fail) × Equity_Common + P_fail × Distress Value

÷ (Shares Outstanding + RSUs):   [formula]
= VALUE PER SHARE:               [formula — HIGHLIGHT YELLOW, BOLD, LARGE FONT]

Current Market Price:             (from Inputs)
Upside / Downside %:             = (Value - Price) / Price
```

**Sheet 6: "Sanity Check"** — Damodaran always checks implied multiples and runs sensitivities.

Implied Multiples at Estimated Value:
- Implied P/E = Equity Value / Net Income
- Implied EV/EBITDA = Operating Asset Value / EBITDA
- Implied EV/Revenue = Operating Asset Value / Revenue
- Implied EV/Invested Capital = Operating Asset Value / Invested Capital
- Compare each to industry median (include a reference column)

DCF vs Option vs Market (if Option Valuation sheet exists):
```
                        Value/Share    vs Market Price
DCF Value:              ₹X             [+/-]%
Option Value:           ₹Y             [+/-]%
Current Market Price:   ₹P
Interpretation:         [auto-generated comment based on where market sits relative to both]
```

Sensitivity Analysis Table (Data Table in Excel):
- Rows: WACC (±1-2% from base, in 0.5% steps)
- Columns: Stable Growth Rate (range of plausible values)
- Values: Value per Share at each WACC × g combination
- Highlight the base case cell

Second Sensitivity Table:
- Rows: Operating Margin (target)
- Columns: Revenue Growth Rate (Year 1)
- Values: Value per Share

**Sheet 7: "Synthetic Rating Table"** — Reference lookup (from Damodaran's ratings.xls)
- Interest Coverage Ratio ranges → Synthetic Rating → Default Spread → Cost of Debt
- This is a lookup table used by the Cost of Capital sheet
- Source: Damodaran's published rating lookup tables (for large firms and small firms separately)

**Sheet 8: "Option Valuation"** — Added automatically when distress/optionality detected. See `references/option-based-valuation.md` for full methodology.

This sheet is created when ANY of these triggers fire:
- The "Bridge to Equity" sheet yields **negative equity value** (firm value < debt)
- Book value of equity is **negative**
- Interest coverage ratio is **below 1.5** (severe distress)
- User explicitly asks for option-based valuation
- Company has **significant undeveloped natural resources** or **major patents in pipeline**

**Section A: Equity as Call Option on Firm Assets (Black-Scholes)**

Inputs (all with Source columns):
```
Value of Firm Assets (S):              [= Operating Asset Value from DCF Sheet 5]  | Source: "DCF Model"
Face Value of Debt (K):                [total face value from balance sheet notes]  | Source | Period
Weighted Avg Duration of Debt (t):     [face-value-weighted avg in years]           | Source: "Debt schedule / Notes"
Equity Volatility (σ_equity):          [annualized std dev of stock returns]        | Source: "2-yr daily, NSE/Yahoo"
Debt Volatility (σ_debt):              [from rating class, default 10-15%]          | Source: "Rating class estimate"
Equity-Debt Correlation (ρ):           [default: 0.50]                             | "Assumption"
Risk-free Rate (r):                    [G-Sec/Treasury matching duration]           | Source
Dividend Yield on Firm (y):            [dividends / firm value, 0 if not paying]   | Source
```

Intermediate Calculations (all as Excel formulas):
```
Market Cap (E):                        = Price × Shares
Market Debt (D):                       = Book Debt (from Inputs sheet)
Equity Weight (w_e):                   = E / (E + D)
Debt Weight (w_d):                     = D / (E + D)
Firm Volatility (σ_firm):              = SQRT(w_e^2 × σ_e^2 + w_d^2 × σ_d^2 + 2×w_e×w_d×ρ×σ_e×σ_d)
```

Black-Scholes Model (all as Excel formulas using NORM.S.DIST):
```
d1:                                    = (LN(S/K) + (r - y + σ²/2) × t) / (σ × SQRT(t))
d2:                                    = d1 - σ × SQRT(t)
N(d1):                                 = NORM.S.DIST(d1, TRUE)
N(d2):                                 = NORM.S.DIST(d2, TRUE)

Value of Equity (Call):                = S × EXP(-y×t) × N(d1) - K × EXP(-r×t) × N(d2)
Value of Debt (Put analog):            = S - Equity Value
Implied Interest Rate on Debt:         = -LN(Debt Value / K) / t
Default Spread:                        = Implied Interest Rate - r
Risk-Neutral Probability of Default:   = N(-d2)
```

Per-Share & Comparison:
```
Option Value per Share:                = Equity (Call) / (Shares + RSUs)
DCF Value per Share:                   [from Bridge to Equity sheet — may be negative]
Current Market Price:                  [from Inputs]

Verdict:                               [If DCF < 0 and Option > 0: "DCF says bankrupt but option model
                                        shows equity has time-value worth ₹X/share due to Y years of
                                        debt duration and Z% asset volatility"]
```

Sensitivity Table: Equity Value per Share at different Firm Volatility (σ) × Debt Duration (t):
- Rows: σ from 20% to 80% in 10% steps
- Columns: t from 2 to 10 years in 2-year steps
- Shows how sensitive the option value is to these two key uncertain inputs

**Section B: Natural Resource Option (conditional — only if applicable)**
Only include if the company has significant undeveloped reserves (oil/gas/mining):
```
Value of Undeveloped Reserves (S):     [quantity × price × (1-tax)]    | Source
Development Cost (K):                  [capex to develop]              | Source
Relinquishment Period (t):             [years]                         | Source
Commodity Price Volatility (σ):        [historical ln(price) std dev]  | Source
Risk-free Rate (r):                    [matching t]                    | Source
Net Revenue Yield (y):                 [annual production rev / S]     | Source
Option Value of Undeveloped Reserves:  [Black-Scholes]
Total Firm Value:                      = DCF of producing assets + Option Value of undeveloped
```

**Section C: Patent/Product Option (conditional — only if applicable)**
Only include if the company has major patents/pipeline not yet commercialized:
```
PV of Expected Cash Flows (S):        [from product revenue projection]  | Source
Cost to Commercialize (K):            [development + launch costs]       | Source
Patent Life Remaining (t):            [years]                            | Source
Cash Flow Volatility (σ):             [from comparable products]         | Source
Annual Cost of Delay (y):             [≈ 1/t]                           | Computed
Option Value of Patent/Pipeline:      [Black-Scholes]
Total Firm Value:                     = DCF of existing products + Option Value of pipeline
```

**CRITICAL: Avoid Double Counting**
- For distressed equity-as-option: Present DCF and option values **side by side** — they are alternative views, not additive
- For natural resource options: DCF covers producing assets ONLY, option covers undeveloped ONLY — these ARE additive
- For patent options: DCF covers commercialized products ONLY, option covers pipeline ONLY — these ARE additive
- NEVER include high growth in DCF for the same assets being valued as options

### Workbook Structure — Financial (6-7 sheets)

Modeled after Damodaran's **eqexret.xls** and **divginzu.xls** approach.
Sheet 7 ("Option Valuation") is added automatically when distress/optionality is detected.

**Sheet 1: "Inputs & Assumptions"** — Mirrors non-financial input layout philosophy.

**Same source citation layout: Value | Source | Filing Period for every input row.**

Section A — Company Financials (latest quarter-end for balance sheet, TTM for income):
- Filing Basis: "Annual" or "Quarterly — TTM Computed"
- Latest Filing Date, Annual Report Used
- Company name, ticker, valuation date, currency
- Book Value of Equity (latest quarter-end) | Source | Period
- Net Income (TTM if quarterly latest) | Source | Period
- Dividends Paid (TTM) | Source | Period
- Current Stock Price | Source | Date
- Number of Shares Outstanding | Source | Period
- Return on Equity = Net Income / BV Equity (auto-computed) | "Computed" | —
- Payout Ratio = Dividends / Net Income (auto-computed) | "Computed" | —
- Retention Ratio = 1 - Payout (auto-computed) | "Computed" | —

If TTM computed, show the sub-table (same as non-financial).

Section B — Regulatory Capital (latest quarter-end):
- Tier 1 Capital | Source | Period
- CET1 (Common Equity Tier 1) Ratio | Source | Period
- Total Capital Adequacy Ratio (CAR / CRAR) | Source | Period
- Risk-Weighted Assets | Source | Period
- Net NPA Ratio | Source | Period
- Provision Coverage Ratio | Source | Period

Section B_geo — Geographic Revenue Breakdown (same as non-financial — drives blended ERP for Ke):
- Same table structure as non-financial Inputs Section B
- Note: For domestic banks (PSU banks, regional NBFCs), this is often 100% India — note it explicitly
- For private banks with NRI deposits or international branches (SBI, HDFC, Kotak international): break out foreign operations if meaningful (>5% of revenue)

Section C — Risk Inputs (each with Source column):
- Risk-free Rate (primary currency) | Source | Date
- Mature Market ERP | Source (e.g., "Damodaran Jan 2025: 4.60%") | Date
- Blended ERP (computed from geo revenue table) | "Computed from geo table" | —
  - = Σ (Revenue Weight_i × (Mature ERP + CRP_i))
- Equity Beta (use directly — do NOT unlever for financials, per Damodaran) | Source | —
  - Note: For financials, Damodaran uses equity beta directly because debt is not separable
- Cost of Equity = Rf + Beta × Blended ERP | "Computed" | —

Section D — Growth & Stable Assumptions (each with Basis column):
- High Growth Period (years) | Basis
- ROE in high-growth phase (default: current ROE, overridable) | Basis
- Payout Ratio in high-growth phase (default: current, overridable) | Basis
- Implied Growth = ROE × Retention (auto-computed — must be consistent) | "Computed"
- Stable ROE (default: converge to Cost of Equity + modest premium) | Basis
- Stable Payout Ratio (default: 1 - g_stable / ROE_stable) | "Computed"
- Stable Growth Rate (default: Risk-free rate) | Basis
- Probability of Failure (for distressed banks) | Basis

Section E — ESOP/RSU data (same as non-financial)

**Sheet 2: "Historical Analysis"** — 5-10 years of bank-specific metrics.
- **Source Row at top**: For each year column, note the source (e.g., "FY2020: Annual Report", "FY2025 TTM: Q3 Results + FY2024")
- Net Income, Book Value of Equity, Dividends, ROE, Payout Ratio
- Tier 1 Ratio, CAR, Net NPA ratio, Provision Coverage
- Sustainable Growth = ROE × Retention
- NIM (Net Interest Margin) if available
- Cost-to-Income Ratio if available
- Summary: Averages, Medians, Trend direction

**Sheet 3: "Excess Return Model"** — Year-by-year projection (Damodaran's eqexret.xls structure)

For each year (1 to n):
1. Beginning Book Value of Equity (= prior year ending BV)
2. ROE for this year (fading from current to stable)
3. Net Income = ROE × Beginning BV
4. Payout Ratio (transitioning from current to stable)
5. Dividends = Net Income × Payout
6. Retained Earnings = Net Income - Dividends
7. Ending Book Value = Beginning BV + Retained Earnings
8. Cost of Equity for this year (transitioning to stable Ke)
9. Equity Cost = Ke × Beginning BV
10. Excess Return = Net Income - Equity Cost = (ROE - Ke) × Beginning BV
11. PV of Excess Return = Excess Return / (1 + Ke)^t

Terminal Excess Return:
- If Stable ROE > Stable Ke: TV = Excess Return_{n+1} / (Ke_stable - g_stable)
- If Stable ROE = Stable Ke: TV = 0 (conservative — no persistent excess returns)
- PV of Terminal Excess Return

Regulatory Capital Check (at bottom):
- Projected Tier 1 ratio each year = (BV Equity ÷ projected RWA)
- Flag if any year falls below minimum requirement
- If growth requires capital raise, note dilution impact

**Sheet 4: "Bridge to Equity"**
```
Current Book Value of Equity:      (from Inputs)
+ PV of Excess Returns (sum):      [formula]
+ PV of Terminal Excess Returns:   [formula]
= Value of Equity (all claims):    [formula]

Options/RSU Adjustment:            (same as non-financial)
- Value of Options:                [formula]
= Equity Value to Common:          [formula]

Probability of Failure Adjustment: (same as non-financial)

÷ (Shares Outstanding + RSUs):    [formula]
= VALUE PER SHARE:                [formula — HIGHLIGHTED]

Current Market Price:              (from Inputs)
Upside / Downside %:              [formula]
Implied P/BV:                     = Value per Share / (BV Equity / Shares)
```

**Sheet 5: "Sanity Check"**
- Implied P/BV at estimated value (the fundamental metric for banks)
- Implied P/E
- P/BV vs ROE scatter context (where does this bank sit?)
- Sensitivity: Value per share at different ROE × Cost of Equity combinations
- Sensitivity: Value per share at different Stable Growth × Stable ROE combinations
- Tier 1 ratio projection over forecast period

**Sheet 6: "Synthetic Rating Table"** — Same reference lookup as non-financial (shared design)

**Sheet 7: "Option Valuation"** — Added automatically when distress detected. Same structure as Non-Financial Sheet 8.

For banks/NBFCs, the triggers are:
- Excess Return model yields **negative equity premium** (ROE persistently < Cost of Equity)
- **Book value is negative** (accumulated losses exceed equity)
- **Net NPA ratio > 10%** or Provision Coverage < 50% (severe asset quality stress)
- **CAR below regulatory minimum** (under-capitalized, risk of RBI action / PCA framework in India)
- User explicitly asks for option-based view

Key differences for financial firms:
- **S (Firm Value)**: Use total assets at book value (not DCF of operating assets — for banks, book value of assets is a reasonable approximation since most assets are marked to market or at amortized cost)
- **K (Face Value of Debt)**: Total deposits + borrowings + other liabilities at face value
- **σ (Volatility)**: Equity volatility is typically lower for banks than non-financials; use 2-3 year annualized stock return std dev
- **y (Dividend Yield)**: Dividends / Total Assets (not equity)
- All other calculations identical to Section A of Non-Financial Sheet 8

## Step 5: RSU and ESOP Handling — Damodaran's Approach

Damodaran's preferred method avoids circular reference:

1. **Compute total equity value** for ALL potential shares (common + options + RSUs)
2. **Value the options outstanding** using the Treasury Stock Method or option pricing:
   - If option details available: Use Black-Scholes to value each tranche
   - Simpler alternative: Options Value = Max(0, Estimated Value per Share - Exercise Price) × Number of Options
   - This creates a mild circularity — iterate once or twice to converge
3. **Subtract option value from equity value** before dividing by shares
4. **RSUs**: Simply add to share count (they are effectively shares)
5. **Stock-based compensation**: Damodaran treats as a real expense — it's already in operating income if company reports it there. If not, adjust EBIT downward.

In Excel, create a dedicated section in the Valuation sheet:
```
Total Equity Value:           [formula]
Less: Value of Options:       [formula]  ← Options × Max(0, Value/Share - Strike)
Equity to Common:             [formula]
Shares Outstanding + RSUs:    [formula]  ← Basic shares + unvested RSUs
Value per Share:              [formula]
```

If detailed option data is unavailable, use diluted share count from latest filing as a practical shortcut, and note this simplification.

## Step 6: Present Results

After creating the Excel file:
1. Run the recalc script to ensure zero formula errors
2. Present the file to the user
3. Provide a brief summary: Value per share, current price, upside/downside, 2-3 key assumptions driving the value
4. **State the data basis**: "Based on [10-K FY2024 / TTM from Q3 FY2025 results], filed [date]"
5. Note any data gaps or simplifications made
6. Remind the user: "Every number in the Inputs sheet has its source in the adjacent column — verify any number you're uncertain about"
7. **If Option Valuation sheet was included**, present both values clearly:
   - "DCF Value: ₹X per share (negative / very low because [reason])"
   - "Option Value: ₹Y per share (equity has option value due to Z years debt duration and W% asset volatility)"
   - "Market Price: ₹P — the market appears to be pricing in [option value / recovery / neither]"
   - For natural resources/patents: "DCF of existing operations: ₹X + Option value of [reserves/pipeline]: ₹Y = Total: ₹Z per share"

## Key Damodaran Principles

1. **Every number needs a story, every story needs a number** — justify assumptions
2. **Revenue growth must tie to reinvestment** — can't grow without investing
3. **ROIC converges to WACC in steady state** — excess returns attract competition
4. **Operating margins mean-revert** — high margins invite entry
5. **Terminal growth ≤ economy growth** — typically 2-4% nominal (or risk-free rate)
6. **For financials, debt IS the business** — never subtract debt, never compute FCFF
7. **Country risk matters — and geography determines it** — WACC must reflect WHERE revenue is earned, not just where the company is listed. An Indian IT company earning 80% in the US gets a much lower blended ERP than a domestic-only company. Use revenue weights to blend ERPs across geographies.
8. **Currency consistency is mandatory** — cash flows and discount rate must be in the same currency. If FCFF is in INR, use G-Sec as risk-free. If converting to USD, use T-bond and add full CRP.
9. **Always sanity-check** — do implied multiples make sense?
10. **Equity is a call option** — even when DCF says equity is worthless, limited liability + time + volatility give it value. Use Black-Scholes for deeply distressed firms.
11. **Never double count** — if you value an asset as an option (undeveloped reserves, patents), don't also project high growth from it in the DCF
12. **Option value is driven by volatility and time** — higher asset volatility and longer debt duration = more equity value in distress. This is why distressed equity isn't always zero.

## Error Handling

- **Negative earnings**: Use revenue-based approach, project margin recovery over time. **Also trigger Option Valuation sheet** — if debt exceeds estimated firm value, the equity-as-option view may be the only one yielding a positive equity value.
- **Negative book equity**: Automatic trigger for Option Valuation sheet. The firm's equity trades on option value (time premium + volatility premium), not intrinsic value.
- **DCF yields negative equity value**: Do NOT discard the DCF. Present it alongside the Option Valuation. Explain: "DCF says equity is worth less than zero, but the option model shows equity has value of ₹X/share because there are Y years before debt matures and the firm's assets have Z% volatility."
- **Insufficient history**: Use 3 years minimum, note the limitation prominently
- **Company in transition**: Flag restructuring/M&A, adjust projections conservatively
- **Unreliable beta**: Use sector average unlevered beta, re-lever for company's D/E
- **Conglomerates**: Note that sum-of-parts may be more appropriate
- **Cyclical companies**: Use normalized/mid-cycle earnings, not peak or trough
- **Natural resource firms**: Always check for undeveloped reserves — add option value if > 30% of total reserve base is undeveloped
- **Biotech/Pharma pre-revenue**: Primary value may be in pipeline — option model for patents, minimal DCF for existing operations
