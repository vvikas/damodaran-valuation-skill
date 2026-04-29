# Indian Market Specifics for Damodaran Valuation

## Table of Contents
1. [Risk-Free Rate](#risk-free)
2. [Equity Risk Premium & Country Risk Premium](#erp)
3. [Tax Rates](#tax)
4. [Beta Estimation](#beta)
5. [Cost of Debt](#cod)
6. [Currency Considerations](#currency)
7. [Market Data Sources](#sources)

---

## 1. Risk-Free Rate <a name="risk-free"></a>

### For INR-denominated valuation
- Use the **Indian 10-year Government Security (G-Sec) yield**
- Typical range: 6.5-7.5% (as of 2024-2025)
- Source: RBI website, CCIL, or financial data providers
- Always fetch the current yield at time of valuation — do not hardcode

### For USD-denominated valuation of Indian company
- Use US 10-year Treasury yield (~4.0-4.5% range in 2024-2025)
- Then add country risk premium to ERP (not to risk-free rate)

### Damodaran's Approach
Damodaran prefers using the **US 10-year Treasury bond rate** as the global risk-free rate for USD valuations, and adds India's country risk premium to the ERP. For INR valuations, he uses the Indian G-Sec yield but notes it may contain a sovereign default premium — which then should NOT be double-counted in the CRP.

**Recommended approach for Indian companies valued in INR:**
- Risk-free rate = Indian 10-year G-Sec yield
- ERP = Mature market ERP (do NOT add full CRP separately — it's partially in the G-Sec yield already)
- OR: Risk-free rate = US 10-year Treasury, ERP = Mature market ERP + Full India CRP, then convert WACC to INR using differential inflation

The second approach is more theoretically clean but practically, using G-Sec yield + mature market ERP + a partial CRP (about 50-70% of full CRP) is common.

---

## 2. Equity Risk Premium & Country Risk Premium <a name="erp"></a>

### Mature Market ERP (Damodaran's Estimate)
- Damodaran publishes monthly updates on his website
- As of early 2025: ~4.5-5.0% for the US (mature market)
- Always search for Damodaran's latest ERP estimate when building a model

### India Country Risk Premium (CRP)

Damodaran's method:
1. Start with India's sovereign rating (currently Baa3/BBB- from Moody's/S&P)
2. Look up default spread for that rating (~1.5-2.0% for BBB-)
3. Multiply by relative equity volatility: CRP = Default Spread × (σ_equity / σ_bond)
4. Damodaran typically uses a multiplier of ~1.5x

**India CRP ≈ 1.5-3.0%** depending on the estimation method and current conditions.

### Total ERP for India (INR valuation)
If using G-Sec yield as risk-free:
- Total ERP = Mature Market ERP + Partial CRP adjustment
- ≈ 5.0% + 1.0-1.5% = 6.0-6.5%

If using US Treasury as risk-free:
- Total ERP = Mature Market ERP + Full India CRP
- ≈ 5.0% + 2.0-3.0% = 7.0-8.0%
- Then convert to INR WACC

**Practical recommendation**: Use Indian G-Sec yield (~7.0%) + ERP of 5.5-6.5%. This implicitly accounts for country risk through both the higher risk-free rate and a modest CRP add-on. Search Damodaran's latest data to get current numbers.

---

## 3. Tax Rates <a name="tax"></a>

### Corporate Tax Rates (India)

**New Tax Regime (Section 115BAA):**
- Base rate: 22%
- Surcharge: 10%
- Cess: 4%
- **Effective rate: 25.17%**
- Available to all domestic companies that forgo exemptions/deductions
- Most large companies have opted for this regime

**Old Tax Regime:**
- Income up to ₹1 crore: 30%
- Income ₹1-10 crore: 30% + 7% surcharge
- Income > ₹10 crore: 30% + 12% surcharge
- Plus 4% Health & Education Cess
- **Effective rate: 34.94%** (for large companies)
- Companies with significant tax exemptions may still be on old regime

**New Manufacturing Companies (Section 115BAB):**
- Set up after October 1, 2019, manufacturing commences before March 31, 2024
- **Effective rate: 17.16%**

**MAT (Minimum Alternate Tax):**
- 15% on book profits (+ surcharge + cess ≈ 17.47%)
- Does not apply to companies under new regime (115BAA/115BAB)

### Practical Approach
1. Check the company's actual effective tax rate from financials (Tax Expense / PBT)
2. If on new regime: Fade to 25.17% in stable state
3. If on old regime with exemptions: Fade to 25.17% (most will transition) or 34.94% if they maintain old regime
4. For banks: Some have DTA (Deferred Tax Assets) that reduce effective rate temporarily

### Capital Gains Tax (relevant for cross-holdings)
- LTCG on listed equity: 12.5% (above ₹1.25 lakh exemption, from July 2024)
- STCG on listed equity: 20% (from July 2024)
- These matter when valuing cross-holdings or investment portfolios

---

## 4. Beta Estimation <a name="beta"></a>

### Sources for Indian Company Betas
- NSE/BSE websites sometimes provide beta
- Financial data providers: Screener.in, Moneycontrol, ValueResearchOnline
- Damodaran's website: Sector-wise unlevered betas (globally and India-specific where available)

### Damodaran's Recommended Approach

1. **Use sector average unlevered beta** (more reliable than individual company regression beta)
2. **Re-lever for the company's D/E ratio**:
   - Levered Beta = Unlevered Beta × (1 + (1-t) × (D/E))
3. **For the stable period**: Move beta toward 1.0 (market average)

### Typical Sector Betas (India context, approximate)

| Sector | Unlevered Beta (approx) |
|--------|------------------------|
| IT Services | 0.85-1.0 |
| Pharma | 0.75-0.90 |
| FMCG/Consumer | 0.65-0.80 |
| Banking (equity beta directly) | 0.9-1.2 |
| Auto | 0.90-1.10 |
| Industrials/Capital Goods | 0.85-1.05 |
| Real Estate | 0.90-1.20 |
| Telecom | 0.70-0.90 |
| Oil & Gas | 0.80-1.00 |
| Power/Utilities | 0.60-0.80 |

These are indicative — always search for Damodaran's latest sector betas.

---

## 5. Cost of Debt <a name="cod"></a>

### For Indian Companies

**Method 1: Actual Interest Rate**
- Kd = Interest Expense / Average Total Debt
- Simple and reflects actual borrowing cost

**Method 2: Synthetic Rating Approach (Damodaran)**
1. Compute Interest Coverage Ratio = EBIT / Interest Expense
2. Map to a synthetic rating using Damodaran's lookup table
3. Default spread for that rating + Risk-free rate = Pre-tax Kd

### Typical Ranges (India)
- AAA-rated companies: 7.5-8.5% (G-Sec + 50-100bp)
- AA-rated: 8.0-9.5%
- A-rated: 9.0-10.5%
- BBB-rated: 10.5-12.0%
- Below investment grade: 12%+

After-tax Kd = Pre-tax Kd × (1 - tax rate)

---

## 6. Currency Considerations <a name="currency"></a>

### The Golden Rule
**Cash flows and discount rate must be in the same currency.**

### INR Valuation (Recommended for Indian companies)
- Revenue, costs, FCFF all in INR
- WACC computed using INR risk-free rate (G-Sec)
- Value per share in INR
- Compare to NSE/BSE price

### USD Valuation (Alternative)
- Convert all INR cash flows to USD using forward rates or expected depreciation
- Use US Treasury as risk-free, add full India CRP
- Not recommended unless the company earns significant USD revenue

### Inflation Differential Approach
If you want to cross-check INR vs USD valuations:
- INR WACC ≈ USD WACC + (INR inflation - USD inflation)
- Typical differential: 3-4% (India ~5% inflation, US ~2%)
- So if USD WACC = 10%, INR WACC ≈ 13-14%

---

## 7. Market Data Sources <a name="sources"></a>

### Free Sources (India)

| Source | Data Available |
|--------|---------------|
| **Screener.in** | Financials, ratios, peer comparison, 10-year history |
| **Moneycontrol** | Financials, results, shareholding, corporate actions |
| **Tijori Finance** | Clean financial data, segment data |
| **BSE India** | Annual reports, results, filings |
| **NSE India** | Corporate filings, historical prices |
| **RBI** | G-Sec yields, monetary policy rates, banking data |
| **CCIL** | Government bond yields, market data |

### Damodaran's Website
- **pages.stern.nyu.edu/~adamodar/** — The holy grail
- Updated datasets: ERP by country, sector betas, cost of capital by industry
- Spreadsheet templates for all valuation approaches
- Country risk premiums updated regularly

### Search Strategy for Indian Company Data
1. `"{Company Name}" site:screener.in` — Best for historical financials
2. `"{Company Name}" annual report {year} filetype:pdf` — For detailed notes
3. `"{Company Name}" quarterly results {quarter} {year}` — For latest data
4. `"Damodaran" "equity risk premium" {current year}` — For latest ERP
5. `"India 10 year government bond yield"` — For current risk-free rate
