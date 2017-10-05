/*Looking at patterns for missing data in the final dataset*/
PROC MI DATA = WORK.HIVCLEAN;
RUN;

/*Descriptive statistics for overall, and groups means (continuous variables)*/
PROC MEANS DATA = WORK.HIVCLEAN;
VAR AGE BMINUM MENTALBASE PHYSICALBASE LEUBASE VLOADBASE
MENTALFINAL PHYSICALFINAL LEUFINAL VLOADFINAL DMENTAL DPHYSICAL DLEU DVLOAD;
RUN;

PROC MEANS DATA = WORK.HIVCLEAN;
VAR AGE BMINUM MENTALBASE PHYSICALBASE LEUBASE VLOADBASE
MENTALFINAL PHYSICALFINAL LEUFINAL VLOADFINAL DMENTAL DPHYSICAL DLEU DVLOAD;
CLASS HARD_DRUGS;
RUN;

/*Descriptive statistics for overall categorical variables*/
PROC FREQ DATA = WORK.HIVCLEAN;
TABLES NHW SALARY EDUC CURRENTSMOKE BASEALC BASEMJUSE HARD_DRUGS;
RUN;

PROC FREQ DATA = WORK.HIVCLEAN;
TABLE BASEMJUSE*HARD_DRUGS / MISSPRINT;
RUN;

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
   PROC CORR DATA=WORK.HIVCLEAN NOPROB;
      ODS SELECT PearsonCorr;
   run;
   ODS LISTING;
   ODS HTML CLOSE;
   
   PROC TEMPLATE;
   DELETE Base.Corr.StackedMatrix;
   RUN;
