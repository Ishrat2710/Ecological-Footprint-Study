# Ecological Footprint Dynamics in Bangladesh (1991–2020)

**Author:** Ishrat Jahan (Shahjalal University of Science and Technology)  
**Contact:** ishrat09053@gmail.com | https://www.linkedin.com/in/ishrat-jahan2728  
**Current Status:** Hosted as an SSRN Preprint (Abstract ID = 7174279)  

---

##  Project Details
This repository hosts the replication package for the paper titled **"Ecological Footprint Dynamics in Bangladesh (1991–2020):  Roles of Nitrous Oxide Emissions, Electricity Access, Resource Rents, and Economic Growth"**. 

Using annual macro-level time-series data from 1991 to 2020, this study evaluates the long-run equilibrium and short-run dynamic interdependencies between environmental degradation and key structural macroeconomic indicators in Bangladesh. The script provided primary estimations and diagnostic checks, and to ensure exact factual reproducibility.

### Abstract
This study represents the factors affecting Bangladesh’s ecological footprint from 1991 to 2020 using ARDL bounds testing, VAR-Granger causality, impulse response functions and forecast error variance decomposition method. The results show a strong and stable causal relationship between power-industry N2O emissions and ecological footprint. The VAR-Granger causality test confirms a significant causal relationship (χ2(2)  = 24.865, p<0.001). The impulse response indicates that N2O emissions immediately increase the ecological footprint by 7.436 units in the first period and have the largest part of forecast error variance (34.56%) over a ten period horizon. Electricity access and natural resource rents also indirectly affect ecological footprint explaining 12.50% and 16.48% of forecast error variance respectively after 10 periods. Although GDP growth has a significant long run relationship in the ARDL model, the causal analysis shows that its direct impact on environmental degradation is insignificant. This indicates that the intensity of economic activities may affect economic footprint more rather than economic growth. The bidirectional result suggests that ecological damage in Bangladesh may slow economic growth. The study recommends reducing N2O emissions from the power sector by decreasing dependence on fossil fuels and increasing the use of renewable energy sources such as solar and wind power. Electricity expansion needs cleaner energy infrastructure. However, this study has limitations by its focus on Bangladesh and a short time period, highlighting the need for expanded further research.---

##  Econometric Methodology & Framework

1. **Unit root testing** — ADF, Phillips-Perron (PP), and KPSS on levels and first differences. All variables except GDPG are I(1); GDPG is I(0). `lnTNR` and `lnN2O` show mixed ADF/PP-KPSS evidence and are treated as I(1) for ARDL purposes — no variable shows I(2) behavior, so ARDL is valid.
2. **ARDL bounds testing** — ARDL(1,0,0,0,0), lag order selected by BIC. Bounds test uses Pesaran, Shin & Smith (2001) with Kripfganz & Schneider (2020) finite-sample critical values.
3. **Error-correction model** — long-run coefficients and speed of adjustment to equilibrium.
4. **Diagnostics** — multicollinearity (pairwise correlation + VIF), Breusch-Godfrey LM (serial correlation), Breusch-Pagan (heteroskedasticity), Ramsey RESET (functional form), skewness-kurtosis normality test, CUSUM/CUSUMSQ stability.
5. **VAR-Granger causality** — VAR(2), full Granger-causality Wald tests across all five equations.
6. **Impulse response functions & forecast error variance decomposition** — 10-period horizon, Cholesky ordering (lnTNR, GDPG, lnACE, lnN2O, lnECF), with an alternative ordering as a robustness check.
---

##  Variable Definitions & Data Sources

The dataset consists of 30 annual observations (1991–2020) tracking five core metrics:

| Variable | Definition | Unit | Source |
|---|---|---|---|
| `lnECF` | Ecological Footprint | Global hectares per capita (logged) | Global Footprint Network |
| `GDPG` | GDP Growth Rate | Annual % growth | WDI |
| `lnACE` | Access to Electricity | % of population (logged) | WDI |
| `lnTNR` | Total Natural Resource Rents | % of GDP (logged) | WDI |
| `lnN2O` | N₂O Emissions, Power Industry | Mt CO₂e (logged) | WDI |
---

##  Code Repository Structure

```filepath
ecological-footprint-bangladesh/
│
├── README.md
│
└── code/
    ├── 01_data_prep.do
    ├── 02_descriptive_statistics.do
    ├── 03_unit_root_tests.do
    ├── 04_ardl.do
    ├── 05_diagnostics.do
    ├── 06_var_granger.do
    ├── 07_irf.do
    ├── 08_fevd.do
    └── 09_master_do.do
```

---

### Prerequisites
* **Software:** Stata 17 or higher.
* **User-Written Packages:** The ARDL routine requires the community-developed `ardl` package.

Install the necessary package directly from the Stata terminal:
```stata
ssc install ardl, replace
```
---

## Citation & Preprint Info

Jahan, Ishrat, Ecological Footprint Dynamics in Bangladesh: The Roles of Power-Sector N2O Emissions, Electricity Access, and Natural Resource Rents (July 01, 2026). Available at SSRN: https://ssrn.com/abstract=7174279 or http://dx.doi.org/10.2139/ssrn.7174279

---
*Disclaimer: This repository serves as an open-access replication package for academic evaluation and review. All source code is configured for seamless portability across external systems.*
