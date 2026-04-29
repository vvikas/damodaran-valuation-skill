# Damodaran Valuation Skill for Claude

A Claude skill that performs rigorous intrinsic valuations following **Aswath Damodaran's methodology** — the gold standard for fundamental analysis. Give Claude a company name and it will fetch data, build a full Excel DCF model, and give you a fair value per share with all assumptions sourced and auditable.

Built and maintained by [@vikasgorur](https://github.com/vikasgorur).

---

## What it does

Tell Claude something like:

> *"Value Infosys using Damodaran methodology"*
> *"What's the fair value of TCS?"*
> *"Build a DCF model for Eicher Motors"*
> *"Is ABB India overvalued?"*

Claude will:

1. Fetch the latest financial filings (annual report or TTM from most recent quarterly)
2. Pull geographic revenue breakdown to compute the correct **blended WACC** — not a single flat ERP
3. Run 5-10 years of historical ROIC, margin, and reinvestment analysis
4. Build a full Excel workbook with every number sourced to the filing it came from
5. Present value per share with upside/downside vs. current market price

---

## Features

### Three valuation frameworks
- **Non-financial companies** (FCFF/DCF) — tech, pharma, consumer, auto, industrials, etc.
- **Financial companies** (Excess Return / DDM) — banks, NBFCs, insurance, asset managers
- **Distressed / option-based** — auto-triggered when DCF equity goes negative; also handles natural resource options (oil/gas reserves) and patent options (biotech pipeline)

### Geographic WACC — the right way
Most valuation tools apply a single flat ERP. This skill does it properly: it breaks out revenue by geography, looks up Damodaran's country risk premium per country, and computes a **revenue-weighted blended ERP**. An Indian IT company earning 70% in the US gets a dramatically different (lower) WACC than a purely domestic company. The Cost of Capital sheet shows exactly how each geography contributes.

### Full source citation
Every single number in the Excel model has a source column — which filing, which page, which date. No black boxes.

### Damodaran's own design patterns
- `fcffsimpleginzu.xlsx` structure for non-financials
- `eqexret.xls` structure for financials
- Synthetic rating table (Damodaran's `ratings.xls`) for cost of debt
- Default/override toggles on all key assumptions (stable growth = Rf by default, Beta → 1 in stable state, etc.)
- Sensitivity tables: WACC × stable growth, margin × revenue growth

---

## Excel workbook structure

### Non-financial companies (7-8 sheets)

| Sheet | Contents |
|-------|----------|
| 1. Inputs & Assumptions | All inputs in one place — company financials, geographic revenue table, risk parameters, growth assumptions. Every row has Value \| Source \| Filing Period |
| 2. Historical Analysis | 5-10 years of ROIC, operating margin, reinvestment rate, S/C ratio, FCFF |
| 3. Cost of Capital | Geographic revenue weights → blended ERP → Ke → WACC. Full synthetic rating table for cost of debt |
| 4. Revenue & FCFF Projection | Year-by-year DCF engine. Revenue, margins, tax, reinvestment, FCFF, discount factors, PV |
| 5. Bridge to Equity | Operating asset value → add cash, subtract debt → options/RSU adjustment → value per share |
| 6. Sanity Check | Implied P/E, EV/EBITDA, EV/Revenue vs. industry. Sensitivity tables |
| 7. Synthetic Rating Table | Damodaran's ICR → rating → default spread lookup |
| 8. Option Valuation *(if triggered)* | Black-Scholes equity-as-call-option for distressed firms, or natural resource / patent option valuation |

### Financial companies (6-7 sheets)

| Sheet | Contents |
|-------|----------|
| 1. Inputs & Assumptions | Same philosophy — adds Tier 1 Capital, NPA ratios, geographic revenue for blended Ke |
| 2. Historical Analysis | ROE, payout, sustainable growth, Tier 1 ratio, NPA, NIM |
| 3. Excess Return Model | Year-by-year: (ROE - Ke) × BV Equity, PV of excess returns |
| 4. Bridge to Equity | BV Equity + PV Excess Returns + PV Terminal Value → value per share |
| 5. Sanity Check | Implied P/BV vs ROE, sensitivity tables |
| 6. Synthetic Rating Table | Same as non-financial |
| 7. Option Valuation *(if triggered)* | For deeply distressed banks (NPA > 10%, CAR below minimum) |

---

## File structure

```
damodaran-valuation/
├── SKILL.md                          # Main skill — Claude reads this first
└── references/
    ├── country-risk-parameters.md    # Geographic WACC: CRP by country, blended ERP framework
    ├── indian-market-specifics.md    # G-Sec rates, Indian tax regimes, BSE/NSE data sources
    ├── non-financial-valuation.md    # Detailed FCFF/DCF methodology
    ├── financial-valuation.md        # Excess Return / DDM for banks and NBFCs
    └── option-based-valuation.md     # Black-Scholes for distress, natural resources, patents
```

**SKILL.md** (802 lines) is the orchestrator. It tells Claude when to read each reference file so the right detail is loaded for the right company type.

---

## Installation

### Option A: Claude.ai Skills (if you have access)

1. Clone this repo
2. Copy the `damodaran-valuation/` folder into your Claude skills directory:
   ```
   /mnt/skills/user/damodaran-valuation/
   ```
3. Claude will pick it up automatically on the next conversation

### Option B: Paste into a Claude Project

1. Create a new Claude Project
2. Open `SKILL.md` and paste its contents into the Project's custom instructions
3. Attach the reference files as uploaded documents
4. The skill will be active for all conversations in that project

### Option C: Use inline in any conversation

Copy the contents of `SKILL.md` and paste it at the start of your conversation with Claude, prefixed with: *"Use the following skill instructions for this conversation:"*

---

## Development workflow

This repo is the **source of truth**. The Claude skills directory is the deployed version.

```
GitHub repo  →  (copy files)  →  /mnt/skills/user/damodaran-valuation/
  (edit here)                        (Claude uses this at runtime)
```

**Recommended dev loop with Claude Code:**
```bash
# After editing files in the repo:
cp -r damodaran-valuation/ /mnt/skills/user/damodaran-valuation/

# Or set up a simple sync script:
./sync-skill.sh
```

---

## Companies valued so far

This skill has been used to build full DCF models for:

**Indian markets:** TCS, Infosys, Meesho, Cipla, Aurobindo Pharma, Ola Electric, Karnataka Bank, Patanjali Foods, Eicher Motors, AstraZeneca India, ABB India

**US markets:** Meta, Microsoft, Reddit, Bumble, AMC, Plug Power, Zevia, Pinterest, Figma

---

## Key Damodaran principles baked in

1. Every number needs a story, every story needs a number
2. Revenue growth must tie to reinvestment — you can't grow without investing
3. ROIC converges to WACC in steady state — excess returns attract competition
4. Terminal growth ≤ economy growth (default = risk-free rate)
5. For financials, debt IS the business — never compute FCFF for banks
6. **Geographic revenue determines WACC** — where you earn your money matters as much as how much you earn
7. Equity is a call option — even when DCF equity is negative, Black-Scholes gives it value
8. Never double count — DCF assets and option assets are mutually exclusive

---

## Data sources used

| Market | Sources |
|--------|---------|
| India | Screener.in, BSE/NSE filings, Moneycontrol, Tijori Finance, RBI (G-Sec yields) |
| US | SEC EDGAR (10-K/10-Q), Macrotrends, Yahoo Finance |
| Global risk parameters | Damodaran's website (pages.stern.nyu.edu/~adamodar) — ERP, CRP, sector betas |

---

## Changelog

### v1.1 — Geographic WACC (Apr 2025)
- Added geographic revenue breakdown as a required data gathering step
- Rebuilt Cost of Capital sheet with 6 sections: geographic weights → country ERPs → blended ERP → Ke → cost of debt → final WACC
- New reference file: `country-risk-parameters.md` — CRP ranges for 40+ countries, regional aggregates, risk-free rates by currency, Lambda approach for multinationals
- Fixed: financial company Inputs sheet now also has geographic revenue table driving blended Ke
- Added currency consistency rules and INR/USD differential cross-check
- Updated Key Principles: added geographic WACC and currency consistency as explicit principles

### v1.0 — Initial release
- Full FCFF/DCF for non-financial companies
- Excess Return model for banks and financials
- Option-based valuation for distressed firms, natural resources, patents
- TTM computation for quarterly filers
- Source citation on every input row
- Indian market specifics reference (G-Sec, tax regimes, data sources)

---

## Contributing

PRs welcome. The most useful contributions:

- **New country parameters** in `country-risk-parameters.md` — more granular CRP data, updated sovereign ratings
- **Sector-specific adjustments** — e.g., insurance vs. banking differences in the financial model, pharma-specific pipeline option handling
- **Additional data source guides** — equivalents of `indian-market-specifics.md` for other markets (Southeast Asia, MENA, LatAm)
- **Bug fixes** — if a formula in the Excel structure description is wrong, or a Damodaran principle is misapplied

---

## License

MIT. Use freely, attribution appreciated.

---

*Built on Damodaran's published methodology — see [pages.stern.nyu.edu/~adamodar](http://pages.stern.nyu.edu/~adamodar) for the source frameworks, datasets, and spreadsheet templates this skill is based on.*
