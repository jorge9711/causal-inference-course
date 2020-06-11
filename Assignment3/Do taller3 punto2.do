clear all
set more off
cd "C:\Users\jorge\OneDrive\Escritorio\Assignment3"

//Importar base de datos
import excel "Taller3.xlsx", sheet("Hoja1") cellrange(A1:G12) firstrow
save Taller3Pto2Base.dta, replace

//Conservar solo las variables que necesitamos
use Taller3Pto2Base.dta, clear
keep Y D Age
save Taller3Pto2Base.dta, replace
********************************************************************************
************** OLS *************************************************************
********************************************************************************


// a) Estimar la ecuación
reg Y D, robust
outreg2 using "Table1Latex", replace tex cttop("Part (a)") title("Table 1")

*Es el mismo resultado del SDO

//b)
reg Y D Age, robust
outreg2 using "Table1Latex", append tex cttop("Part (b)") title("Table 1")

//c
reg Y D Age, robust
outreg2 using "Table2Latex", replace tex title("Table 2") label

*Probabilidad de estar en el tratamiento según la edad
reg D Age, robust
outreg2 using "Table2Latex", append tex title("Table 2") label
cap predict D_hat, xb
cap predict D_res, residuals
label variable D_res "D_res: Residual from second equation"

reg Y D_res, robust
outreg2 using "Table2Latex", append tex title("Table 2") label