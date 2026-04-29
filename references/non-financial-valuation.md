# Non-Financial Company Valuation — Damodaran FCFF/DCF

## Table of Contents
1. [Framework Overview](#framework-overview)
2. [Revenue Projection](#revenue-projection)
3. [Operating Margin Projection](#operating-margin-projection)
4. [Tax Rate](#tax-rate)
5. [Reinvestment — The Sales-to-Capital Approach](#reinvestment)
6. [ROIC and Value Creation](#roic)
7. [WACC Calculation](#wacc)
8. [Terminal Value](#terminal-value)
9. [From Operating Value to Equity Value](#bridge)
10. [ESOP and RSU Adjustment](#esop)
11. [Common Pitfalls](#pitfalls)

---

## 1. Framework Overview <a name="framework-overview"></a>

Value of Operating Assets = Σ [FCFF_t / (1 + WACC)^t] + Terminal Value / (1 + WACC)^n

Where:
- FCFF = EBIT(1-t) - Reinvestment
- Reinvestment = CapEx - Depreciation + ΔWorking Capital
- Or using Damodaran's preferred approach: Reinvestment = ΔRevenue / Sales-to-Capital ratio

The model is typically a two-stage model:
- **High growth phase**: 5-10 years of above-average growth, fading over time
- **Stable growth phase**: Perpetuity at a sustainable growth rate

---

## 2. Revenue Projection <a name="revenue-projection"></a>

### Estimating Base Revenue Growth

Use the historical analysis to ground the projection:
- Compute CAGR over 3, 5, and 10 years
- Look at year-over-year growth rates for trends (accelerating vs decelerating)
- Consider: Is recent growth organic or acquisition-driven?
- Check: Is the industry growing? What's the company's market share trajectory?

### Growth Rate Fade

Damodaran advocates fading growth linearly from the initial rate to stable growth:

```
Year 1 growth: g_initial
Year n growth: g_stable
Intermediate years: g_t = g_initial - (g_initial - g_stable) × (t-1) / (n-1)
```

For a 10-year high growth period with 20% initial growth fading to 4% stable:
- Year 1: 20%, Year 2: 18.2%, Year 3: 16.4%, ... Year 10: 4%

### Constraints on Growth

- Growth must be funded by reinvestment: g = Reinvestment Rate × ROIC
- Revenue growth cannot exceed the market size indefinitely
- In stable state: g ≤ risk-free rate (Damodaran's rule of thumb)
- For Indian companies: stable nominal growth ~4-6% (real GDP growth + inflation expectation)

---

## 3. Operating Margin Projection <a name="operating-margin-projection"></a>

### Current Margin Analysis

- Use the trailing 12-month (TTM) operating margin as the starting point
- Compare to 5-year average and industry median
- If current margin is far from industry median, plan for convergence

### Margin Convergence

Damodaran's approach: Margins converge to a sustainable level over the projection period.

- If margin is currently above industry: assume gradual decline to sustainable level
- If margin is currently below (e.g., young company scaling): assume improvement
- The target margin should reflect the company's competitive advantages

### Sustainable Margin

In stable state, the operating margin should be consistent with:
- Industry averages for mature companies
- The company's competitive moat (brands, patents, network effects allow higher margins)
- The reinvestment needed to sustain growth

---

## 4. Tax Rate <a name="tax-rate"></a>

### Effective vs Marginal

- Use the **effective tax rate** for the high growth period (what the company actually pays)
- Transition to the **marginal/statutory tax rate** in stable state
- Rationale: Tax benefits (NOLs, special zones) are temporary; mature companies pay closer to statutory

### For Indian Companies
- Standard corporate tax: 25.17% (new regime) or ~34.94% (old regime with surcharge + cess)
- Many companies have transitioned to the new 25.17% regime
- SEZ/tax holiday benefits may reduce effective rate temporarily
- Use actual effective rate from financials, fade to 25.17% in stable state

### For US Companies
- Federal statutory: 21%
- Add state taxes: effective ~24-26% typically
- Use effective rate from 10-K, fade to ~25% in stable state

---

## 5. Reinvestment — The Sales-to-Capital Approach <a name="reinvestment"></a>

This is one of Damodaran's signature contributions to practical valuation.

### The Problem with Traditional Reinvestment

Traditional: Reinvestment = CapEx - D&A + ΔWorking Capital

This is backward-looking and volatile. Damodaran prefers tying reinvestment to revenue growth.

### Sales-to-Capital Ratio

**Definition**: How much revenue does each unit of new invested capital generate?

Incremental S/C = ΔRevenue / ΔInvested Capital

Where Invested Capital = Total Equity + Total Debt - Cash (book values)
Or: Fixed Assets + Net Working Capital

### Using S/C for Projection

Once you have the ratio (from historical average or industry data):

**Reinvestment_t = ΔRevenue_t / Sales-to-Capital ratio**

This elegantly links:
- Revenue growth to capital needs
- And therefore to ROIC (since ROIC = Margin × S/C ratio, roughly)

### Historical Computation

Compute for each year:
- Invested Capital = BV of Equity + Total Debt - Cash
- ΔInvested Capital = IC_t - IC_{t-1}
- ΔRevenue = Revenue_t - Revenue_{t-1}
- Incremental S/C = ΔRevenue / ΔInvested Capital

Take the median of the last 5 years (median is more robust to outlier years).

### Sanity Check on S/C

- If S/C ratio is very high (>5): Company is asset-light or growing on existing capacity — may not be sustainable
- If S/C ratio is very low (<1): Capital-intensive business — check if consistent with industry
- Compare to Damodaran's industry averages on his website

---

## 6. ROIC and Value Creation <a name="roic"></a>

### Computing ROIC

ROIC = EBIT × (1 - effective tax rate) / Invested Capital

- Use beginning-of-year Invested Capital (or average of beginning and end)
- This measures how efficiently the company converts capital into after-tax operating profit

### ROIC vs WACC

- **ROIC > WACC**: Company creates value — growth adds value
- **ROIC = WACC**: Growth is value-neutral
- **ROIC < WACC**: Company destroys value — growth actually destroys value!

This is critical: if ROIC < WACC, the company is better off NOT growing.

### ROIC in Projection

- In high growth phase: ROIC can exceed WACC (competitive advantage period)
- In stable state: ROIC should converge toward WACC (competition erodes excess returns)
- For companies with strong moats: ROIC can remain modestly above WACC even in stable state

### Implied ROIC Check

After building the model, verify: 
Implied ROIC = After-tax EBIT / Invested Capital = Operating Margin × (1-t) × S/C ratio

This should be consistent with your assumptions and the historical pattern.

---

## 7. WACC Calculation <a name="wacc"></a>

### Cost of Equity (CAPM)

Ke = Risk-free Rate + Beta × Equity Risk Premium + Country Risk Premium (if applicable)

**Risk-free rate**: 
- Use 10-year government bond yield
- For INR valuation: Indian 10-year G-Sec yield (~7.0-7.5% typically)
- For USD valuation: US 10-year Treasury (~4.0-4.5%)

**Equity Risk Premium (ERP)**:
- Damodaran publishes updated ERP monthly on his website
- Current mature market ERP: ~4.5-5.0% (check Damodaran's latest)
- For India, add country risk premium on top (see indian-market-specifics.md)

**Beta**:
- Use regression beta from financial data providers
- Better: Use sector unlevered beta from Damodaran's data, then re-lever:
  - Levered Beta = Unlevered Beta × (1 + (1-t) × D/E)
- Stable state beta should converge toward 1.0

### Cost of Debt

Kd (pre-tax) = Risk-free rate + Default Spread
- Default spread based on interest coverage ratio (Damodaran publishes lookup tables)
- Or: Use actual interest rate = Interest Expense / Average Debt

After-tax Kd = Kd × (1 - tax rate)

### Capital Structure Weights

- Use MARKET values of equity and debt
- Market Equity = Share Price × Shares Outstanding
- Market Debt ≈ Book Debt (reasonable approximation unless interest rates have shifted dramatically)
- In stable state, assume the company moves to an industry-average or optimal capital structure

### WACC Formula

WACC = Ke × (E / (E+D)) + Kd(1-t) × (D / (E+D))

---

## 8. Terminal Value <a name="terminal-value"></a>

### Gordon Growth Model

Terminal Value = FCFF_{n+1} / (WACC_stable - g_stable)

Where:
- FCFF_{n+1} = After-tax EBIT_{n+1} - Reinvestment_{n+1}
- g_stable = stable growth rate
- WACC_stable = WACC in stable state (may differ from high-growth WACC if beta/structure changes)

### Terminal Year FCFF

Reinvestment in stable state = g_stable / ROIC_stable
FCFF_{n+1} = EBIT_{n+1} × (1-t) × (1 - Reinvestment Rate_stable)

Where Reinvestment Rate_stable = g_stable / ROIC_stable

### Constraints

- g_stable ≤ risk-free rate (Damodaran's guideline)
- ROIC_stable should be close to WACC (modest premium OK for strong moats)
- Terminal value typically represents 50-80% of total value — this is normal but worth flagging

---

## 9. From Operating Value to Equity Value <a name="bridge"></a>

```
Value of Operating Assets (PV of FCFFs + PV of Terminal Value)
+ Cash and Marketable Securities
+ Value of Cross-Holdings (if any, at market value)
+ Other Non-Operating Assets
- Total Debt (book value, or market value if available)
- Minority Interest (at market or proportional value)
- Underfunded Pension Obligations
- Value of Management Options/RSUs (see next section)
= Equity Value to Common Shareholders
÷ Shares Outstanding
= Value per Share
```

### Notes on Bridge Items

**Cash**: Add at face value. Some argue for a discount on large cash holdings in countries with poor governance — Damodaran sometimes applies a discount.

**Cross-Holdings**: If the company owns stakes in other firms, value them at market value if listed, or estimate intrinsic value if unlisted. For Indian companies with complex holding structures, this is important.

**Debt**: Use total debt (short-term + long-term + capitalized operating leases if significant). Damodaran now capitalizes operating leases following IFRS 16/ASC 842, but check if the company's financials already do this.

---

## 10. ESOP and RSU Adjustment <a name="esop"></a>

### Damodaran's Preferred Approach

1. Estimate Value per Share from the model (Total Equity / Total Diluted Shares as a first pass)
2. Value each option tranche: Option Value = N × Black-Scholes(S=Value per Share, K=Strike, T=remaining life, σ=stock vol, r=risk-free)
3. If Black-Scholes data not available, simpler approach:
   - Option Value = N × Max(0, Estimated Value per Share - Strike Price)
4. Subtract total option value from Equity Value
5. Divide by basic shares outstanding (NOT diluted — you already accounted for options)

### Handling Circularity

The value per share appears on both sides (you need it to value options, but you need option values to get it). Solutions:
- **Iterate**: Start with market price as initial estimate, compute value, use that to re-value options, repeat 2-3 times
- **In Excel**: Use the first-pass value per share, note the mild circularity

### Stock-Based Compensation in EBIT

Damodaran treats SBC as a real operating expense. If the company includes SBC in operating expenses (most do under GAAP/IFRS), no adjustment needed. If SBC is added back (non-GAAP), subtract it from EBIT to get the true operating income.

---

## 11. Common Pitfalls <a name="pitfalls"></a>

1. **Double-counting SBC**: Don't both expense it in EBIT AND add diluted shares — pick one approach
2. **Growth without reinvestment**: If your model shows high growth but low reinvestment, the implied ROIC is unrealistic
3. **Terminal value dominance**: If >85% of value is terminal value, your near-term assumptions may be too conservative or growth period too short
4. **Mixing currencies**: Discount INR cash flows at INR WACC, USD at USD WACC — never mix
5. **Using trailing beta for high-growth company**: Forward beta should reflect the stable-state business
6. **Ignoring working capital**: For companies with long cash conversion cycles (manufacturing), ΔWC is a significant reinvestment component
7. **Tax rate mismatch**: Don't use marginal rate on NOL-shielded earnings — use actual effective rate, then fade to marginal

---

## 12. Synthetic Rating Lookup Table (from Damodaran's ratings.xls)

Use this table to estimate the cost of debt from the Interest Coverage Ratio.
Embed this table in the "Synthetic Rating Table" sheet of the Excel workbook.

### For Large Companies (Market Cap > $5 billion / ₹40,000 crore)

| Interest Coverage Ratio | Rating | Default Spread (over risk-free) |
|------------------------|--------|-------------------------------|
| > 12.5 | Aaa/AAA | 0.60% |
| 9.5 - 12.5 | Aa2/AA | 0.80% |
| 7.5 - 9.5 | A1/A+ | 1.00% |
| 6.0 - 7.5 | A2/A | 1.10% |
| 4.5 - 6.0 | A3/A- | 1.25% |
| 4.0 - 4.5 | Baa2/BBB | 1.60% |
| 3.5 - 4.0 | Ba1/BB+ | 2.00% |
| 3.0 - 3.5 | Ba2/BB | 2.50% |
| 2.5 - 3.0 | B1/B+ | 3.25% |
| 2.0 - 2.5 | B2/B | 4.00% |
| 1.5 - 2.0 | B3/B- | 5.00% |
| 1.25 - 1.5 | Caa/CCC | 6.00% |
| 0.8 - 1.25 | Ca2/CC | 7.00% |
| 0.5 - 0.8 | C2/C | 8.50% |
| < 0.5 | D2/D | 12.00% |

### For Small Companies (Market Cap < $5 billion / ₹40,000 crore)

Use higher default spreads — add approximately 1.0-1.5% to the spreads above, or use Damodaran's small-firm-specific table if available.

**Note**: These spreads are approximate and Damodaran updates them periodically. When building a model, search for "Damodaran ratings spreadsheet" to get the latest default spreads. The exact numbers shift with market conditions.

**Pre-tax Cost of Debt = Risk-free Rate + Default Spread**

---

## 13. Probability of Failure Adjustment

Damodaran incorporates a probability of failure for companies with distress risk. This is NOT built into the DCF cash flows — it's a separate adjustment at the end.

### When to Apply
- Companies with negative earnings or thin margins
- Companies with high leverage (Debt/EBITDA > 4x)
- Companies in declining industries
- Companies with ICR < 2.0

### How to Apply

Adjusted Value = (1 - P_failure) × DCF Value + P_failure × Distress Proceeds

Where:
- **P_failure**: Estimate from bond rating, bond yield, or Altman Z-score
  - AAA: ~0.01%, A: ~0.5%, BBB: ~2%, BB: ~5%, B: ~10%, CCC: ~30%
  - Or: implied default probability from bond yields
- **Distress Proceeds**: What equity holders recover in distress
  - Typically 0-30% of book value of equity
  - Higher for asset-heavy companies, lower for service/tech companies

### In the Excel Model
Include this as a section in the "Bridge to Equity" sheet:
- Cell for P_failure (default: 0%, yellow-highlighted for user input)
- Cell for Distress Proceeds (default: 15% of book value)
- Adjusted Equity Value formula

For healthy companies, P_failure = 0% and this section has no effect.
