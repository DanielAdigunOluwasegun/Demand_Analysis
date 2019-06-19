//Daniel, Adigun Oluwasegun

clear all
set more off

use "C:\Users\danie\Downloads\DomData.dta" 
//summary stats
univar store week proflag dtide128 dtide64 dwisk64
//demand related stats
univar stide128 stide64 swisk64
//stats on price for the 3 products
univar ptide128 ptide64 pwisk64
//market share of the three products
egen tide128 = sum(stide128)
egen tide64 = sum(stide64)
egen wisk64 = sum(swisk64)
egen totsales = sum(stide128 + stide64 + swisk64)
// pertide128
display tide128/totsales
// pertide64
display tide64/totsales
// perwisk64
display wisk64/totsales
gen dollartide128 = stide128*ptide128
gen dollartide64 = stide64*ptide64
gen dollarwisk64 = swisk64*pwisk64
egen tide128dollarsales = sum(dollartide128)
egen tide64dollarsales = sum(dollartide64)
egen wisk64dollarsales = sum(dollarwisk64)
egen totaldollarsales = sum(dollartide128 + dollartide64 + dollarwisk64)
//persalesdollar tide128
display tide128dollarsales/totaldollarsales
//persalesdollar tide 64
display tide64dollarsales/totaldollarsales
//persalesdollar wisk64
display wisk64dollarsales/totaldollarsales

gen gap = ptide128 - ptide64
summarize gap
hist gap

gen lnstide128 = ln(stide128)
gen lnptide128 = ln(ptide128)
gen lnptide64 = ln(ptide64)
gen lnpwisk64 = ln(pwisk64)

reg lnstide128 lnptide128 lnptide64 lnpwisk64
eststo model1

reg lnstide128 lnptide128 lnptide64 lnpwisk64 i.week b2.store
eststo model2

reg lnstide128 lnptide128 lnptide64 lnpwisk64 i.week i.proflag b2.store
eststo model3

generate proflaglnptide128 = proflag*lnptide128
reg lnstide128 lnptide128 lnptide64 lnpwisk64 i.week i.proflag proflaglnptide128 b2.store
eststo model4

esttab, r2 ar2 se scalar(rmse)

use "C:\Users\danie\Downloads\DomData.dta" , clear 
gen lnstide128 = ln(stide128)
gen lnptide128 = ln(ptide128)
gen lnptide64 = ln(ptide64)
gen lnpwisk64 = ln(pwisk64)

reg lnstide128 lnptide128 lnptide64 lnpwisk64 i.week b2.store if proflag == 0
eststo model5

// generate month
gen month = month(dofm(week))
reg lnstide128 lnptide128 lnptide64 lnpwisk64 b2.store b1.month if proflag == 0
eststo model6

esttab, r2 ar2 se scalar(rmse)

