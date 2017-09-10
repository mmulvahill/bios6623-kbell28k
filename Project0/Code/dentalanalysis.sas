PROC REG DATA=dentalclean;
	model attachdiff=age;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=attachbase;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=sex;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=smoker;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=race;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=treat;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model attachdiff=pdbase;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

Title 'Print regression predicts and CIs';
	PROC PRINT DATA=dentalclean;
	VAR age race treat pdbase attachbase smoker sex;
	FORMAT pred lcl ucl lclm uclm f5.3;
	RUN;

Title 'Plot of ATTACHDIFF by TREAT';
	PROC gplot DATA=dentalclean;
	PLOT attachdiff*treat ;
	SYMBOL1 interpol=rl value=dot;
	RUN;

Title 'Plot of ATTACHDIFF by ATTACHBASE';
	PROC gplot DATA=dentalclean;
	PLOT attachdiff*attachbase ;
	SYMBOL1 interpol=rl value=dot;
	RUN;

/*Models for PD*/
PROC REG DATA=dentalclean;
	model pddiff=pdbase;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=sex;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=smoker;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=age;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=treat;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=race;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;

PROC REG DATA=dentalclean;
	model pddiff=attachbase;
	OUTPUT out=output p=pred lcl=lcl ucl=ucl lclm=lclm uclm=uclm;
	RUN;
