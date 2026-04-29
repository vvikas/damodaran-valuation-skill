<div align="center">

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Olympic_rings_without_rims.svg/1200px-Olympic_rings_without_rims.svg.png" width="0" height="0" alt="">

# 📊 Damodaran Valuation Skill

### Rigorous intrinsic valuation — the Damodaran way — powered by Claude AI

[![Claude Skill](https://img.shields.io/badge/Claude-Skill-D97757?logo=anthropic&logoColor=white&labelColor=1a1a1a)](https://claude.ai)
[![Methodology](https://img.shields.io/badge/Methodology-Damodaran-2B6CB0?labelColor=1a1a1a)](https://pages.stern.nyu.edu/~adamodar/)
[![License: MIT](https://img.shields.io/badge/License-MIT-22C55E?labelColor=1a1a1a)](LICENSE)
[![Models Covered](https://img.shields.io/badge/Models-DCF%20%7C%20Excess%20Return%20%7C%20Options-8B5CF6?labelColor=1a1a1a)](SKILL.md)

<br>

> *Give Claude a company name. Get a full Excel DCF model — every number sourced to the filing it came from.*

<br>

---

</div>

## What this is

A **Claude skill** (a structured instruction file that Claude reads as context) that makes Claude perform investment valuation the way [Aswath Damodaran](https://pages.stern.nyu.edu/~adamodar/) — NYU Stern Professor and the world's foremost authority on valuation — actually teaches it.

Most AI valuation tools produce numbers without rigor. This skill produces models you can audit:

- Every input cell has a `Source` column pointing to the exact filing and date
- WACC is computed using **geographic revenue breakdown** — not a flat ERP
- The right model is selected automatically: DCF for operating companies, Excess Return for banks, Black-Scholes for distressed firms
- Output is a complete multi-sheet Excel workbook, structured like Damodaran's own templates

<br>

---

## How to use it

### As a Claude Code plugin (recommended)

```bash
git clone https://github.com/vvikas/damodaran-valuation-skill
cp -r damodaran-skill-repo/ /mnt/skills/user/damodaran-valuation/
```

Claude will pick it up automatically on the next conversation. Then just ask:

```
Value Infosys using Damodaran methodology
What's the fair value of TCS?
Build a DCF model for TSMC
Is Meta overvalued?
```

### As a Claude Project

1. Create a new [Claude Project](https://claude.ai)
2. Paste the contents of `SKILL.md` into **Project Instructions**
3. Upload the `references/` files as **Project Knowledge**
4. All conversations in that project now have the skill active

### Inline in any conversation

Paste the contents of `SKILL.md` at the top of your message, prefixed with:
> *"Use the following skill instructions for this conversation:"*

<br>

---

## What Claude builds

<table>
<tr>
<td width="33%" valign="top">

### 🏭 Operating Companies
*(Tech, Pharma, Consumer, Auto, Industrials)*

Full **FCFF / DCF** model:
- 5–10 yr historical ROIC & margin analysis
- Geographic revenue → blended WACC
- Revenue + FCFF projection (5–10 yr)
- Bridge: Operating assets → Equity value
- Sensitivity: WACC × growth, margin × revenue

</td>
<td width="33%" valign="top">

### 🏦 Financial Companies
*(Banks, NBFCs, Insurance, Asset Managers)*

**Excess Return / DDM** model:
- ROE, payout, sustainable growth history
- Tier 1 Capital, NPA, NIM analysis
- `(ROE − Ke) × BV Equity` per year
- PV of excess returns + terminal value
- Geographic blended Ke

</td>
<td width="33%" valign="top">

### ⚠️ Distressed / Option-Based
*(Auto-triggered when DCF equity < 0)*

**Black-Scholes equity-as-call-option:**
- Equity = Call on firm assets
- Covers natural resource firms (oil/gas reserves)
- Covers biotech (patent pipeline options)
- Never double-counts DCF + option value

</td>
</tr>
</table>

<br>

---

## The Geographic WACC — why it matters

Most tools apply a single flat equity risk premium. This skill does it properly.

```
Revenue breakdown  →  Country Risk Premium per geography  →  Revenue-weighted blended ERP
```

An Indian IT company earning **70% revenue in the US** gets a dramatically lower WACC than a purely domestic company — because most of its cash flows face US market risk, not India's. The Cost of Capital sheet shows exactly how each geography contributes, with sources from Damodaran's own country risk dataset.

<br>

---

## Excel workbook structure

### Non-financial companies (7–8 sheets)

| Sheet | What's inside |
|-------|---------------|
| **1. Inputs & Assumptions** | Every input in one place. Company financials, geographic revenue table, risk parameters, growth assumptions. Each row: `Value | Source | Filing Period` |
| **2. Historical Analysis** | 5–10 years of ROIC, operating margin, reinvestment rate, Sales/Capital, FCFF |
| **3. Cost of Capital** | Geographic revenue weights → blended ERP → Ke → WACC. Full synthetic rating table for Kd |
| **4. Revenue & FCFF Projection** | Year-by-year DCF engine. Revenue, margins, tax, reinvestment, FCFF, discount factors, PV |
| **5. Bridge to Equity** | Operating asset value → +cash −debt → options/RSU dilution → value per share |
| **6. Sanity Check** | Implied P/E, EV/EBITDA, EV/Revenue vs. sector. Sensitivity tables |
| **7. Synthetic Rating Table** | Damodaran's ICR → rating → default spread lookup |
| **8. Option Valuation** *(if triggered)* | Black-Scholes for distressed, natural resource, or patent option cases |

<br>

---

## File structure

```
damodaran-skill-repo/
├── SKILL.md                          ← Claude reads this (802 lines, the orchestrator)
├── sync-skill.sh                     ← One command to redeploy after edits
└── references/
    ├── country-risk-parameters.md    ← CRP by country, blended ERP, risk-free rates by currency
    ├── indian-market-specifics.md    ← G-Sec rates, Indian tax regimes, BSE/NSE data sources
    ├── non-financial-valuation.md    ← Full FCFF/DCF methodology
    ├── financial-valuation.md        ← Excess Return / DDM for banks and NBFCs
    └── option-based-valuation.md     ← Black-Scholes for distress, natural resources, patents
```

`SKILL.md` is the orchestrator — it tells Claude when to read each reference file so the right detail is loaded for the right company type.

<br>

---

## Companies valued with this skill

**Indian markets**
TCS · Infosys · Meesho · Cipla · Aurobindo Pharma · Ola Electric · Karnataka Bank · Patanjali Foods · Eicher Motors · AstraZeneca India · ABB India · Coforge · HCLTech

**US & Global**
Meta · Microsoft · Reddit · Bumble · AMC · Plug Power · Zevia · Pinterest · Figma · TSMC

<br>

---

## Development workflow

```
GitHub repo  ──(edit here)──▶  ./sync-skill.sh  ──▶  /mnt/skills/user/damodaran-valuation/
  source of truth                                        Claude reads this at runtime
```

Claude Code handles the sync loop:
```bash
# After editing any file in the repo:
./sync-skill.sh

# Or with Claude Code — just say:
# "Update the CRP table in the India section and redeploy"
# It commits, copies, done.
```

<br>

---

## Attribution — standing on Damodaran's shoulders

This skill is an implementation of publicly taught frameworks. All intellectual credit belongs to **Prof. Aswath Damodaran**.

<table>
<tr>
<td width="60px" align="center">📚</td>
<td>

**Free valuation course (the best finance course on the internet)**
[Valuation — MBA course, NYU Stern](http://people.stern.nyu.edu/adamodar/New_Home_Page/corpfin.html) — full lecture slides, videos, and problem sets, free

</td>
</tr>
<tr>
<td align="center">📊</td>
<td>

**Datasets used in this skill (updated annually)**
[pages.stern.nyu.edu/~adamodar/New_Home_Page/data.html](https://pages.stern.nyu.edu/~adamodar/New_Home_Page/data.html) — ERP by country, CRP, sector betas, default spreads, industry multiples

</td>
</tr>
<tr>
<td align="center">📝</td>
<td>

**Excel templates this skill mirrors**
[pages.stern.nyu.edu/~adamodar/New_Home_Page/spreadsh.htm](https://pages.stern.nyu.edu/~adamodar/New_Home_Page/spreadsh.htm) — `fcffsimpleginzu.xlsx`, `eqexret.xls`, `optiontodefault.xls`, `ratings.xls`

</td>
</tr>
<tr>
<td align="center">▶️</td>
<td>

**YouTube — full lecture series**
[youtube.com/@AswathDamodaran](https://www.youtube.com/@AswathDamodaran) — Valuation, Corporate Finance, Investment Philosophies. Thousands of hours, all free.

</td>
</tr>
<tr>
<td align="center">✍️</td>
<td>

**Musings on Markets — his blog**
[aswathdamodaran.blogspot.com](https://aswathdamodaran.blogspot.com) — real-time valuation commentary, market notes, model updates

</td>
</tr>
<tr>
<td align="center">🐦</td>
<td>

**Follow him**
[@AswathDamodaran on X](https://x.com/AswathDamodaran) — dataset release announcements, valuation takes, teaching notes

</td>
</tr>
</table>

> *"Valuation is not an exercise in looking up numbers; it's a process of understanding businesses."*
> — Aswath Damodaran

<br>

---

## Eight principles baked into the skill

These come directly from Damodaran's teaching — not rules invented here:

1. **Every number needs a story, every story needs a number** — assumptions must be narratively consistent
2. **Revenue growth must tie to reinvestment** — you can't grow without investing capital
3. **ROIC converges to WACC in steady state** — excess returns attract competition and disappear
4. **Terminal growth ≤ economy growth** — default is the risk-free rate, not analyst optimism
5. **For financials, debt IS the business** — never compute FCFF for banks; use Excess Return
6. **Geographic revenue determines WACC** — where you earn matters as much as how much you earn
7. **Equity is a call option** — even negative DCF equity has value via Black-Scholes
8. **Never double count** — DCF assets and option assets are mutually exclusive

<br>

---

## Data sources

| Market | Sources |
|--------|---------|
| **India** | Screener.in, BSE/NSE filings, Moneycontrol, Tijori Finance, RBI (G-Sec yields) |
| **US** | SEC EDGAR (10-K / 10-Q), Macrotrends, Yahoo Finance |
| **Global risk parameters** | [Damodaran's website](https://pages.stern.nyu.edu/~adamodar/) — ERP, CRP, sector betas, default spreads |

<br>

---

## Changelog

### v1.1 — Geographic WACC *(Apr 2025)*
- Geographic revenue breakdown now a required data gathering step
- Rebuilt Cost of Capital sheet with 6 sections: geographic weights → country ERPs → blended ERP → Ke → Kd → WACC
- New reference: `country-risk-parameters.md` — CRP ranges for 40+ countries, Lambda approach for multinationals
- Financial company model updated with same geographic Ke computation
- Added currency consistency rules and INR/USD differential cross-check

### v1.0 — Initial release
- Full FCFF/DCF for non-financial companies
- Excess Return model for banks and financials
- Option-based valuation for distressed firms, natural resources, patents
- TTM computation for quarterly filers
- Source citation on every input row
- Indian market specifics reference

<br>

---

## Contributing

PRs welcome. Most useful contributions:

- **New country parameters** — more granular CRP data, updated sovereign ratings in `country-risk-parameters.md`
- **Market-specific guides** — equivalents of `indian-market-specifics.md` for Southeast Asia, MENA, LatAm, Europe
- **Sector adjustments** — insurance vs. banking differences, pharma pipeline option handling
- **Bug fixes** — if a Damodaran principle is misapplied or a formula description is wrong

<br>

---

<div align="center">

Built by [@vvikas](https://github.com/vvikas) &nbsp;·&nbsp; MIT License &nbsp;·&nbsp; Powered by [Claude](https://claude.ai)

*All valuation methodology and datasets are the work of [Prof. Aswath Damodaran](https://pages.stern.nyu.edu/~adamodar/), NYU Stern School of Business.*

</div>
