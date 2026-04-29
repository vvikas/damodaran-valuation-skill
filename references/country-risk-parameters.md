# Country Risk Parameters for Geographic WACC Blending

This file provides the framework and reference values for computing a revenue-weighted blended WACC when a company operates across multiple countries. Always fetch the latest values from Damodaran's website at valuation time — these are illustrative ranges only.

---

## The Core Framework

**Why geographic WACC matters:**
Damodaran's key insight is that the risk of a cash flow depends on WHERE it is earned, not where the company is headquartered. An Indian IT company earning 70% of revenue in the US and Europe is exposed to US/EU risk on that 70%, not India risk. Using a single India-level ERP overstates risk and understates value for such companies.

**The formula:**
```
Blended ERP = Σ (Revenue Weight_i × Total ERP_i)

where Total ERP_i = Mature Market ERP + CRP_i

Cost of Equity = Rf (primary currency) + Beta × Blended ERP
```

**Lambda alternative (more precise for listed companies):**
```
Ke = Rf + Beta × Mature ERP + Σ (Lambda_i × CRP_i)

Lambda_i = Company's revenue % in country i / Average listed firm's revenue % in country i
```
Lambda > 1 means the company is MORE exposed to country i than the typical firm. Lambda < 1 means LESS exposed.

---

## Step-by-Step Process

1. **Get geographic revenue breakdown** from latest annual filing (segment notes).
2. **Assign each geography a country or region code.**
3. **Fetch Damodaran's latest country risk table** — search: `"Damodaran" "country risk premium" "[current year]"` or go directly to: `pages.stern.nyu.edu/~adamodar/` → "Data" → "Country Risk"
4. **Look up CRP for each country** (or regional proxy).
5. **Compute Total ERP per country** = Mature Market ERP + CRP.
6. **Compute Blended ERP** = Σ (Revenue Weight × Total ERP).
7. **Use Blended ERP in CAPM** alongside the primary valuation currency's risk-free rate.

---

## Mature Market ERP (Damodaran's Base)

- Published monthly by Damodaran (implied ERP from S&P 500)
- Recent range (2023-2025): **4.3% to 5.5%**
- Always use the value from Damodaran's website at the valuation date
- Search: `"Damodaran" "implied equity risk premium" "[year]"`

---

## Country Risk Premiums — Reference Ranges

These are approximate ranges based on Damodaran's historical estimates. **Always verify with current data from his website.**

### Tier 0: Zero CRP (Mature Markets — the benchmark)
| Country | CRP | Notes |
|---------|-----|-------|
| USA | 0.00% | The mature market benchmark |
| Germany | 0.00% | AAA-rated, core EU |
| Netherlands | 0.00% | |
| Switzerland | 0.00% | |
| Australia | 0.00% | |
| Canada | 0.00% | |
| Norway / Sweden / Denmark | 0.00% | |
| Singapore | 0.00% | |

### Tier 1: Low CRP (Developed / near-developed)
| Country | CRP Range | Sovereign Rating | Notes |
|---------|-----------|-----------------|-------|
| UK | 0.4-0.8% | AA | Post-Brexit discount |
| France | 0.4-0.8% | AA | |
| Japan | 0.4-0.8% | A+ | High debt offset by domestic ownership |
| South Korea | 0.5-1.0% | AA | |
| Israel | 0.8-1.5% | A+ | Geopolitical risk |
| Taiwan | 0.5-1.0% | AA- | Cross-strait risk |
| UAE | 0.5-1.0% | AA- | |
| Saudi Arabia | 0.8-1.5% | A | Oil-dependent |
| Spain | 0.8-1.5% | A | |
| Italy | 1.2-2.0% | BBB | Fiscal concerns |

### Tier 2: Moderate CRP (Emerging Markets — Investment Grade)
| Country | CRP Range | Sovereign Rating | Notes |
|---------|-----------|-----------------|-------|
| **India** | 1.5-3.0% | Baa3/BBB- | Most Indian valuations land here |
| China | 1.5-3.0% | A1/A+ | Regulatory + geopolitical risk |
| Brazil | 2.0-4.0% | Ba2/BB | |
| Mexico | 1.5-3.0% | Baa2/BBB | |
| Indonesia | 1.5-3.0% | Baa2/BBB | |
| Philippines | 1.5-2.5% | Baa2/BBB | |
| Thailand | 1.0-2.0% | Baa1/BBB+ | |
| Malaysia | 0.8-1.5% | A3/A- | |
| Poland | 0.8-1.5% | A2/A- | |
| Czech Republic | 0.5-1.0% | Aa3/AA- | |
| Chile | 1.0-2.0% | A2/A | |
| South Africa | 3.0-5.0% | Ba2/BB | |
| Turkey | 3.5-6.0% | B3/B+ | High inflation + currency risk |

### Tier 3: Higher CRP (Frontier / Sub-Investment Grade)
| Country | CRP Range | Notes |
|---------|-----------|-------|
| Vietnam | 2.0-4.0% | |
| Bangladesh | 2.5-4.5% | |
| Nigeria | 5.0-9.0% | |
| Kenya | 4.0-7.0% | |
| Egypt | 5.0-9.0% | |
| Pakistan | 7.0-12.0% | Current fiscal stress |
| Sri Lanka | 8.0-15.0% | Post-default |
| Russia | Not applicable | Sanctions — cannot use standard CRP |
| Venezuela / Zimbabwe | Not applicable | Hyperinflation — use real rates |

---

## Regional Aggregates (for "Rest of World" revenue buckets)

When a company reports a single "ROW" or regional bucket:

| Region | Approximate CRP | Method |
|--------|----------------|--------|
| "Europe" (mixed) | 0.5-1.0% | GDP-weighted average; mostly Western Europe |
| "Asia Pacific" (mixed) | 1.0-2.0% | China-heavy usually; adjust for Japan weight |
| "Latin America" | 2.5-4.0% | Brazil/Mexico dominant |
| "Middle East" | 1.0-2.5% | Gulf states vs. others |
| "Africa" | 4.0-7.0% | Wide range; South Africa vs. Sub-Saharan |
| "EMEA" (mixed) | 0.8-2.0% | Weight Europe heavily unless ME/Africa significant |
| "ROW" generic | 1.5-2.5% | Conservative; adjust if company commentary helps |

---

## Risk-Free Rates by Currency

Cash flows and discount rates MUST be in the same currency.

| Currency | Risk-Free Rate Proxy | Typical Range (2024-2025) | Source |
|----------|---------------------|--------------------------|--------|
| INR | India 10-year G-Sec | 6.5-7.5% | RBI, CCIL |
| USD | US 10-year Treasury | 4.0-4.8% | US Treasury |
| EUR | German 10-year Bund | 2.0-3.0% | Bundesbank |
| GBP | UK 10-year Gilt | 3.5-4.5% | UK DMO |
| JPY | Japan 10-year JGB | 0.5-1.5% | BOJ |
| CNY | China 10-year Gov Bond | 2.0-2.8% | PBOC |
| BRL | Brazil 10-year | 10.0-13.0% | BCB |

---

## Currency Translation for WACC

When the company reports revenue in multiple currencies but you're computing a single-currency WACC:

**Option 1 (recommended): Single-currency valuation**
- Convert all foreign revenues to reporting currency at spot or forward rates
- Use reporting currency risk-free rate
- Use blended ERP (revenue-weighted) — this accounts for geographic risk
- All FCFF projections in a single currency

**Option 2: Inflation-differential cross-check**
```
INR WACC ≈ USD WACC + (India inflation - US inflation)
         ≈ USD WACC + 3-4%

If USD WACC = 10%, INR WACC ≈ 13-14%
```
Use this to sanity-check your INR WACC, not to replace it.

**Option 3: Currency-specific FCFF streams**
- Build separate USD and INR FCFF streams
- Discount each at appropriate currency WACC
- Convert terminal values to single currency at terminal exchange rate
- This is most rigorous but complex; worth doing for large multinationals

---

## Special Cases

### Indian IT / BPO Companies (high USD revenue)
Most Indian IT majors earn 60-85% from USA + Europe. The correct blended ERP is dramatically lower than a pure India ERP:

Example — Company earning 70% USA, 20% Europe, 10% India:
```
Blended ERP = 0.70 × (5.0% + 0%) + 0.20 × (5.0% + 0.6%) + 0.10 × (5.0% + 2.5%)
           = 0.70 × 5.0%  +  0.20 × 5.6%  +  0.10 × 7.5%
           = 3.50%        +  1.12%          +  0.75%
           = 5.37%

vs. Pure India ERP ≈ 7.5-8.0%
```
This is a ~200bps difference in ERP — material. Always compute this properly for Indian exporters.

### Indian Pharma (US generics heavy)
Similar to IT — US revenue is the dominant risk driver. US FDA approval risk is sector-specific, not a country risk premium (use probability-weighted DCF for pending ANDAs instead).

### Pure Domestic Indian Companies
FMCG, utilities, telecom, regional banks — these earn virtually 100% in India.
- Blended ERP = India ERP (no blending needed)
- Use standard Indian G-Sec + India ERP framework from indian-market-specifics.md
- Add a note: "100% domestic revenue — no geographic WACC blending; using India ERP directly"

### Conglomerates
If a conglomerate has subsidiaries in multiple countries with very different risk profiles, consider sum-of-parts: value each segment separately with its own WACC, then add. If doing consolidated DCF, use consolidated geographic revenue weights.

---

## What to Search at Valuation Time

Always fetch these at the moment you're building the model (numbers change):

1. **Damodaran's Country Risk Table:**
   Search: `Damodaran "country risk premium" "total equity risk premium" [country] [current year]`
   Or: `site:pages.stern.nyu.edu country risk`

2. **Damodaran's Implied ERP (mature market):**
   Search: `Damodaran "implied equity risk premium" [current month year]`
   Typically published monthly.

3. **Current Risk-Free Rate (India):**
   Search: `"India 10 year government bond yield" today`
   Or check: RBI website, investing.com/rates-bonds/india-10-year-bond-yield

4. **Current Risk-Free Rate (US):**
   Search: `"US 10 year treasury yield" current`
   Or: fred.stlouisfed.org

---

## Common Errors to Avoid

1. **Adding CRP on top of a G-Sec risk-free rate without adjustment** — G-Sec already embeds some India sovereign risk. Damodaran says: if you use G-Sec as Rf, use partial CRP (or no CRP); if you use US T-bond as Rf, use full CRP.

2. **Applying India CRP to 100% of FCFF for a company earning 70% abroad** — this massively overstates risk. Use revenue weights.

3. **Using a static ERP from memory** — Damodaran updates these monthly. Always search.

4. **Applying the same risk-free rate across currencies** — each currency has its own risk-free rate. Determine which currency your valuation is in, and use that currency's risk-free rate.

5. **Double-counting CRP in beta** — if using Damodaran's country-adjusted sector betas (which already include country risk via the market), don't add CRP again. Use either a global unlevered beta + CRP, or a local market-adjusted beta without CRP.
