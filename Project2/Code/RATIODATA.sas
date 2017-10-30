PROC IMPORT OUT= WORK.DATA 
            DATAFILE= "C:\Users\Kayla\Desktop\Book1.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
