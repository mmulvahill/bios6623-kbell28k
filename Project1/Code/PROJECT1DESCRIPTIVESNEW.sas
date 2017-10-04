PROC MI DATA = WORK.HIVCLEAN;
RUN;

PROC MEANS DATA = WORK.HIVCLEAN;
VAR AGE BMINUM MENTALBASE PHYSICALBASE LEUBASE VLOADBASE
MENTALFINAL PHYSICALFINAL LEUFINAL VLOADFINAL DMENTAL DPHYSICAL DLEU DVLOAD;
RUN;

PROC FREQ DATA = WORK.HIVCLEAN;
TABLES NHW SALARY EDUC CURRENTSMOKE BASEALC BASEMJ HARD_DRUGS;
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
