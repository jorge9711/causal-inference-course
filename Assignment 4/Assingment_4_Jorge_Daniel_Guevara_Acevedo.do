clear all
set more off
********************************************************************************
*********** ASSINGMENT 4.                                           ************
*********** Author: Jorge Daniel Guevara Acevedo.                   ************
*********** Sunday 14th, June 2020.                                 ************
*********** Description: this contains all the processes needed to  ************
*********** execute all the regressions, graphs and tables of the   ************
*********** assingment.                                             ************ 
********************************************************************************

use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear

*3.	In the United States, an officer can arrest a driver if after giving them a blood alcohol content (BAC) test they learn the driver had a BAC of 0.08 or higher.  We will only focus on the 0.08 BAC cutoff. We will be ignoring the 0.15 cutoff for all this analysis. Create a dummy equaling 1 if bac1>= 0.08 and 0 otherwise in your do file or R file.

gen DUI=(bac1>=0.08)


*4.	The first thing to do in any RDD is look at the raw data and see if there’s any evidence for manipulation (“sorting on the running variable”).  If people were capable of manipulating their blood alcohol content (bac1), describe the test we would use to check for this.  Now evaluate whether you see this in these data?  Either recreate Figure 1 using the bac1 variable as your measure of blood alcohol content or use your own density test from software.  Do you find evidence for sorting on the running variable? 

hist bac1, freq bin(1000) bcolor(edkblue) graphregion(color(white)) bgcolor(white) plot(scatteri 0 0.08 2000 0.08, recast(line)) legend(off) xtitle("BAC")


* McCrary density test
net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace
net install lpdensity, from(https://sites.google.com/site/nppackages/lpdensity/stata) replace
rddensity bac1, c(0.08) plot all



*graph export "$Graphs\Histogram1.png", as(png) replace


*5.	The second thing we need to do is check for covariate balance.  Recreate Table 2 Panel A but only white male, age and accident (acc) as dependent variables.  Use your equation 1) for this. Are the covariates balanced at the cutoff?  It’s okay if they are not exactly the same as Hansen’s.

reg white bac1 DUI DUI#c.bac1 if bac1>0.03 & bac1<0.13, robust
reg age bac1 DUI DUI#c.bac1 if bac1>0.03 & bac1<0.13, robust
reg acc bac1 DUI DUI#c.bac1 if bac1>0.03 & bac1<0.13, robust
reg male bac1 DUI DUI#c.bac1 if bac1>0.03 & bac1<0.13, robust

outreg2 using "Table1Latex", replace tex cttop("Part (a)") title("Table 1")

*6.	Recreate Figure 2 panel A-D. You can use the -cmogram- command in Stata to do this.  Fit both linear and quadratic with confidence intervals. Discuss what you find and compare it with Hansen’s paper.

gen BAC=bac1
ssc install cmogram
cmogram acc BAC, cut(0.08) scatter line(0.08) qfitci title("Panel A. Accident at scene") legend 
cmogram acc BAC, cut(0.08) scatter line(0.08) lfitci title("Panel A. Accident at scene") legend 

cmogram male BAC, cut(0.08) scatter line(0.08) qfitci title("Panel B. Male") legend 
cmogram male BAC, cut(0.08) scatter line(0.08) lfitci title("Panel B. Male") legend 

cmogram aged BAC, cut(0.08) scatter line(0.08) qfitci title("Panel C. Age") legend 
cmogram aged BAC, cut(0.08) scatter line(0.08) lfitci title("Panel C. Age") legend 

cmogram white BAC, cut(0.08) scatter line(0.08) qfitci title("Panel D. White") legend 
cmogram white BAC, cut(0.08) scatter line(0.08) lfitci title("Panel D. White") legend

*7.	Estimate equation (1) with recidivism (recid) as the outcome.  This corresponds to Table 3 column 1, but since I am missing some of his variables, your sample size will be the entire dataset of 214,558.  Nevertheless, replicate Table 3, column 1, Panels A and B.  Note that these are local linear regressions and Panel A uses as its bandwidth 0.03 to 0.13.  But Panel B has a narrower bandwidth of 0.055 to 0.105.  Your table should have three columns and two A and B panels associated with the different bandwidths.:
*a.	Column 1: control for the bac1 linearly
*b.	Column 2: interact bac1 with cutoff linearly
*c.	Column 3: interact bac1 with cutoff linearly and as a quadratic
*d.	For all analysis, use heteroskedastic robust standard errors.

gen sq_bac= bac1^2

*Panel A
reg recid white aged acc male DUI bac1 if bac1>0.03 & bac1<0.13, robust
outreg2 using "Table3Latex", replace tex title("Table 3") label
reg recid white aged acc male DUI bac1 DUI#c.bac1 if bac1>0.03 & bac1<0.13, robust
outreg2 using "Table3Latex", append tex title("Table 3") label
reg recid white aged acc male DUI bac1 DUI#c.bac1 DUI#c.sq_bac if bac1>0.03 & bac1<0.13, robust
outreg2 using "Table3Latex", append tex title("Table 3") label

*Panel B

reg recid white aged acc male DUI bac1 if bac1>0.055 & bac1<0.105, robust
outreg2 using "Table31Latex", replace tex title("Table 31") label
reg recid white aged acc male DUI bac1 DUI#c.bac1 if bac1>0.055 & bac1<0.105, robust
outreg2 using "Table31Latex", append tex title("Table 31") label
reg recid white aged acc male DUI bac1 DUI#c.bac1 DUI#c.sq_bac if bac1>0.055 & bac1<0.105, robust
outreg2 using "Table31Latex", append tex title("Table 31") label

*8.	Recreate the top panel of Figure 3 according to the following rule: 
*a.	Fit linear fit using only observations with less than 0.15 bac on the bac1.
*b.	Fit quadratic fit using only observations with less than 0.15 bac on the bac1.

keep if bac1<=0.15

cmogram recid BAC, cut(0.08) scatter line(0.08) qfit title("Panel A. All Offenders") legend 
cmogram recid BAC, cut(0.08) scatter line(0.08) lfit title("Panel A. All Offenders") legend 






