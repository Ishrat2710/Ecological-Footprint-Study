* MASTER DO-FILE
* Ecological Footprint Dynamics in Bangladesh (1991–2020)

* Author: Ishrat Jahan
* Software: Stata 17

clear all
set more off

*1. Project start

* Set your working directory before running the analysis.
cd "YOUR_PROJECT_FOLDER"

* Load the prepared dataset
use "your_dataset.dta", clear
* If using Excel initially:
import excel "data/raw/your_dataset.xlsx", sheet("Sheet1") firstrow clear

*2. Basic checks:
* Check whether each year appears only once
isid year
* Confirm study period
assert year >= 1991 & year <= 2020
* Check for missing observations
foreach v of varlist ecf gdpg ace tnr n2o {

    quietly count if missing(`v')

    if r(N) > 0 {
        display as error ///
            "Warning: `r(N)' missing observations in variable `v'"
    }
}

*3. Declare time-series structure
tsset year, yearly

* 4. Variable Transformation
generate lnECF = ln(ecf)
generate lnACE = ln(ace)
generate lnTNR = ln(tnr)
generate lnN2O = ln(n2o)
rename gdpg GDPG

* 5. Variable labels
label variable lnECF "Log ecological footprint (gha per capita)"
label variable GDPG  "GDP growth rate (annual %)"
label variable lnACE "Log access to electricity (% of population)"
label variable lnTNR "Log total natural resource rents (% of GDP)"
label variable lnN2O "Log N2O emissions from power industry (Mt CO2e)"

*Analysis:
* 1. Descriptive statistics & Multicollinearity 

* 1.1 Descriptive statistics
summarize lnTNR GDPG lnACE lnN2O lnECF, detail

* 1.2 Pairwise Pearson correlations
pwcorr lnECF lnACE GDPG lnTNR lnN2O, sig obs

* 1.3 Variance Inflation Factor (Auxiliary OLS regression used only for VIF assessment)
regress lnECF lnACE lnN2O lnTNR GDPG
estat vif

* 2. Unit Root Tests 
foreach v of varlist lnECF GDPG lnACE lnTNR lnN2O {

    display "UNIT ROOT TESTS: `v'"

    * Augmented Dickey-Fuller (ADF)
    display "ADF: Level"
    dfuller `v', trend

    display "ADF: First Difference"
    dfuller D.`v'

    * Phillips-Perron (PP) - Newey-West bandwidth = 3
    display "PP: Level"
    pperron `v', trend lags(3)

    display "PP: First Difference"
    pperron D.`v', lags(3)

    * KPSS
    display "KPSS: Level"
    kpss `v', trend

    display "KPSS: First Difference"
    kpss D.`v'
}

* 3. ARDL Model Selection
* Requires: ssc install ardl

* 3.1 BIC-based lag selection (Maximum lag = 1)
ardl lnECF GDPG lnTNR lnACE lnN2O, maxlags(1) bic

* 3.2 Final selected specification ARDL(1,0,0,0,0)
ardl lnECF GDPG lnTNR lnACE lnN2O, lags(1 0 0 0 0) ec

* 4. ARDL Bounds test & Long-run, Short-run Estimation 
* Bounds test for cointegration
estat ectest

* 5. ARDL Post-estimation Diagnostics
* 5.1 Breusch-Godfrey LM test
estat bgodfrey, lags(1)
* 5.2 Breusch-Pagan heteroskedasticity test
estat hettest
* 5.3 Ramsey RESET / omitted-variable test
estat ovtest
* 5.4 Residual normality
capture drop resid_ardl
predict resid_ardl, residuals
sktest resid_ardl
* 5.5 Optional residual plots
tsline resid_ardl
histogram resid_ardl, normal
qnorm resid_ardl

* 6. CUSUM / CUSUM-SQUARED STABILITY 
* Requires: ssc install cusum6
regress D.lnECF L.lnECF GDPG lnTNR lnACE lnN2O

*CUSUM	
cusum6 D.lnECF L.lnECF GDPG lnTNR lnACE lnN2O, ///
    cs(cusum_line) ///
    lw(lower_b) ///
    uw(upper_b)
twoway ///
    (line cusum_line Year, lwidth(medium)) ///
    (line upper_b Year, lpattern(dash) lwidth(thin)) ///
    (line lower_b Year, lpattern(dash) lwidth(thin)) ///
    , ///
    title("CUSUM Test for Parameter Stability", size(small)) ///
    xtitle("Year") ///
    ytitle("CUSUM") ///
    xlabel(2000(5)2020) ///
    ylabel(-15(5)15) ///
    yline(0, lpattern(dot)) ///
    legend(order(1 "CUSUM" 2 "5% Critical Bounds") ///
           rows(1) position(6)) ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    name(CUSUM, replace)
	
*CUSUMSQ
cusum6 D.lnECF L.lnECF GDPG lnTNR lnACE lnN2O, ///
    cs2(cusumsq_line) ///
    lww(lower_sq) ///
    uww(upper_sq) ///
    sqline(center_sq)	
twoway ///
    (line cusumsq_line Year, lwidth(medium)) ///
    (line upper_sq Year, lpattern(dash) lwidth(thin)) ///
    (line lower_sq Year, lpattern(dash) lwidth(thin)) ///
    (line center_sq Year, lpattern(dot) lwidth(thin)) ///
    , ///
    title("CUSUM of Squares Test for Parameter Stability", size(small)) ///
    xtitle("Year") ///
    ytitle("CUSUM of Squares") ///
    xlabel(2000(5)2020) ///
    ylabel(0(.25)1.5) ///
    legend(order(1 "CUSUMSQ" 2 "5% Critical Bounds") ///
           rows(1) position(6)) ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    name(CUSUMSQ, replace)

* 7. VAR Lag Selection
* Examine lag lengths
varsoc lnTNR GDPG lnACE lnN2O lnECF

* 8. VAR(2), Stability & Granger Causality
* VAR(2) Cholesky ordering: lnTNR -> GDPG -> lnACE -> lnN2O -> lnECF
var lnTNR GDPG lnACE lnN2O lnECF, lags(1/2)

* VAR stability
varstable

* Full-system Granger causality tests
vargranger

* 9. Impulse Response Functions 
* Ten-period horizon
irf set "results.irf", replace
irf create ecf_irf, step(10) replace

* Response of ecological footprint to shocks, use title when you want
irf graph oirf, ///
    impulse(lnN2O GDPG lnTNR lnACE) ///
    response(lnECF) ///
    yline(0) ///
    title("Impulse Response of Ecological Footprint") 

* 10. Forecast Error Variance Decomposition 
irf table fevd, response(lnECF)
irf graph fevd, ///
    response(lnECF) ///
    title("Forecast Error Variance Decomposition of lnECF")

* 11. END
