/*Checking for violations in assumptions of linear regression*/
Title 'Plot of PDDIFF by PDBASE';
	PROC gplot DATA=dentalclean;
	PLOT pddiff*pdbase ;
	SYMBOL1 interpol=rl value=dot;
	RUN;

Title 'Plot of ATTACHDIFF by ATTACHBASE';
	PROC gplot DATA=dentalclean;
	PLOT attachdiff*attachbase ;
	SYMBOL1 interpol=rl value=dot;
	RUN;

/*Independent Associations for attachment loss difference against covariates*/
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

/*Independent Associations for pocket depth difference against covariates*/
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

/*Final model for PDDIFF*/
PROC REG DATA = DENTALCLEAN;
model pddiff = sex placebo low medium high pdbase;
run;

/*Final model for attachdiff*/
PROC REG DATA = DENTALCLEAN;
MODEL ATTACHDIFF = PLACEBO LOW MEDIUM HIGH ATTACHBASE;
RUN;
