*04_diagnostics.do
* Ecological Footprint Dynamics in Bangladesh (1991–2020)

* Author: Ishrat Jahan
* Software: Stata 17
clear all
set more off

* Edit paths according to your local folder 
global root   "C:/Users/..."
global raw    "$root/data/raw"
global clean  "$root/data"
global output "$root/output"
global logs   "$root/output/logs"

capture mkdir "$output"
capture mkdir "$logs"

capture log close
log using "$logs/04_diagnostics.log", replace text

* 2. Load clean data
use "$clean/your_dataset.dta", clear
tsset year, yearly
* Final selected specification: ARDL(1,0,0,0,0)
ardl lnECF GDPG lnTNR lnACE lnN2O, lags(1 0 0 0 0) ec

  * ARDL Post-estimation Diagnostics
* Breusch-Godfrey LM test
estat bgodfrey, lags(1)
* Breusch-Pagan heteroskedasticity test
estat hettest
* Ramsey RESET test
estat ovtest
*Residual normality
capture drop resid_ardl
predict resid_ardl, residuals
sktest resid_ardl
  
*Optional residual plots
tsline resid_ardl
histogram resid_ardl, normal
qnorm resid_ardl

*CUSUM / CUSUM-Squared Stability
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
    *End
    log close
