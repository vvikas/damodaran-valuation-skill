# Option-Based Valuation — Damodaran's Real Options Framework

## Table of Contents
1. [When to Use Option-Based Valuation](#when)
2. [Equity as a Call Option — Distressed Firms](#equity-option)
3. [Obtaining the Inputs](#inputs)
4. [Natural Resource Options](#natural-resource)
5. [Patent / Product Options](#patent)
6. [Combining DCF with Option Value](#combining)
7. [Limitations and Caveats](#limitations)
8. [Excel Implementation](#excel)

---

## 1. When to Use Option-Based Valuation <a name="when"></a>

Option pricing is NOT a replacement for DCF — it is a complement for specific situations where DCF either breaks down or misses embedded value.

### Use option-based valuation when:

**A. Equity as a Call Option (Distressed Firms)**
- Company has **negative earnings** and high debt load
- DCF yields **negative equity value** (firm value < debt) — but equity still trades at positive prices
- Company is in or near **bankruptcy / Chapter 11 / NCLT proceedings** (India)
- **Debt-to-equity ratio is extreme** (>300% or book equity is negative)
- Firm value is **close to or below** face value of outstanding debt
- Examples: Heavily leveraged airlines, telecom firms post-capex binge, real estate firms in downturns, zombie banks

**B. Natural Resource Firms with Undeveloped Reserves**
- Oil/Gas/Mining companies holding **proven but undeveloped reserves**
- The reserves have value as an option — the firm can choose to develop them only if commodity prices justify it
- The DCF alone may undervalue the firm because it doesn't capture the optionality
- Examples: Oil E&P companies, mining firms with large unexploited deposits

**C. Firms with Valuable Patents / Products Not Yet Commercialized**
- Pharma/Biotech companies with **drugs in pipeline** but not yet generating revenue
- Tech firms with **patents** that could be commercialized
- The option to commercialize has value even if the product isn't generating cash flows yet
- Examples: Pre-revenue biotech firms, tech firms with valuable IP portfolios

### Triggers for the skill:
If during the DCF valuation any of these conditions arise, automatically add an "Option Valuation" sheet:
- DCF equity value comes out **negative** but equity is trading at positive price
- **Book value of equity is negative**
- **Debt exceeds firm value** from DCF
- Company has **significant undeveloped natural resources** or **major patents in pipeline**
- User explicitly asks about option value or distress valuation

---

## 2. Equity as a Call Option — Distressed Firms <a name="equity-option"></a>

### The Core Insight (Damodaran)

Equity in a firm is a **residual claim**: equity holders get whatever is left after all debt claims are paid. Combined with **limited liability** (shareholders can't lose more than their investment), equity behaves exactly like a **call option**:

```
Equity Payoff at Debt Maturity:
  = V - D    if V > D    (firm value exceeds debt → equity gets the surplus)
  = 0        if V ≤ D    (firm value below debt → equity walks away, limited liability)
```

This is identical to a call option with:
- **Underlying asset (S)** = Value of the firm's assets
- **Strike price (K)** = Face value of outstanding debt
- **Time to expiry (t)** = Weighted average duration/maturity of debt
- **Volatility (σ)** = Standard deviation of ln(firm value)
- **Risk-free rate (r)** = Treasury/G-Sec rate matching debt duration
- **Dividend yield (y)** = Expected cash payout as % of firm value

### Why This Matters for Distressed Firms

A standard DCF might say: Firm Value = $50M, Debt = $80M → Equity = -$30M → Worthless.

But the option model says: **Equity still has value** because:
1. **Time premium**: There is time (until debt matures) during which firm value could recover
2. **Volatility premium**: Higher volatility = higher chance that firm value rises above debt
3. **Limited liability**: If things get worse, equity holders lose nothing more

This is why stock in bankrupt firms (Chapter 11, NCLT) still trades at positive prices.

### Black-Scholes Application

Value of Equity = S × e^(-yt) × N(d1) - K × e^(-rt) × N(d2)

Where:
- d1 = [ln(S/K) + (r - y + σ²/2) × t] / (σ × √t)
- d2 = d1 - σ × √t
- N(·) = Cumulative standard normal distribution

Additional outputs from the model:
- **Value of Debt** = Firm Value - Equity Value
- **Appropriate Interest Rate on Debt** = -ln(Debt Value / Face Value) / t
- **Default Spread** = Interest Rate - Risk-free Rate
- **Risk-Neutral Probability of Default** = N(-d2)

---

## 3. Obtaining the Inputs <a name="inputs"></a>

This is the hardest part. Damodaran is clear that getting clean inputs for the option model is challenging.

### S — Value of the Firm (Underlying Asset)

Four approaches, in order of preference:

**Approach 1 (Preferred): DCF valuation of the firm as a going concern**
- Do the standard FCFF/DCF valuation assuming the firm survives
- Use the operating asset value (before subtracting debt) as S
- This is the most theoretically consistent approach

**Approach 2: Liquidation value of assets**
- Sum up the market value of all assets if sold
- Use for firms where going-concern assumption is questionable
- Typically lower than DCF value

**Approach 3: Market Value of Equity + Market Value of Debt**
- S = Market Cap + Market Value of Debt
- Damodaran notes this is **internally inconsistent** (you start with market values and the model reallocates them) but it's a practical starting point

**Approach 4: Book Value of Assets**
- Least preferred but sometimes necessary when other approaches fail
- Especially for banks/financial firms where book value approximates market value

### K — Face Value of Debt (Strike Price)

- Use the **total face value** of all outstanding debt (not market value)
- Include: Long-term debt, short-term debt, bonds, debentures, NCDs
- If multiple debt tranches exist with different maturities, use the **cumulative face value**
- For Indian companies: Include all borrowings from the balance sheet notes

### t — Time to Expiry (Duration of Debt)

- Use the **face-value-weighted average duration** of outstanding debt
- If duration data is unavailable, use the **face-value-weighted average maturity** as an approximation
- For simple cases: If all debt is one tranche, use its maturity
- For complex cases: Weight each tranche by face value
  ```
  t = Σ (Face Value_i × Duration_i) / Σ Face Value_i
  ```
- Typical range: 3-10 years for most firms

### σ — Volatility of Firm Value

This is the trickiest input. Three approaches:

**Approach 1: From Equity Volatility (most common)**
The variance of firm value can be estimated from equity and debt volatility:

```
σ²_firm = w²_e × σ²_equity + w²_d × σ²_debt + 2 × w_e × w_d × ρ_ed × σ_equity × σ_debt
```

Where:
- w_e = E/(E+D) — equity weight at market values
- w_d = D/(E+D) — debt weight at market values
- σ_equity = annualized standard deviation of stock returns (from historical data, typically 2-3 years)
- σ_debt = annualized standard deviation of bond price changes (if bonds trade), OR use bond rating-based estimates (~5-15% for investment grade, 15-30% for junk)
- ρ_ed = correlation between equity and debt returns (typically 0.3-0.7)

**Approach 2: Iterative (Damodaran's refinement)**
Since the option model itself determines the split between equity and debt value, you can iterate:
1. Start with market-based weights
2. Compute firm volatility
3. Run Black-Scholes to get equity and debt values
4. Recompute weights using model output
5. Repeat until convergence (usually 3-5 iterations)

**Approach 3: Industry/Sector average asset volatility**
- Use sector average unlevered asset volatility as a starting estimate
- Crude but useful when equity is very thinly traded

### r — Risk-Free Rate

- Use the government bond yield matching the **duration of debt**
- If t = 5 years → use 5-year G-Sec/Treasury
- If t = 10 years → use 10-year G-Sec/Treasury

### y — Dividend Yield (Cash Payout)

- This is the **expected cash payout as a percentage of firm value**
- For distressed firms that aren't paying dividends: y = 0
- For firms still paying dividends: y = Dividends / Firm Value (NOT equity)
- This term captures the "cost of waiting" — the firm loses value through cash payouts while the option is alive

---

## 4. Natural Resource Options <a name="natural-resource"></a>

Based on Damodaran's natres.xls spreadsheet.

### The Framework

An undeveloped natural resource reserve is a **call option on the commodity**:
- **S** = Value of developed reserves = Estimated quantity × Current commodity price × (1 - royalty/tax)
- **K** = Cost to develop the reserves (development capex)
- **t** = Relinquishment period (how long before the firm must develop or lose the rights)
- **σ** = Variance in ln(commodity price) — from historical commodity price data
- **r** = Risk-free rate matching the relinquishment period
- **y** = Net production revenue as % of reserve value (= the "dividend yield" — what you lose by not developing now)

### Value of the Firm

Total Firm Value = Value of developed, producing assets (DCF) + Option Value of undeveloped reserves

### When to Add This Sheet

- Oil & Gas E&P companies with significant undeveloped acreage
- Mining companies with proven but undeveloped reserves
- Any natural resource firm where undeveloped reserves are > 30% of total reserve base

---

## 5. Patent / Product Options <a name="patent"></a>

Based on Damodaran's project.xls spreadsheet.

### The Framework

A patent or product in development is a **call option on the commercial product**:
- **S** = Present value of expected cash flows from commercializing the product (discounted at appropriate rate)
- **K** = Cost to commercialize (manufacturing plant, marketing, regulatory approval costs)
- **t** = Patent life remaining (or time window to commercialize)
- **σ** = Variance in expected cash flows (or comparable product revenue variance)
- **r** = Risk-free rate
- **y** = 1/t (annual cost of delay — each year, you lose one year of patent life)

### Value of the Firm

Total Firm Value = DCF of existing products + Σ Option Value of each patent/product in pipeline

### When to Add This Sheet

- Pre-revenue biotech/pharma firms with drug pipeline
- Tech companies with major patents not yet commercialized
- R&D-heavy firms where most value lies in future products
- Any firm where pipeline/IP value is > 40% of perceived market value

---

## 6. Combining DCF with Option Value <a name="combining"></a>

Damodaran strongly warns against **double counting**. The rules:

### For Equity as Call Option (Distressed Firms)
- **Run DCF first**. If DCF gives a positive equity value that seems reasonable, use DCF. Option value is unnecessary.
- **If DCF gives negative equity value** or unreasonably low value for a firm with substantial assets and moderate debt maturity: Present the option value as a complementary view.
- Present **both values** side by side in the Sanity Check sheet:
  - DCF Value per Share: $X
  - Option Value per Share: $Y
  - Let the user decide which is more appropriate given the firm's circumstances

### For Natural Resource Options
- DCF covers **developed, producing reserves** only
- Option model covers **undeveloped reserves** only
- **Add them**: Total = DCF + Option Value (no double counting because they cover different assets)

### For Patent Options
- DCF covers **existing commercialized products** only
- Option model covers **products still in development/pipeline** only
- **Add them**: Total = DCF + Option Value
- **CRITICAL**: Do NOT include high revenue growth in the DCF for the same products you're valuing as options — that's double counting

---

## 7. Limitations and Caveats <a name="limitations"></a>

Damodaran himself is careful to note these:

1. **Debt structure complexity**: Real firms don't have single zero-coupon bonds. Multiple tranches, covenants, seniority layers make K and t approximations.

2. **Firm value estimation**: S is estimated, not observed. Using DCF for S introduces model-in-model uncertainty.

3. **Volatility estimation**: σ for firm value is not directly observable. Equity volatility is noisy for distressed firms (and increases in distress, creating a feedback loop).

4. **Dividend yield**: Distressed firms may not pay dividends, but they still have "leakage" through operating costs, maintenance capex, and creditor negotiations.

5. **American vs European option**: Real equity is more like an American option (can be exercised anytime through debt renegotiation), but Black-Scholes prices European options. This means Black-Scholes may undervalue equity.

6. **Violation of lognormality**: Firm value distribution for distressed firms is skewed — discontinuous events (bankruptcy filing, asset seizure) violate the smooth lognormal assumption.

7. **Use as a sanity check, not as THE answer**: Damodaran often uses option valuation as a cross-check on DCF, not as the primary valuation approach.

---

## 8. Excel Implementation <a name="excel"></a>

### "Option Valuation" Sheet Layout

**Section A: Equity as Call Option (for distressed firms)**

Inputs (all with Source columns):
```
Value of Firm Assets (S):          [from DCF operating value or asset liquidation]  | Source
Face Value of Debt (K):            [total face value of all outstanding debt]       | Source: Balance sheet notes
Weighted Avg Debt Duration (t):    [face-value-weighted duration in years]          | Source: Debt schedule
Equity Volatility (σ_equity):      [annualized std dev of stock returns, 2-3 yrs]  | Source: NSE/Bloomberg
Debt Volatility (σ_debt):          [from rating class or bond trading data]         | Source
Equity-Debt Correlation (ρ):       [default: 0.50, overridable]                    | Source
Risk-free Rate (r):                [G-Sec/Treasury matching duration]               | Source
Dividend Yield (y):                [dividends / firm value, or 0 if none]          | Source
```

Intermediate Calculations:
```
Market Cap (E):                    = Price × Shares
Market Debt (D):                   ≈ Book Debt (or estimated market value)
Equity Weight (w_e):               = E / (E + D)
Debt Weight (w_d):                 = D / (E + D)
Firm Volatility (σ_firm):          = SQRT(w_e² × σ_e² + w_d² × σ_d² + 2 × w_e × w_d × ρ × σ_e × σ_d)
```

Black-Scholes Calculation:
```
d1:                                = (LN(S/K) + (r - y + σ²/2) × t) / (σ × SQRT(t))
d2:                                = d1 - σ × SQRT(t)
N(d1):                             = NORM.S.DIST(d1, TRUE)
N(d2):                             = NORM.S.DIST(d2, TRUE)

Value of Equity (Call):            = S × EXP(-y×t) × N(d1) - K × EXP(-r×t) × N(d2)
Value of Debt:                     = S - Equity Value
Implied Interest Rate on Debt:     = -LN(Debt Value / K) / t
Default Spread:                    = Implied Interest Rate - r
Risk-Neutral Prob of Default:      = N(-d2)   ← useful context for the user

Value per Share (Option):          = Equity Value / Shares Outstanding
```

Comparison Section:
```
DCF Value per Share:               [from Bridge to Equity sheet]
Option Value per Share:            [from above]
Current Market Price:              [from Inputs]
```

**Section B: Natural Resource Option (if applicable)**
```
Value of Developed Reserves (S):   [estimated quantity × price × (1 - tax)]  | Source
Development Cost (K):              [cost to develop]                          | Source
Relinquishment Period (t):         [years before rights expire]              | Source
Commodity Price Volatility (σ):    [from historical commodity data]          | Source
Risk-free Rate (r):                [matching t]                              | Source
Net Revenue Yield (y):             [annual production revenue / S]           | Source

Option Value:                      [Black-Scholes formula]
```

**Section C: Patent/Product Option (if applicable)**
```
PV of Expected Cash Flows (S):    [from product revenue projection]  | Source
Cost to Commercialize (K):         [development + launch costs]       | Source
Patent Life Remaining (t):         [years]                            | Source
Cash Flow Volatility (σ):          [from comparable products]         | Source
Risk-free Rate (r):                [matching t]                       | Source
Annual Cost of Delay (y):          [≈ 1/t]                           | Computed

Option Value:                      [Black-Scholes formula]
```
