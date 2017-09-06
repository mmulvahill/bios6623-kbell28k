proc contents data = work.dental;
run;


/*Converting attach1year and pd1year variables from character to numeric*/
data dental;
set work.dental;
attachyear1 = input(attach1year, best15.);
pdyear1 = input(pd1year, best15.);
/*Re-coding treatment group for clarification*/
IF trtgroup = 1 THEN treat = "PLACEBO";
IF trtgroup = 2 THEN treat = "CONTROL";
IF trtgroup = 3 THEN treat = "LOW";
IF trtgroup = 4 THEN treat = "MEDIUM";
IF trtgroup = 5 THEN treat = "HIGH";
/*Re-coding race for clarification*/
IF race = 1 THEN racer = "Native American";
IF race = 2 THEN racer = "African-American";
IF race = 4 THEN racer = "Asian";
IF race = 5 THEN racer = "White";
/*Creating a variable for % difference with pd and attach*/
pddiff = ((pdyear1-pdbase)/pdyear1)*100;
attachdiff = ((attachyear1-attachbase)/attachyear1)*100;
run;

/*Complete clean dental dataset*/
data dentalclean;
set dental;
keep id sex racer age smoker sites attachbase attachyear1
pdbase pdyear1 treat pddiff attachdiff;
run;

/*Identifying missing data*/
proc means data= dentalclean NMISS N;
run;

/*General descriptives: mean/min/max*/
proc means data= dentalclean;
VAR age sites attachbase attachyear1 pdbase pdyear1 pddiff attachdiff;
run;


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
