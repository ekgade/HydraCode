
**** set memory
clear 
clear matrix
set memory 5g
set more off

pwd

cd "/Users/emilykalahgade/Desktop/pub_projects/hydra"


use HYDRA_FINAL.dta


drop iddistrict
encode district, gen(iddistrict)

*encode weekstata, gen(iweekstata)
tsset iddistrict weekstata 



****************Lowess scatterplot****************
twoway scatter ln_sig_1 ln_lag1_enemy_kia 
lowess         ln_sig_1 ln_lag1_enemy_kia

xtreg ln_sig_1 L1.net_instability L1.pub_serv_in L1.np L1.wealthin 
drop resid
predict resid, u

twoway scatter resid ln_lag1_enemy_kia 
lowess         resid ln_lag1_enemy_kia



********************Neg Binomial****************** no logged variables and no lagged DV. 
xtnbreg sig_1 L1.c.enemy_kia                                        L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 
xtnbreg sig_1 L1.c.enemy_kia L1.c.enemy_kia#L1.c.enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 
xtnbreg sig_1 L1.c.civilian_kia                                     L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 
xtnbreg sig_1 L1.c.civilian_kia L1.c.civilian_kia#L1.c.civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 

xtnbreg sig_1 L1.c.enemy_kia L1.c.enemy_kia#L1.c.enemy_kia  L1.c.civilian_kia L1.c.civilian_kia#L1.c.civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 

** with logs
xtnbreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict


**********************OLS************************* [NOTE: "regress" and "xtreg" work interchangably when using time and district dummies.] 
******logged variables with fixed effects using "fe estimator" with time dummies (twoway)--drops 3 IVs b/c of multicollinearity
xtreg ln_sig_1 L1.c.ln_enemy_kia                                                L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia            L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 
xtreg ln_sig_1 L1.c.ln_civilian_kia                                             L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe

xtreg ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia   L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe

xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe 


xtreg ln_sig_1 L1.c.ln_enemy_kia                                                L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict





******logged variables with fixed effects using dummies for both district and time--doesn't drop the three IVs, but does drop 3 districts b/c of collinearity.
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia                                              L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict, vce(robust)
*** with year
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia   L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict, vce(robust) 


xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia            L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict
xtreg ln_sig_1 L1.c.ln_civilian_kia                                             L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict
xtreg ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia   L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict

**** with year dummies instead of week dummies for fixed effects of time; removed coliniar outcomes ******
xtreg ln_sig_1 L1.c.ln_civilian_kia  L1.c.ln_enemy_kia                          L1.np i.year2 i.district
***Compare with this (no time fixed effects)
xtreg ln_sig_1 L1.c.ln_civilian_kia  L1.c.ln_enemy_kia                          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.district

** I think week fixed effects are better (but we cant use time fixed affects if we use an AR(1) model, fyI - but the ar(1) should better account for the effects of time anyway

******random effects with lagged DV, time dummies & country clustred robust SE 
xtreg ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia                                              L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, cl(iddistrict)
xtreg ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, cl(iddistrict)
xtreg ln_sig_1 ln_lag_sig_1 L1.c.ln_civilian_kia                                           L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, cl(iddistrict)
xtreg ln_sig_1 ln_lag_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, cl(iddistrict)
xtreg ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict) 

*** TESTING UNIT ROOTS ********
set more off, permanently
ssc install actest
histogram sig_1
scatter sig_1 enemy_kia

xtreg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata
*** this is the test that gives funny results and says things are correlated forever, dont know why... 
actest ln_sig_1, lags(5) robust 

dfuller ln_sig_1,
actest ln_sig_1, lags(200)

xtreg ln_sig_1 L1.ln_enemy_kia L1.ln_enemy_kia#L1.ln_enemy_kia L1.ln_civilian_kia L1.ln_civilian_kia#L1.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force


********************************************
*** this one I think should be in our robustness section
*** newy west standard errors - this is the "fiercest" model we could run - penalizes us for heteroskedasticity and for autocorrelation... plus lagged DV, plus week and district fixed effects, still has big effect but not 
* statistically significant... 
newey ln_sig_1 L1.c.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
**walds test points to inclusion of our squared term as a good idea
test L1.c.ln_civilian_kia#L1.c.ln_civilian_kia
********************************************


********************************************
*** all the possible Unit Root tests to see if it is stationary or not
xtunitroot llc ln_sig_1, lags(aic 10) demean
xtunitroot ht ln_sig_1
xtunitroot breitung ln_sig_1, demean
xtunitroot ips ln_sig_1

********************************************
**** NEWEY WEST *******


*** with only enemeys
newey ln_sig_1 L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

*** with en squared
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

** with only civilians
newey ln_sig_1 L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

** with civilians squared
newey ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

** with both but no squares
newey ln_sig_1 L1.c.ln_enemy_kia  L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

*** newey west standard errors with two way fixed effects --- FULL MODEL
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force


********************************************
** robustness tests for appendix
********************************************

************different types of models with two way fixed effects

*** OLS with lagged DV with two way fixed effects 
xtreg ln_sig_1 L1.c.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata

*** OLS with lagged DV, cluster robust standard errors and two way fixed effects 
xtreg ln_sig_1 L1.c.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)

*** newey west standard errors with two way fixed effects 
newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

***********robustness regressions with dummies for both district and time

//Time: two time periods: 2004 - 2006 and 2007 - 2009: Depressive effects of violence decline post-surge
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if year2 >=2006 & year2 <=2007, lag(5) force
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if year2 >=2007 & year2 <=2009, lag(5) force

//Space: depressive effects of violence decline in top 5 most violent governates
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if governorate !="Anbar" & governorate!="Baghdad" & governorate!="Diyala" & governorate!="Ninewa" & governorate!="Salah al-Din",lag(5) force  // w/o top 5 most violent governorates
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if district!="Karkh" & district!= "Mahmoudiya"& district!= "Ramadi"& district!= "Mosul" & district!= "Falluja", lag(5) force            // w/o top 5 most violent districts 
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if governorate =="Anbar"| governorate=="Baghdad"|governorate=="Diyala"| governorate=="Ninewa"|governorate=="Salah al-Din", lag(5) force   //only top 5 most violent governorates
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if district=="Karkh" | district== "Mahmoudiya" | district== "Ramadi" | district== "Mosul" | district== "Falluja", lag(5) force			  //only top 5 most violent districts


newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if governorate=="Baghdad",lag(5) force  // w/o top 5 most violent governorates


***** add in event count by district as proxy for troop strength ******
* with event count
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.eventcount L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

* without event count
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in  L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

*with murder
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.murder L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

*with BIG CERP Spending
newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.spent_cerp_large L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force

*with big non CERP
newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.spent_large_noncerp L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force


*** MAKING TABLES ******

ssc install outreg2

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_22Jan.xls, append ctitle(Model 1) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.murder L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_23Jan.xls, append ctitle(Model 2) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.spent_cerp_large L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_22Jan.xls, append ctitle(Model 3) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.spent_large_noncerp L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_22Jan.xls, append ctitle(Model 4) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)



newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 1) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia  L1.net_instability L1.pub_serv_in L1.murder L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 2) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.spent_cerp_large L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 3) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.spent_large_noncerp L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 4) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 5) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.murder L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 6) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.spent_cerp_large L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 7) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)

newey ln_sig_1  L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.spent_large_noncerp L1.wealthin i.iddistrict i.weekstata, lag(5) force
outreg2 using reg_24Jan.xls, append ctitle(Model 8) rdec(3) addtext(District FE, YES, Week FE, YES, Lagged DV, NO, Newey West Errors, YES)


********************************************
*** checking goodness of fits on different models
********************************************
*** comparing lagged DV to no lagged DV 
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
quietly fitstat, save
quietly regress ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
fitstat, diff

*** comparing weeks to years
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict
quietly fitstat, save
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
fitstat, diff

*** comparing quadratic term to none
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
quietly fitstat, save
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
fitstat, diff

*** comparing cluster robust ses to regular
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
quietly fitstat, save
quietly regress ln_sig_1 ln_lag_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
fitstat, diff

** trying walds test
set more off
xtreg ln_sig_1 ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia   L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
test L1.c.ln_enemy_kia#L1.c.ln_enemy_kia

set more off
xtreg ln_sig_1 ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
test L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia

kdensity(ln_sig_1)


***********robustness regressions with dummies for both district and time
//Time: two time periods: 2004 - 2006 and 2007 - 2009: Depressive effects of violence decline post-surge
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if year2 >=2004 & year2 <=2006
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if year2 >=2007 & year2 <=2009

//Space: depressive effects of violence decline in top 5 most violent governates
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if governorate !="Anbar"& governorate!="Baghdad"& governorate!="Diyala"& governorate!="Ninewa"& governorate!="Salah al-Din" // w/o top 5 most violent governorates
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if district!="Karkh" & district!= "Mahmoudiya"& district!= "Ramadi"& district!= "Mosul" & district!= "Falluja"              // w/o top 5 most violent districts 
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if governorate =="Anbar"| governorate=="Baghdad"|governorate=="Diyala"| governorate=="Ninewa"|governorate=="Salah al-Din"   //only top 5 most violent governorates
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata i.iddistrict if district=="Karkh" | district== "Mahmoudiya" | district== "Ramadi" | district== "Mosul" | district== "Falluja"			  //only top 5 most violent districts


***CHECKING OUT OTHER PREDICTED VALUES
****** predicted values
set more off
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
predict dvifbothincluded

set more off
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
predict dvifneitherincluded

xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
predict dvwithEKIAonly

xtreg ln_sig_1 ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
predict dvwithlaggedDV

xtreg ln_sig_1 ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict
predict dvnoclusters

xtreg sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)
predict withoutlogtransform


** scatter with multiple possible y variables
twoway (scatter dvifbothincluded dvifneitherincluded dvwithEKIAonly dvwithlaggedDV dvnoclusters withoutlogtransform), ///
t1("Fitted Values") ///  
legend(label(1 "quadratic") label(2 "linar") label(3 "lagged DV") ///
label(4 "no clusters") label(5 "no log transform"))


*********tsline graphs
twoway (tsline sig_1), by(governorate)

twoway tsline sig_1, name(alliraq) 
twoway tsline enemy_kia, name(enemy) xscale(off)
twoway tsline civilian_kia, name(civ) xscale(off)

graph combine civ enemy alliraq, r(3) c(1)

//Governorates
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_civilian_kia  L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2, cl(iddistrict)

twoway (tsline sig_1 if governorate == "Baghdad"), name(baghdad) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if governorate == "Tameem"), name(tameem) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if governorate == "Diyala"), name(diyala) yscale(range(0(50)300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if governorate == "Anbar"), name(anbar) yscale(range(0 300))
twoway (tsline sig_1 if governorate == "Ninewa"), name(ninewa) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if governorate == "Salah al-Din"), name(sad) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
graph combine baghdad diyala tameem anbar ninewa sad

//districts
xtreg ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.year2 i.iddistrict, vce(robust)


twoway (tsline sig_1 if district == "Karkh"), name(KH) yscale(range(0 300)) 
twoway (tsline sig_1 if district == "Mahmoudiya"), name(MA) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if district == "Falluja"), name(FJ) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if district == "Basrah"), name(BH) yscale(range(0 300))//plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if district == "Abu Ghraib"), name(AG) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
twoway (tsline sig_1 if district == "Amara"), name(AM) yscale(range(0 300)) //plotregion(style(none)) yscale(off)
graph combine KH MA FJ BH AG AM


******************************************************
*** MARGINS PLOT 

**GLM with log link
//glm sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, link(log) vce(robust)
//est store glm_est

**nbreg
xtnbreg sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store xtnbreg_est

**newey
quietly newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_est

margins, at(L1.c.ln_enemy_kia=(0(.1)6)) atmeans 
marginsplot,  recast(line) recastci(rarea)
 mcp ln_enemy_kia, var1(20)
  
*** OLS with lagged DV, cluster robust standard errors and two way fixed effects 
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia  L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_est

coefplot newey_est ols_est xtnbreg_est, drop(*.iddistrict *.weekstata _cons *.ln_sig_1) xline(0) msymbol(d) cismooth



*** OLS with no lagged DV, also, cluster robust standard errors and two way fixed effects, no logged variables for model graph
xtreg sig_1 L1.sig_1 L1.c.enemy_kia L1.c.enemy_kia#L1.c.enemy_kia  L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
margins, at(L1.c.enemy_kia=(0(10)400)) atmeans 
marginsplot,  recast(line) recastci(rarea)


summarize L1.c.enemy_kia

range w1 r(min) r(max) 20
generate lnw1 = ln(w1) 
fre w1 lnw1, tab(5)
mcp L1.c.ln_enemy_kia)
marginsplot

coefplot  m3, drop(*.iddistrict *.weekstata _cons) xline(0) msymbol(d) 

margins, at(L1.c.ln_enemy_kia=(0(.1)6)) atmeans 

*************margins plots
set more off
help margins

//regress sig_1 L1.c.sig_1 L1.c.enemy_kia L1.c.enemy_kia#L1.c.enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
//margins, at(L1.c.enemy_kia=(0(10)200)) post 
//est store ols_enemsq_margins_200
//coefplot ols_enemsq_margins_200, at

summ L1.c.ln_enemy_kia

quietly newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
margins, at(L1.c.ln_enemy_kia=(0(.1)6)) post 
est store newey_enemsq_margins

coefplot newey_enemsq_margins, at addplot(hist ln_enemy_kia)

quietly newey ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
margins, at( L1.c.ln_civilian_kia=(0(.1)7)) post 
est store newey_civsq_margins

coefplot _est_newey_civsq_margins _est_newey_enemsq_margins, at ytitle(# Insurgent Attacks (t)) xtitle(# KIA (t-1)) recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash))


********************NEWEY**********************************
** with only enemy
newey ln_sig_1 L1.c.ln_enemy_kia                                              L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_onlyenem

** with enemy squared
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata if district!="Karkh" & district!= "Mahmoudiya"& district!= "Ramadi"& district!= "Mosul" & district!= "Falluja", lag(5) force
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata if governorate =="Anbar"| governorate=="Baghdad"|governorate=="Diyala"| governorate=="Ninewa"|governorate=="Salah al-Din", lag(5) force
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata if district=="Karkh" | district== "Mahmoudiya" | district== "Ramadi" | district== "Mosul" | district== "Falluja", lag(5) force
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata if district=="Karkh" | district== "Mahmoudiya" | district== "Ramadi" | district== "Mosul" | district== "Falluja", lag(5) force

if district=="Karkh" | district== "Mahmoudiya" | district== "Ramadi" | district== "Mosul" | district== "Falluja"
est store newey_enemsq

//average marginal effects
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
margins, dydx(*) post
coefplot, xline(0) xtitle(Average maginal effects)

** with only civilians
newey ln_sig_1 L1.c.ln_civilian_kia                                           L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_onlyciv

** with civilians squared
newey ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_civsq

** with both but no squares
newey ln_sig_1 L1.c.ln_enemy_kia  L1.c.ln_civilian_kia                        L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_enem_civ

*** newey west standard errors with two way fixed effects --- FULL MODEL
newey ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, lag(5) force
est store newey_enemsq_civsq


****************OLS**************************************
** with only enemy
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia                                              L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_onlyenem

** with enemy squared
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_enemsq

** with only civilians
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_civilian_kia                                           L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_onlyciv

** with civilians squared
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_civsq

** with both but no squares
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia  L1.c.ln_civilian_kia                        L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_enem_civ

***  --- FULL MODEL
reg ln_sig_1 L1.ln_sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.iddistrict i.weekstata, vce(robust)
est store ols_enemsq_civsq

****************xtnbreg**************************************
** with only enemy
xtnbreg sig_1 L1.c.ln_enemy_kia                                              L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_onlyenem

** with enemy squared
xtnbreg sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia          L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_enemsq

** with only civilians
xtnbreg sig_1 L1.c.ln_civilian_kia                                           L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_onlyciv

** with civilians squared
xtnbreg sig_1 L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_civsq

** with both but no squares
xtnbreg sig_1 L1.c.ln_enemy_kia  L1.c.ln_civilian_kia                        L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_enem_civ

***  --- FULL MODEL
xtnbreg sig_1 L1.c.ln_enemy_kia L1.c.ln_enemy_kia#L1.c.ln_enemy_kia L1.c.ln_civilian_kia L1.c.ln_civilian_kia#L1.c.ln_civilian_kia L1.net_instability L1.pub_serv_in L1.np L1.wealthin i.weekstata, fe nolog
est store nb_enemsq_civsq

coefplot (newey_enemsq_civsq, label(Newey) msymbol(O) mcolor(black) ciopts(color(black)) levels(99 95 90)) (ols_enemsq_civsq, label(OLS) msymbol(S) mcolor(black) ciopts(color(black)) levels(99 95 90)) (nb_enemsq_civsq, label(Negative Binomial) msymbol(T) mcolor(black) ciopts(color(black)) levels(99 95 90)), drop(*.iddistrict *.weekstata *.ln_sig_1 _cons)  order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin) xline(0) msymbol(d) byopts(xrescale)  ciopts(color(black)) levels(99 95 90)


coefplot (newey_onlyenem, label(Newey)) (ols_onlyenem, label(OLS)) (nb_onlyenem, label(Negative Binomial)), bylabel(1) || newey_enemsq ols_enemsq nb_enemsq, bylabel(2) || newey_onlyciv ols_onlyciv nb_onlyciv, bylabel(3) || newey_civsq ols_civsq nb_civsq, bylabel(4) || newey_enem_civ ols_enem_civ nb_enem_civ, bylabel(5) || newey_enemsq_civsq ols_enemsq_civsq nb_enemsq_civsq, bylabel(6) ||, drop(*.iddistrict *.weekstata _cons) order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin  *.ln_sig_1)  xline(0) msymbol(d) byopts(xrescale)coefplot (newey_onlyenem, label(Newey)) (ols_onlyenem, label(OLS)) (nb_onlyenem, label(Negative Binomial)), bylabel(1) || newey_enemsq ols_enemsq nb_enemsq, bylabel(2) || newey_onlyciv ols_onlyciv nb_onlyciv, bylabel(3) || newey_civsq ols_civsq nb_civsq, bylabel(4) || newey_enem_civ ols_enem_civ nb_enem_civ, bylabel(5) || newey_enemsq_civsq ols_enemsq_civsq nb_enemsq_civsq, bylabel(6) ||, drop(*.iddistrict *.weekstata *.ln_sig_1 _cons) order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin)  xline(0) msymbol(d) byopts(xrescale)
      
coefplot (newey_enemsq, label(Newey) msymbol(o)) (ols_enemsq, label(OLS) msymbol(s)) (nb_enemsq, label(Negative Binomial) msymbol(t)), bylabel(Model 2)|| newey_civsq ols_civsq nb_civsq, bylabel(Model 4) ||, drop(*.iddistrict *.weekstata *.ln_sig_1 _cons)  order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin) xline(0) msymbol(d) byopts(xrescale) ciopts(recast(rcap) color(black))  mcolor(black)
coefplot (newey_enemsq, label(Newey) msymbol(O) mcolor(black) ciopts(color(black)) levels(99 95 90)) (ols_enemsq, label(OLS) msymbol(S) mcolor(black) ciopts(color(black)) levels(99 95 90)) (nb_enemsq, label(Negative Binomial) msymbol(T) mcolor(black) ciopts(color(black)) levels(99 95 90)), bylabel(Model 2)|| newey_civsq ols_civsq nb_civsq, bylabel(Model 4) ||, drop(*.iddistrict *.weekstata *.ln_sig_1 _cons)  order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin) xline(0) msymbol(d) byopts(xrescale)  ciopts(color(black)) levels(99 95 90)

coefplot (newey_enemsq, label(Newey) msymbol(O) mcolor(black) ciopts(color(black)) levels(99 95 90)) (ols_enemsq, label(OLS) msymbol(S) mcolor(black) ciopts(color(black)) levels(99 95 90)) (nb_enemsq, label(Negative Binomial) msymbol(T) mcolor(black) ciopts(color(black)) levels(99 95 90)), bylabel(Model 2)|| newey_civsq ols_civsq nb_civsq, bylabel(Model 4) ||, drop(*.iddistrict *.weekstata *.ln_sig_1 _cons)  order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin) xline(0) msymbol(d) byopts(xrescale)  ciopts(color(black)) levels(99 95 90)


coefplot (newey_enemsq, label(Newey) msymbol(o) mcolor(black)) (ols_enemsq, label(OLS) msymbol(s) mcolor(gs5)) (nb_enemsq, label(Negative Binomial) msymbol(th) mcolor(gs12)), bylabel(Model 2)|| newey_civsq ols_civsq nb_civsq, bylabel(Model 4) ||, drop(*.iddistrict *.weekstata *.ln_sig_1 _cons)  order(*.ln_enemy_kia *.ln_enemy_kia#*.ln_enemy_kia *.ln_civilian_kia *.ln_civilian_kia#*.ln_civilian_kia *.net_instability *.pub_serv_in *.np *.wealthin) xline(0) msymbol(d) byopts(xrescale) cismooth levels(95 90)
      
   
