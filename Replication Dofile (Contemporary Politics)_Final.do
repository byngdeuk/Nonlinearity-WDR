/*	****************************************************************	*/
/*     	File Name:	Replication Dofile (Contemporary Politics.do		*/
/*     	Date:   	June 03, 2022 										*/
/*      Author: 	Byung-Deuk Woo, Kieun Ryu							*/
/*      Purpose:	This file replicates Tables and Figures in "The     */
/*      Nonlinear Impact of Women's Descriptive Representation: An      */
/*      Empirical Study on the Ratification of Women Rights Treaties    */
/*		Version:	Stata/MP 17.0 										*/
/*	****************************************************************	*/

use Replication Data (Contemporary Politics)

set scheme s1mono

*Table 1*
sum WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto LeftGov

*Table 2*
xtreg WomenTreaty WD WD2, vce(cluster ccode) fe
estimate store m1

xtreg WomenTreaty WD WD2 GDPper Polity2L RegimeTrans i.LeftGov, vce(cluster ccode) fe
estimate store m2

xtreg WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) fe
estimate store m3

xtreg WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) re
estimate store m4

esttab m1 m2 m3 m4, se(3) b(3) aic bic r2

*Table 3*
xtreg WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov WomenTreatyL i.GenderQuotas HOSfemale FlaborParti FemSuff, vce(cluster ccode) fe
estimate store m5

xtregar WomenTreaty WD WD2 GDPper Polity2L Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov WomenTreatyL i.GenderQuotas HOSfemale FlaborParti FemSuff i.time, fe
estimate store m6

xtregar WomenTreaty WD WD2 GDPper Polity2L Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov WomenTreatyL i.GenderQuotas HOSfemale FlaborParti FemSuff i.time if Polity2 <6 , fe
estimate store m7

xtregar WomenTreaty WD WD2 GDPper Polity2L Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov WomenTreatyL i.GenderQuotas HOSfemale FlaborParti FemSuff i.time if Polity2 >5 , fe
estimate store m8

esttab m5 m6 m7 m8, se(3) b(3) aic(3) bic(3) r2(3)

*Figure 1*
egen WD_MEAN=mean(WD), by(year)
sort year
by year: gen dup = cond(_N == 1, 0, _n)
twoway (line WD_MEAN year if dup ==1)

*Figure 2*
xtreg WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) fe
predict yhat
rename yhat yhat11

xtreg WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) re
predict yhat
rename yhat yhat12

tw (qfitci yhat11 WD)(qfitci yhat12 WD)(kdensity WD, range(0 50) color(%30) recast(area) yaxis(2) ysc(axis(2)))

*Table A.1 in Appendix*
xtreg WomenTreaty WD WD2 LogGDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) fe
estimate store a1

xtreg WomenTreaty WD WD2 LogGDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(cluster ccode) re
estimate store a2

esttab a1 a2, se(3) b(3) aic bic r2

*Table A.2 in Appendix*
xtpoisson WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(robust) fe
estimate store a3

xtpoisson WomenTreaty WD WD2 GDPper Polity2L ColdWar Conflict Trade RegimeTrans LogWINGO IntAuto i.LeftGov, vce(robust) re
estimate store a4

esttab a3 a4, se(3) b(3) aic bic r2



