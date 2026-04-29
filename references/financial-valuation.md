# Financial Company Valuation — Damodaran's Equity Approach

## Table of Contents
1. [Why Financials Are Different](#why-different)
2. [The Excess Return Model](#excess-return)
3. [Dividend Discount Model Alternative](#ddm)
4. [Key Inputs for Banks](#bank-inputs)
5. [Regulatory Capital Constraints](#regulatory)
6. [Cost of Equity for Financials](#coe)
7. [Projecting Growth for Banks](#growth)
8. [Terminal Value](#terminal)
9. [Insurance and NBFC Variations](#variations)
10. [Common Pitfalls](#pitfalls)

---

## 1. Why Financials Are Different <a name="why-different"></a>

Damodaran's core argument: For financial companies, debt is NOT financing — it is raw material.

**A bank's deposits and borrowings are like a manufacturer's raw materials.** They take in money (deposits at low rates) and lend it out (loans at higher rates). The spread is their business.

This means:
- **No FCFF**: You cannot separate operating and financing cash flows for a bank
- **No Enterprise Value**: Debt cannot be netted out
- **No WACC**: You only use Cost of Equity
- **Equity models only**: FCFE, Excess Return Model, or Dividend Discount Model
- **Book Value of Equity** is the anchor metric (not invested capital)
- **Regulatory capital** constrains growth, not capex

---

## 2. The Excess Return Model <a name="excess-return"></a>

Damodaran's preferred approach for banks. The logic: A bank is worth its book value PLUS the present value of any excess returns it generates above its cost of equity.

### Formula

**Equity Value = Book Value of Equity + PV of Excess Returns**

Where:
- Excess Return_t = (ROE_t - Cost of Equity) × Book Value of Equity_{t-1}
- Book Value grows by retained earnings: BV_t = BV_{t-1} + Net Income_t - Dividends_t

### Step-by-Step Model

For each year t (1 to n):
1. **Net Income_t** = ROE_t × Book Value_{t-1}
2. **Dividends_t** = Net Income_t × Payout Ratio_t
3. **Retained Earnings_t** = Net Income_t - Dividends_t
4. **Book Value_t** = Book Value_{t-1} + Retained Earnings_t
5. **Excess Return_t** = (ROE_t - Ke) × Book Value_{t-1}
6. **PV of Excess Return_t** = Excess Return_t / (1 + Ke)^t

Terminal Value of Excess Returns:
- If ROE → Ke in stable state: Terminal excess return = 0, and terminal value = 0
- If ROE remains above Ke: TV = Excess Return_{n+1} / (Ke - g_stable)

**Equity Value = Current Book Value + Σ PV(Excess Returns) + PV(Terminal Excess Returns)**

### Why This Model Is Elegant

- If ROE = Cost of Equity → Value = Book Value (P/BV = 1x). The bank earns exactly what shareholders require.
- If ROE > Cost of Equity → Value > Book Value (P/BV > 1x). Excess returns justify a premium.
- If ROE < Cost of Equity → Value < Book Value (P/BV < 1x). The bank destroys value.

This maps perfectly to how we observe P/BV ratios for banks in practice.

---

## 3. Dividend Discount Model Alternative <a name="ddm"></a>

For banks with stable, predictable dividend policies, the DDM can be simpler:

### Two-Stage DDM

Equity Value = Σ [DPS_t / (1+Ke)^t] + Terminal Value / (1+Ke)^n

Where:
- DPS_t = EPS_t × Payout Ratio_t
- Terminal DPS = DPS_{n+1} = DPS_n × (1 + g_stable)
- Terminal Value = DPS_{n+1} / (Ke - g_stable)

### Growth Rate in DDM

Sustainable growth = ROE × Retention Ratio = ROE × (1 - Payout Ratio)

This is Damodaran's fundamental growth equation for equity:
- A bank with 15% ROE and 30% payout has sustainable growth = 15% × 70% = 10.5%
- This constrains what growth rate you can assume without violating accounting consistency

### When to Use DDM vs Excess Return

- **DDM**: When the bank has a consistent dividend policy and stable ROE
- **Excess Return**: When ROE is changing (improving bank, bank in crisis), or when you want to explicitly model the path of returns

---

## 4. Key Inputs for Banks <a name="bank-inputs"></a>

### Book Value of Equity

- The anchor metric for bank valuation
- Use reported shareholders' equity from balance sheet
- Adjust for: Unrealized gains/losses on investment portfolio (AOCI), Preferred equity (subtract — we want common equity), Goodwill (some analysts subtract for "tangible book value")

### Return on Equity (ROE)

- ROE = Net Income / Average Book Value of Equity
- Use average of beginning and ending BV for accuracy
- **Decompose ROE**: Net Interest Margin × Asset Turnover × Equity Multiplier × (1-Tax Rate)
- Historical ROE trend matters: Is it stable, improving, or deteriorating?

### For Indian Banks specifically:
- Net Interest Margin (NIM): Typically 2.5-4% for good banks
- Credit costs (provisions): This is the biggest swing factor
- Operating efficiency: Cost-to-Income ratio
- NPA cycle: Gross NPA, Net NPA, Provision Coverage Ratio

### Net Income

- Focus on **operating profit before provisions** for understanding earnings power
- Then model credit costs (provisions for bad loans) separately
- Extraordinary items and one-time gains should be excluded

### Dividends and Payout

- RBI regulates bank dividends based on:
  - Net NPA ratio (must be < 5% for dividend payment)
  - CRAR (Capital to Risk-weighted Assets Ratio) compliance
  - Prior year losses (restrictions if losses exist)
- Typical Indian bank payout: 15-25% of net income
- International banks: Often 30-50%

---

## 5. Regulatory Capital Constraints <a name="regulatory"></a>

### Why This Matters for Valuation

Banks cannot grow freely — they are constrained by regulatory capital requirements. Growth requires either:
1. Retaining more earnings (lower dividends)
2. Raising fresh equity capital (dilution)
3. Reducing risk-weighted assets

### Key Ratios

**Tier 1 Capital Ratio** = Tier 1 Capital / Risk-Weighted Assets
- CET1 (Common Equity Tier 1) is the strictest measure
- Basel III minimum: 4.5% CET1, 6% Tier 1, 8% total CAR
- Indian banks (RBI): 5.5% CET1, 7% Tier 1, 9% CRAR (+ buffers)
- In practice, well-run Indian banks maintain 12-16% CRAR

### Incorporating Capital Constraints in Valuation

The growth rate you assume must be consistent with:
- Retained earnings available (ROE × Retention Ratio)
- Maintaining Tier 1 above regulatory minimum + buffer
- If growth requires more capital than earnings provide, the bank must raise equity (dilution) or slow growth

### Stress Testing

In the model, check:
- Does projected book value growth keep Tier 1 ratio above minimum?
- If RWA growth outpaces capital growth, the bank has a problem
- For Indian banks, also check NPA trajectory — rising NPAs consume capital through provisions

---

## 6. Cost of Equity for Financials <a name="coe"></a>

Since we don't compute WACC for banks, the Cost of Equity is the only discount rate.

### CAPM for Banks

Ke = Risk-free Rate + Beta × ERP + Country Risk Premium

**Beta for banks:**
- Bank betas reflect both business risk AND financial leverage (which is inherently high)
- Use levered (equity) beta directly — do NOT unlever and re-lever as you would for non-financials
- Damodaran's rationale: For banks, leverage IS the business, so the equity beta already captures the right risk
- Typical bank betas: 0.8-1.2 (large diversified banks lower, smaller/riskier banks higher)
- Indian bank betas: PSU banks typically higher beta (1.0-1.3), Private banks moderate (0.8-1.1)

**Country Risk Premium** (for Indian banks):
- See indian-market-specifics.md for current estimate
- This accounts for sovereign risk, currency risk (if valuing in INR), political risk

### Stable State Cost of Equity

In stable state, beta should converge toward the market:
- Large bank beta → ~1.0
- Ke_stable = Risk-free + 1.0 × ERP + CRP

---

## 7. Projecting Growth for Banks <a name="growth"></a>

### Fundamental Growth Equation

g = ROE × Retention Ratio

This is not just a formula — it's an accounting identity. If a bank has 15% ROE and retains 70% of earnings:
- Book value grows at 15% × 70% = 10.5%
- Net income grows proportionally (if ROE stays constant)

### Modeling ROE Path

High growth phase:
- Start with current ROE
- If ROE is above sustainable level (e.g., unusually low credit costs), fade it down
- If ROE is depressed (high NPAs, restructuring), model recovery toward normal
- Industry ROE benchmarks: 12-16% for well-run Indian private banks, 8-12% for PSU banks

Stable phase:
- ROE should be realistic: 12-15% for a competent bank
- If ROE > Ke significantly in perpetuity, you're assuming permanent excess returns — justify this

### Payout Ratio Path

- In high growth: Lower payout (retain more to fund growth, maintain capital ratios)
- In stable: Higher payout (60-70% typical for mature banks globally, 30-40% for Indian banks due to growth needs)
- Payout = 1 - (g / ROE) ensures internal consistency

---

## 8. Terminal Value <a name="terminal"></a>

### Excess Return Model Terminal Value

If ROE converges to Cost of Equity in stable state:
- Terminal Value = 0 (no more excess returns)
- This is the conservative approach

If a modest ROE premium persists:
- TV = Excess Return_{n+1} / (Ke_stable - g_stable)
- Excess Return_{n+1} = (ROE_stable - Ke_stable) × Book Value_n
- g_stable = ROE_stable × (1 - Payout_stable)

### DDM Terminal Value

TV = DPS_{n+1} / (Ke_stable - g_stable)

### Constraints

- g_stable ≤ nominal GDP growth for the economy
- For Indian banks: 4-6% nominal (real GDP + inflation target)
- For US banks: 2-4% nominal
- g must be consistent with: g = ROE_stable × (1 - Payout_stable)

---

## 9. Insurance and NBFC Variations <a name="variations"></a>

### Insurance Companies

- Use **Embedded Value** as the book value anchor (if available)
- Or use Appraisal Value = Embedded Value + Value of New Business
- ROE is replaced by Return on Embedded Value (ROEV)
- Discount rate is still Cost of Equity
- Key metrics: Combined ratio, investment income yield, new business margin

### NBFCs (Non-Banking Financial Companies)

- Treat similarly to banks but:
  - No deposit franchise (higher cost of funds)
  - Different regulatory capital requirements (RBI NBFC norms)
  - Asset quality metrics: Stage 2/Stage 3 instead of NPA sometimes
  - Focus on: ROA, spread (yield on advances minus cost of borrowing), leverage
- Use Excess Return model with:
  - Book Value as anchor
  - ROE reflecting the NBFC's spread and leverage
  - Regulatory capital constraint = Tier 1 of 10% (RBI NBFC requirement)

### Housing Finance Companies

- Similar to NBFCs
- Focus on: Yield on loans, cost of borrowings, NPA in housing segment
- Longer duration book = more interest rate sensitivity

---

## 10. Common Pitfalls <a name="pitfalls"></a>

1. **Computing FCFF for a bank**: This is the cardinal sin of bank valuation. There is no meaningful FCFF.
2. **Subtracting debt to get equity value**: NO. For banks, equity value comes directly from the equity model.
3. **Ignoring regulatory capital**: Growth without capital is fantasy for a bank.
4. **Using P/E alone**: P/BV is the more fundamental metric for banks. P/E is secondary.
5. **Constant ROE forever**: ROE cycles with credit quality. Model the cycle.
6. **Ignoring NPA cycle for Indian banks**: Provision costs can swing earnings 50%+. Model normalized credit costs.
7. **Not adjusting for hidden NPAs**: Some banks under-report NPAs. Check divergence reports (RBI publishes these).
8. **Double-counting**: Don't count investment income in operating earnings AND also add investment portfolio separately.
9. **Comparing across capital structures**: Higher-leverage banks naturally have higher ROE but also higher risk. Decompose ROE before comparing.
