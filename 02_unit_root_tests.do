*02_unit_root_tests.do
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
log using "$logs/02_unit_root_tests.log", replace text

* 2. Load clean data
use "$clean/your_dataset.dta", clear

tsset year, yearly
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

*End
log close


