*05 var_granger.do
* Ecological Footprint Dynamics in Bangladesh (1991–2020)

* Author: Ishrat Jahan
* Software: Stata 17
clear all
set more off
set scheme s2color

* VAR Lag Selection
* Examine lag lengths
varsoc lnTNR GDPG lnACE lnN2O lnECF

* VAR(2), Stability & Granger Causality
* VAR(2) Cholesky ordering: lnTNR -> GDPG -> lnACE -> lnN2O -> lnECF
var lnTNR GDPG lnACE lnN2O lnECF, lags(1/2)

* VAR stability
varstable

* Full-system Granger causality tests
vargranger

* Impulse Response Functions 
* Ten-period horizon
irf set "results.irf", replace
irf create ecf_irf, step(10) replace

* Response of ecological footprint to shocks, use title when you want
irf graph oirf, ///
    impulse(GDPG lnACE lnECF lnN2O lnTNR) ///
    response(lnECF) ///
    yline(0, lcolor(black)) ///
    xlabel(0(2)10) ///
    byopts(cols(3) compact) ///
    title("")

*  Forecast Error Variance Decomposition 
irf table fevd, response(lnECF)
* FEVD graph
irf graph fevd, ///
    response(lnECF) ///
    xlabel(0(2)10) ///
    byopts(cols(3) compact) ///
    title("") 
* END
