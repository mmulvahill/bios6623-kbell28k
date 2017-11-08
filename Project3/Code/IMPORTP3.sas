PROC IMPORT OUT= P3.P3DATA 
            DATAFILE= "C:\Users\Kayla\Desktop\PROJECT3\P3DATA.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
