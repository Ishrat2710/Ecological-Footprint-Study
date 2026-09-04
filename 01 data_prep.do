*data preparation step is written here
*Author-Ishrat Jahan
*Requires Stata 16+

version 17
clear all
set more off
*  edit paths to match your local folder structure
global root   "C:/Users/..."
global raw    "$root/data/raw"
global clean  "$root/data"
global logs   "$root/output/logs"
global output "$root/output"
mkdir "$logs"
log using "$logs/01_data_prep.log", replace text

* Load the prepared dataset
use "your_dataset.dta", clear
*or
import delimited "$raw/ecofootprint_bd_raw.csv", clear varnames(1)
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

keep year lnECF GDPG lnACE lnTNR lnN2O
order year lnECF GDPG lnACE lnTNR lnN2O
compress
save "$clean/ecofootprint_data.dta", replace

summarize lnECF GDPG lnACE lnTNR lnN2O

log close
