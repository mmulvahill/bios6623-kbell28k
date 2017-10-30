PROC CONTENTS DATA = PROJECT2.RAWDATA;
RUN;

DATA PROJECT2.RECENTPERIOD;
SET PROJECT2.RAWDATA;
IF SIXMONTH < 39 THEN DELETE;
RUN;


PROC FREQ DATA = PROJECT2.RECENTPERIOD;
TABLES HOSPCODE PROCED ASA DEATH30;
RUN;

PROC MEANS DATA = PROJECT2.RECENTPERIOD MEAN STDDEV MEDIAN Q1 Q3;
VAR WEIGHT HEIGHT BMI ALBUMIN;
RUN;

DATA PROJECT2.PAST;
SET PROJECT2.RAWDATA;
IF SIXMONTH >= 39 THEN DELETE;
RUN;

PROC FREQ DATA = PROJECT2.PAST;
TABLES PROCED ASA DEATH30;
RUN;

PROC MEANS DATA = PROJECT2.PAST MEAN STDDEV MEDIAN Q1 Q3;
VAR WEIGHT HEIGHT BMI ALBUMIN;
RUN;

DATA PROJECT2.CLEAN;
SET PROJECT2.RAWDATA;
IF SIXMONTH = 39 THEN RECENT = 1; ELSE RECENT = 0;
IF SIXMONTH < 39 THEN PAST = 1; ELSE PAST = 0;
BMICALC = ((WEIGHT/HEIGHT)**2)*703;
IF PROCED = 2 THEN DELETE;
IF BMI < 0 THEN DELETE;
IF ASA =< 3 THEN LEVEL = 0;
IF ASA > 3 THEN LEVEL = 1;
RUN;

PROC SORT DATA = PROJECT2.CLEAN;
BY HOSPCODE;
RUN;

PROC BOXPLOT DATA = PROJECT2.CLEAN;
PLOT (ASA BMICALC WEIGHT HEIGHT BMI ALBUMIN)*HOSPCODE;
RUN;


