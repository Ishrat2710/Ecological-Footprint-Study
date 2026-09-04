*03_ardl.do
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
log using "$logs/03_ardl.log", replace text

* 2. Load clean data
use "$clean/your_dataset.dta", clear
tsset year, yearly
* 3. ARDL Model Selection
* Requires: ssc install ardl

* 3.1 BIC-based lag selection (Maximum lag = 1)
ardl lnECF GDPG lnTNR lnACE lnN2O, maxlags(1) bic

* 3.2 Final selected specification ARDL(1,0,0,0,0)
ardl lnECF GDPG lnTNR lnACE lnN2O, lags(1 0 0 0 0) ec

* 4. ARDL Bounds test & Long-run, Short-run Estimation 
* Bounds test for cointegration
estat ectest

*End
log close
