/**************************************************************************
******HEADER***************************************************************
******DATE: 8 NOVEMBER 2017************************************************
******SAS EDITION 9.4******************************************************
******PURPOSE: THIS PROGRAM CONTAINS THE DATA CLEAN PORTION FOR PROJECT 3**
******AS WELL AS THE DECRIPTIVE ANALYSIS***********************************
******OWNER: KAYLA BELL****************************************************/


/*IMPORTING THE DATA*/
PROC IMPORT OUT= WORK.P3DATA 
            DATAFILE= "C:\Users\Kayla\Desktop\Project3DATA.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/*REVIEWING THE CONTENTS OF THE DATA*/
PROC CONTENTS DATA = WORK.P3DATA;
RUN;

/*PLOTS FOR ANY UNUSUAL DATA*/
PROC UNIVARIATE DATA = WORK.P3DATA PLOTS;
VAR AGE AGEONSET ANIMALS BLOCKR MEM1 MEM2;
RUN;

PROC SGPLOT DATA = WORK.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=MEM1 / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = WORK.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=CDR / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = WORK.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=MEM2 / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = WORK.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=BLOCKR / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC GPLOT DATA = WORK.P3DATA;
PLOT MEM1*AGE = ID;
RUN;

PROC GPLOT DATA = WORK.P3DATA;
PLOT MEM2*AGE = ID;
RUN;

PROC GPLOT DATA = WORK.P3DATA;
PLOT BLOCKR*AGE = ID;
RUN;

PROC GPLOT DATA = WORK.P3DATA;
PLOT ANIMALS*AGE = ID;
RUN;

/*CREATING VARIABLES*/
DATA WORK.P3ANALYSIS;
SET WORK.P3DATA;
AGENEW = AGE - 67;
AGEONSETNEW = AGEONSET -67;
CHANGEANL = MAX(0,(AGE - (AGEONSET - 4)));
RUN;

/*DELETING IDS WITH LESS THAN THREE OBS PER OUTCOME*/
PROC SQL;
CREATE TABLE OBS AS
SELECT*,
       COUNT(ANIMALS) AS COUNT
FROM WORK.P3ANALYSIS
GROUP BY ID
ORDER BY ID
;
QUIT;

DATA WORK.P3CLEAN;
SET WORK.OBS;
IF COUNT < 3 THEN DELETE;
RUN;

/*DESCRIPTIVE ANALYSIS: MEANS, MEDIAN, QUARTILES, FREQUENCIES*/
/*PLOT FOR ANIMALS OUTCOME*/
PROC SORT DATA = WORK.P3CLEAN;
BY DEMIND;
RUN;
PROC SGPLOT DATA = WORK.P3CLEAN;
TITLE 'PATIENT SCORES FOR CATEGORY FLUENCY FOR ANIMALS';
SERIES X = AGE Y = ANIMALS / GROUP = ID GROUPLC = DEMIND NAME = 'DIAGNOSIS GROUP';
KEYLEGEND 'DIAGNOSIS GROUP' / TYPE = LINECOLOR;
BY DEMIND;
RUN;

/*AT BASELINE*/
DATA WORK.P3BASE;
SET WORK.P3CLEAN;
BY ID;
IF FIRST.ID THEN OUTPUT WORK.P3BASE;
RUN;

PROC MEANS DATA = WORK.P3BASE;
VAR AGE AGEONSET ANIMALS BLOCKR MEM1 MEM2 SOCI0;
CLASS DEMIND;
RUN;

PROC FREQ DATA = WORK.P3BASE;
TABLES SEX*DEMIND / CHISQ;
RUN;

/*AT LAST OBS*/
DATA WORK.P3LAST;
SET WORK.P3CLEAN;
BY ID;
IF LAST.ID THEN OUTPUT WORK.P3LAST;
RUN;

PROC MEANS DATA = WORK.P3LAST;
VAR AGE AGEONSET ANIMALS BLOCKR MEM1 MEM2 SOCI0;
CLASS DEMIND;
RUN;

PROC FREQ DATA = WORK.P3LAST;
TABLES SEX*DEMIND / CHISQ;
RUN;

/*CORRELATION MATRIX FOR VARIABLE RELATIONSHIPS*/
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
   PROC CORR DATA=WORK.KEEPOBS NOPROB;
      ODS SELECT PearsonCorr;
   run;
   ODS LISTING;
   ODS HTML CLOSE;
   
   PROC TEMPLATE;
   DELETE Base.Corr.StackedMatrix;
   RUN;

