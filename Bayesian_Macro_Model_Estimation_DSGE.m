close all;

// ==================================================
// VARIABLES, ENDOGENOUS
// ==================================================
var gY_obs // _observed GDP growth
    gYBar // growth of potential GDP level
    G // Potential growth
    y // output gap
    ppi // inflation
    ppi_obs // _observed inflation
    tcr // real exchange rate
    tcr_obs // _observed tcr
    U_obs // _observed unemployment
    u // unemployment gap
    UBar // Natural unemployment level
    gUBar // Natural unemployment growth
    r_obs // observed real int rate 
    r // neutral real int rate
    e
    z
    y_usa // output gap usa
    y_usa_obs // observed output gap usa

;

// ==================================================
// VARIABLES, EXOGENOUS
// ==================================================
varexo eps_YBar // shock potential gdp level
       eps_G    // shock potential gdp growth
       eps_y    // shock to output gap
       eps_ppi  // shock to inflation
       eps_tcr  // shock to tcr
       eps_u    // shock to unemployment gap
       eps_UBar // shock to natural unemployment level
       eps_gUBar// shock to natural unemployment growth
       eps_y_usa// shock to output gap usa
       eps_r
       eps_z
;
// ==================================================
// PARAMETERS
// ==================================================

parameters THETA Gss PHI  SIG_eps_YBar SIG_eps_G SIG_eps_y // Related to output
           BETTA LAMBDA KAPPA GAMMA SIG_eps_ppi ppiss// Related to inflation 
           TAU_5 SIG_eps_tcr tcrss// Related to TCR
           TAU_1 TAU_2 TAU_3 TAU_4 Uss SIG_eps_UBar SIG_eps_gUBar SIG_eps_u //Related to unemployment
           yss_usa TAU_6 SIG_eps_y_usa// Related to output gap usa
           PHI_2 SIG_eps_r SIG_eps_z ETA RHO rss
;

// ==================================================
// CALIBRATION: Posterior mode in BCCh paper 2015
// ==================================================
// Related to output
THETA=0.7; 
Gss=4.2; 
PHI=0.6;
SIG_eps_YBar =0.5;
SIG_eps_G=0.5; 
SIG_eps_y=0.5;  

// Related to inflation 
BETTA=0.9998; 
LAMBDA=0.2; 
KAPPA=0.1; 
GAMMA=0.075; 
SIG_eps_ppi=0.5;  
ppiss=3/4;

// Related to TCR           
TAU_5=0.6 ;
SIG_eps_tcr=3;
tcrss=450; 

//Related to unemployment
TAU_1=0.2; 
TAU_2=0.5; 
TAU_3=0.5; 
TAU_4=0.5; 
Uss=7.7; 
SIG_eps_u=0.05;  
SIG_eps_UBar=0.05;  
SIG_eps_gUBar=0.5;

// Related to output gap usa
yss_usa= 0;
TAU_6=0.5;
SIG_eps_y_usa=0.5;

// Related to interest rate
PHI_2=0.5;
SIG_eps_r=0.5;
SIG_eps_z=0.5;
ETA=0;
RHO=0.5;
rss=0.5;

// ==================================================
// MODEL
// ==================================================

model(linear);

gY_obs = gYBar +y - y(-1);// _observed GDP growth OK
gYBar = Gss/4 + G + SIG_eps_YBar*eps_YBar; // growth of potential GDP level OK
G = THETA*G(-1) + SIG_eps_G*eps_G; // potential GDP growth OK
y = PHI*y(-1) + SIG_eps_y*eps_y; // output gap OK

ppi=LAMBDA/(1+BETTA*LAMBDA)*ppi(-1) + BETTA/(1+BETTA*LAMBDA)*ppi(+1) + KAPPA*y + GAMMA*tcr + SIG_eps_ppi*eps_ppi; // Inflation OK
ppi_obs = ppi + ppiss; 


tcr_obs = tcr + tcrss;
tcr=TAU_5*tcr(-1) + SIG_eps_tcr*eps_tcr; //TCR

U_obs = u + UBar; // _observed unemployment OK
u = -TAU_1*y + TAU_2*u(-1) + SIG_eps_u*eps_u; // unemployment gap OK
UBar = TAU_4*Uss + (1-TAU_4)*UBar(-1) + gUBar + SIG_eps_UBar*eps_UBar; // Natural unemployment level OK
gUBar = (1-TAU_3)*gUBar(-1) + SIG_eps_gUBar*eps_gUBar ;   // Natural unemployment growth OK

y_usa_obs = y_usa + yss_usa;
y_usa = TAU_6*y_usa(-1) + SIG_eps_y_usa*eps_y_usa;

r_obs= r + e;
e=PHI_2*e(-1)+SIG_eps_r*eps_r;
r= rss + ETA*G+z;
z=RHO*z(-1)+SIG_eps_z*eps_z;

end;

// ==================================================
// STEADY STATE
// ==================================================
steady_state_model;

G = 0;
gYBar = Gss/4; 
gY_obs = gYBar;
y = 0;

ppi=0; 
ppi_obs =ppiss; 

tcr=0; 
tcr_obs= tcrss; 

UBar = Uss ; 
U_obs = UBar; 
u = 0; 
gUBar = 0; 

y_usa_obs = yss_usa;
y_usa = 0;

z=0;
r=rss;
e=0;
r_obs= r + e;


end;

steady;
check;


// ==================================================
// CALIBRATED SHOCK SCALES
// ==================================================
shocks;
var eps_YBar =1;
var eps_G =1;
var eps_y =1;
var eps_ppi =1;
var eps_tcr =1;
var eps_u =1;
var eps_UBar =1;
var eps_gUBar =1;
var eps_y_usa=1;
var eps_r=1;
var eps_z=1;
end;



// ==================================================
// DECLARATION OF OBSERVABLE VARIABLES
// ==================================================
varobs ppi_obs	gY_obs	tcr_obs	U_obs r_obs y_usa_obs;

// ==================================================
// PRIORS
// ==================================================
estimated_params;

// Related to GDP
THETA        ,  ,  ,  , beta_pdf, 0.7 , 0.15 ,  ,  ;
Gss          , , 0 ,10  , normal_pdf,4.2  ,2.1  ,   ,  ;
PHI          ,  ,  ,  , beta_pdf, 0.6 , 0.1 ,  ,  ;
SIG_eps_YBar ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;
SIG_eps_G    ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;
SIG_eps_y    ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;

// Related to inflation  
// BETTA is calibrated
LAMBDA       ,  ,  ,  , beta_pdf, 0.2 , 0.1 ,  ,  ;
KAPPA        ,  , 0,  , normal_pdf, 0.1  , 0.2 ,  ,  ;
GAMMA        ,  , 0,  , normal_pdf, 0.075 , 0.025 ,  ,  ;
SIG_eps_ppi  ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;
// ppiss is calibrated

// Related to TCR 
TAU_5       ,  , 0.6  ,  , beta_pdf, 0.6 , 0.15 ,  ,  ;
SIG_eps_tcr ,  , 0,  , normal_pdf, 3 , 2 ,  ,  ;
tcrss ,  , 0,  , normal_pdf, 450 , 50 ,  ,  ;

//Related to unemployment 
TAU_1         ,  , 0,  , normal_pdf, 0.2 , 0.3 ,  ,  ;
TAU_2         ,  ,  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
TAU_3         ,  ,  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
TAU_4         ,  ,  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
Uss           ,  ,  ,  , normal_pdf, 7.7 ,3.6  ,  ,   ; 
SIG_eps_u     ,  , 0,  , normal_pdf, 0.05 , 0.5 ,  ,  ; // ,  ,  ,  , inv_gamma_pdf, 0.01 , 0.2 ,  ,  ;//
SIG_eps_UBar  ,  , 0,  , normal_pdf, 0.05 , 0.5 ,  ,  ;
SIG_eps_gUBar ,  , 0,  , normal_pdf, 0.5 , 1 ,  ,  ;

// Related to output gap usa
TAU_6       ,  ,0  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
SIG_eps_y_usa       ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;

// Related to interest rate
PHI_2       ,  ,  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
SIG_eps_r       ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;
SIG_eps_z       ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;
ETA     ,  , ,  , normal_pdf, 0 , 3 ,  ,  ;
RHO     ,  ,  ,  , beta_pdf, 0.5 , 0.25 ,  ,  ;
rss     ,  , 0,  , normal_pdf, 0.5 , 2 ,  ,  ;

end;	

// Option to dock all graph produced by Dynare in the same window
set(0,'DefaultFigureWindowStyle' , 'docked')



///*
// ==================================================
// BAYESIAN ESTIMATION: Maximizing the Posterior, sample 2003.Q1-2019.Q2.
// ==================================================
estimation(datafile = Data_TP3_new, xls_sheet = Data_final, xls_range = B1:AA2000, first_obs = 1, nobs = 66, mode_compute = 5, plot_priors = 1, mode_check, mh_replic = 0, mh_nblocks = 0);
//*/


//
// ==================================================
// Reading previously estimated mode; computing smoother; ploting historical decomposition; computing moments and irf at the posterior model
// ==================================================
estimation(datafile = Data_TP3_new, xls_sheet = Data_final, xls_range = B1:AA2000, first_obs = 1, nobs = 66, mode_compute = 0, mode_file = TP3_ej4_mode, plot_priors = 0, mh_replic = 0,  mh_nblocks = 0, smoother, smoothed_state_uncertainty, nograph);

shock_decomposition(parameter_set=posterior_mode, nograph);

global initial_date_graph;
initial_date_graph='2003Q1';
plot_shock_decomposition(steadystate, type = qoq) ppi_obs gY_obs y r;

stoch_simul(periods = 0, irf = 20, order = 1, nograph); 

save TP3.mat oo_ M_ options_;
//


///*
// ==================================================
// BAYESIAN ESTIMATION: Running M-H. mh_jscale already tunned in
// ==================================================
estimation(datafile = Data_TP3_new, xls_sheet = Data_final, xls_range = B1:AA2000, first_obs = 1, nobs = 66, mode_compute = 0, mode_file = TP3_mode,  mh_replic = 500000, mh_nblocks = 1, mh_drop =0.4, mh_jscale = 0.32);

// ==================================================
// CHAINS & RECURSIVE MEANS
// ==================================================
model_name  = 'TP3';    // name of the mod-file
blocks_mh   = 1;        // blocks that you want to read (it can be a vector if you have more than one block)
nrows       = 3;        // number of rows per figure
ncols       = 3;        // number of columns per figure
plots_for_dynare_chains(model_name,blocks_mh,nrows,ncols,oo_);
//*/

/*
// 
// ==================================================
// Reading Previosly generated MH, Save Bayesian IRF
// ==================================================
estimation(datafile = Data_TP3_new, xls_sheet = Data_final, xls_range = B1:AA2000, first_obs = 1, nobs = 66, mode_compute = 0, mode_file = TP3_mode, plot_priors = 0, diffuse_filter, mh_replic = 0, mh_nblocks = 1, load_mh_file, load_results_after_load_mh, bayesian_irf, posterior_nograph);
stoch_simul(periods = 0, irf = 30, order = 1, nograph); 
save TP3_mhresults.mat oo_ M_ options_;

// 
*/
