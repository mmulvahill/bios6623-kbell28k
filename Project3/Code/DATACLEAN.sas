/**************************************************************************
******HEADER***************************************************************
******DATE: 8 NOVEMBER 2017************************************************
******SAS EDITION 9.4******************************************************
******PURPOSE: THIS PROGRAM CONTAINS THE DATA CLEAN PORTION FOR PROJECT 3**
******AS WELL AS THE DECRIPTIVE ANALYSIS***********************************
******OWNER: KAYLA BELL****************************************************/


/*IMPORTING THE DATA*/
PROC IMPORT OUT= P3.P3DATA 
            DATAFILE= "C:\Users\Kayla\Desktop\PROJECT3\P3DATA.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/*REVIEWING THE CONTENTS OF THE DATA*/
PROC CONTENTS DATA = P3.P3DATA;
RUN;

/*PLOTS FOR ANY UNUSUAL DATA*/
PROC UNIVARIATE DATA = P3.P3DATA PLOTS;
VAR AGE AGEONSET ANIMALS BLOCKR MEMONE MEMTWO;
RUN;

PROC SGPLOT DATA = P3.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=MEMONE / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = P3.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=CDR / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = P3.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=MEMTWO / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC SGPLOT DATA = P3.P3DATA;
   TITLE 'STUDY RESULTS BY PATIENT';
   SERIES X=AGE Y=BLOCKR / GROUP=ID NAME='GROUPING';
   KEYLEGEND 'GROUPING' / TYPE=LINECOLOR;
RUN;

PROC GPLOT DATA = P3.P3DATA;
PLOT MEMONE*AGE = ID;
RUN;

PROC GPLOT DATA = P3.P3DATA;
PLOT MEMTWO*AGE = ID;
RUN;

PROC GPLOT DATA = P3.P3DATA;
PLOT BLOCKR*AGE = ID;
RUN;

PROC GPLOT DATA = P3.P3DATA;
PLOT ANIMALS*AGE = ID;
RUN;

/*DESCRIPTIVE ANALYSIS: MEANS, MEDIAN, QUARTILES, FREQUENCIES*/
PROC MEANS DATA = P3.P3DATA;
VAR AGE AGEONSET ANIMALS BLOCKR MEMONE MEMTWO;
RUN;

PROC FREQ DATA = P3.P3DATA;
TABLES CDR DIAG SEX SOCIO;
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
   PROC CORR DATA=P3.P3DATA NOPROB;
      ODS SELECT PearsonCorr;
   run;
   ODS LISTING;
   ODS HTML CLOSE;
   
   PROC TEMPLATE;
   DELETE Base.Corr.StackedMatrix;
   RUN;
