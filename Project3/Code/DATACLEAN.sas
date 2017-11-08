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


/*DESCRIPTIVE ANALYSIS: MEANS, MEDIAN, QUARTILES, FREQUENCIES*/
PROC MEANS DATA = P3.P3DATA;
VAR AGE AGEONSET ANIMALS BLOCKR MEMONE MEMTWO;
RUN;

PROC FREQ DATA = P3.P3DATA;
TABLES CDR DIAG SEX SOCIO;
RUN;
