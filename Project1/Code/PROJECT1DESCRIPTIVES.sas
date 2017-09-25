/*Importing the data*/
PROC IMPORT OUT= WORK.hiv 
            DATAFILE= "C:\Users\Kayla\Desktop\hiv_6623_final.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC CONTENTS DATA = hiv;
RUN;

/*Correcting missing values, character to numeric variables, and cleaning the dataset*/
DATA WORK.HIV;
SET WORK.HIV;
ARRAY CHANGE _CHARACTER_;
            DO OVER change;
            IF change="NA" THEN change=.;
            END;
RUN;

DATA WORK.HIV;
SET WORK.HIV;
ADHNUM = INPUT(ADH, BEST12.);
BMINUM = INPUT(BMI, BEST12.); 
HASHVNUM = INPUT(HASHV, BEST12.);
LDLNUM = INPUT(LDL, BEST12.);
LEU3NUM = INPUT(LEU3N, BEST12.);
TCHOLNUM = INPUT(TCHOL, BEST12.);
TRIGNUM = INPUT(TRIG, BEST12.);
VLOADNUM = INPUT(VLOAD, BEST12.);
RUN;

DATA WORK.HIVNEW;
SET WORK.HIV;
DROP ADH BMI HASHV LDL LEU3N TCHOL TRIG VLOAD;
RUN;

PROC CONTENTS DATA = WORK.HIVNEW;
RUN;

DATA WORK.HIVDUMMYCODE;
SET WORK.HIVNEW;
IF YEARS = 0 THEN BASELINE = 1; ELSE BASELINE = 0;
IF YEARS = 1 THEN YEAR1 = 1; ELSE YEAR1 = 0;
IF YEARS = 2 THEN YEAR2 = 1; ELSE YEAR2 = 0;
IF YEARS = 3 THEN YEAR3 = 1; ELSE YEAR3 = 0;
IF YEARS = 4 THEN YEAR4 = 1; ELSE YEAR4 = 0;
RUN;

/*Descriptives for Table 1*/
PROC MEANS DATA = WORK.HIVNEW;
VAR AGE BMINUM CESD AGG_MENT AGG_PHYS TCHOLNUM TRIGNUM LDLNUM LEU3NUM VLOADNUM YEARS;
RUN;

PROC FREQ DATA = WORK.HIVNEW;
TABLES ADHNUM ART DIAB DKGRP DYSLIP EDUCBAS FP FRP INCOME HARD_DRUGS HIVPOS
SMOKE EVERART HASHF HASHVNUM HBP HEROPIATE IDU KID LIV34 YEARS;
RUN;

PROC FREQ DATA = WORK.HIVNEW;
TABLES HARD_DRUGS*YEARS;
RUN;


TITLE "CHANGE IN AGGREGATE MENTAL SCORE OVER TIME";
PROC SGPLOT DATA = WORK.HIVNEW;
   SERIES X = YEARS Y = AGG_MENT / GROUP = HARD_DRUGS GROUPLC=HARD_DRUGS BREAK 
        TRANSPARENCY=0.7 LINEATTRS=(PATTERN=SOLID)
        TIP=(HARD_DRUGS AGE);
   XAXIS DISPLAY=(nolabel);
   KEYLEGEND / type=linecolor TITLE="";
RUN;

/*Boxplots for Data*/
PROC SORT DATA = WORK.HIVNEW;
BY YEARS;
RUN;

TITLE 'Box Plot by Years';
PROC BOXPLOT DATA=WORK.HIVNEW;
PLOT AGG_MENT*YEARS;
RUN;

TITLE 'Box Plot by Years';
PROC BOXPLOT DATA=WORK.HIVNEW;
PLOT AGG_PHYS*YEARS;
RUN;

TITLE 'Box Plot by Years';
PROC BOXPLOT DATA=WORK.HIVNEW;
PLOT VLOADNUM*YEARS;
RUN;

TITLE 'Box Plot by Years';
PROC BOXPLOT DATA=WORK.HIVNEW;
PLOT LEU3NUM*YEARS;
RUN;

DATA HIVOUTLIERS;
SET WORK.HIVNEW;
IF YEARS = 0 OR VLOADNUM > 100 THEN DELETE;
RUN;


TITLE 'Box Plot by Years';
PROC BOXPLOT DATA=WORK.HIVOUTLIERS;
PLOT VLOADNUM*YEARS;
RUN;

/*Checking for violations in assumptions of linear regression*/
Title 'Plot of VLOAD vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT VLOADNUM*AGE;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

Title 'Plot of LEU3NUM vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT LEU3NUM*AGE ;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

Title 'Plot of TRIGNUM vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT TRIGNUM*YEARS ;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

Title 'Plot of TCHOLNUM vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT TCHOLNUM*AGE ;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

Title 'Plot of AGG_MENT vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT AGG_MENT*AGE ;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

Title 'Plot of AGG_PHYS vs. AGE';
	PROC GPLOT DATA=HIVNEW;
	PLOT AGG_PHYS*AGE ;
	SYMBOL1 INTERPOL=rl VALUE=dot;
	RUN;

/*Correlation matrix for dental variables*/
PROC TEMPLATE;
      EDIT Base.Corr.StackedMatrix;
         COLUMN (RowName RowLabel) (Matrix) * (Matrix2);
         EDIT matrix;
         CELLSTYLE _val_  = -1.00 as {backgroundcolor=CXEEEEEE},
                   _val_ <= -0.75 as {backgroundcolor=red},
                   _val_ <= -0.50 as {backgroundcolor=green},
                   _val_ <= -0.25 as {backgroundcolor=cyan},
                   _val_ <=  0.25 as {backgroundcolor=white},
                   _val_ <=  0.50 as {backgroundcolor=cyan},
                   _val_ <=  0.75 as {backgroundcolor=green},
                   _val_ <   1.00 as {backgroundcolor=red},
                   _val_  =  1.00 as {backgroundcolor=CXEEEEEE};
         END;
         END;
      RUN;
   
   ODS HTML BODY='corr.html' style=statistical;
   ODS LISTING CLOSE;
   PROC CORR DATA=WORK.HIVNEW NOPROB;
      ODS SELECT PearsonCorr;
   run;
   ODS LISTING;
   ODS HTML CLOSE;
   
   PROC TEMPLATE;
   DELETE Base.Corr.StackedMatrix;
   RUN;
