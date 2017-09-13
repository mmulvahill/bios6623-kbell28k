PROC IMPORT OUT= WORK.dental 
            DATAFILE= "C:\Users\Kayla\Desktop\dental.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc contents data = work.dental;
run;


/*Converting attach1year and pd1year variables from character to numeric*/
data dental;
set work.dental;
attachyear1 = input(attach1year, best15.);
pdyear1 = input(pd1year, best15.);
/*Re-coding treatment group for clarification*/
IF trtgroup = 1 THEN treat = 2;
IF trtgroup = 2 THEN treat = 1;
IF trtgroup = 3 THEN treat = 3;
IF trtgroup = 4 THEN treat = 4;
IF trtgroup = 5 THEN treat = 5;
IF TRTGROUP = 1 THEN PLACEBO = 1; ELSE PLACEBO = 0;
IF TRTGROUP = 2 THEN CONTROL = 1; ELSE CONTROL = 0;
IF TRTGROUP = 3 THEN LOW = 1; ELSE LOW = 0;
IF TRGROUP = 4 THEN MEDIUM = 1; ELSE MEDIUM = 0;
IF TRTGROUP = 5 THEN HIGH = 1; ELSE HIGH = 0;

/*Re-coding race for clarification*/
IF race = 1 THEN racer = "Native American";
IF race = 2 THEN racer = "African-American";
IF race = 4 THEN racer = "Asian";
IF race = 5 THEN racer = "White";
/*Creating a variable for % difference with pd and attach*/
pddiff = ((pdyear1-pdbase)/pdyear1);
attachdiff = ((attachyear1-attachbase)/attachyear1);
run;

/*Complete clean dental dataset*/
data dentalclean;
set dental;
keep id race sex racer age smoker sites attachbase attachyear1
pdbase pdyear1 treat pddiff attachdiff;
run;

/*Identifying missing data*/
proc means data= dentalclean NMISS N;
run;

/*General descriptives: mean/min/max*/
proc means data= dentalclean;
VAR age sites attachbase attachyear1 pdbase pdyear1 pddiff attachdiff;
run;

PROC FREQ DATA = DENTALCLEAN;
TABLES SEX RACE TRTGROUP;
RUN;

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
/*Correlation matrix for dental variables*/
proc template;
      edit Base.Corr.StackedMatrix;
         column (RowName RowLabel) (Matrix) * (Matrix2);
         edit matrix;
            cellstyle _val_  = -1.00 as {backgroundcolor=CXEEEEEE},
                      _val_ <= -0.75 as {backgroundcolor=red},
                      _val_ <= -0.50 as {backgroundcolor=green},
                      _val_ <= -0.25 as {backgroundcolor=cyan},
                      _val_ <=  0.25 as {backgroundcolor=white},
                      _val_ <=  0.50 as {backgroundcolor=cyan},
                      _val_ <=  0.75 as {backgroundcolor=green},
                      _val_ <   1.00 as {backgroundcolor=red},
                      _val_  =  1.00 as {backgroundcolor=CXEEEEEE};
            end;
         end;
      run;
   
   ods html body='corr.html' style=statistical;
   ods listing close;
   proc corr data=dentalclean noprob;
      ods select PearsonCorr;
   run;
   ods listing;
   ods html close;
   
   proc template;
      delete Base.Corr.StackedMatrix;
   run;

