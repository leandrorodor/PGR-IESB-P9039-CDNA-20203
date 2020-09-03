/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Thursday, September 3, 2020     TIME: 3:27:16 PM
PROJECT: Análise ENEM
PROJECT PATH: C:\Users\Leandro\Documents\P939\SAS_guide\Análise ENEM.egp
---------------------------------------- */

/* Library assignment for Local.ENEM */
Libname ENEM BASE 'C:\Users\Leandro\Documents\P939\bases\Dados\Dados_2019\ENEM 2017-2019' ;

/* Conditionally delete set of tables or views, if they exists          */
/* If the member does not exist, then no action is performed   */
%macro _eg_conditional_dropds /parmbuff;
	
   	%local num;
   	%local stepneeded;
   	%local stepstarted;
   	%local dsname;
	%local name;

   	%let num=1;
	/* flags to determine whether a PROC SQL step is needed */
	/* or even started yet                                  */
	%let stepneeded=0;
	%let stepstarted=0;
   	%let dsname= %qscan(&syspbuff,&num,',()');
	%do %while(&dsname ne);	
		%let name = %sysfunc(left(&dsname));
		%if %qsysfunc(exist(&name)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;

			%end;
				drop table &name;
		%end;

		%if %sysfunc(exist(&name,view)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;
			%end;
				drop view &name;
		%end;
		%let num=%eval(&num+1);
      	%let dsname=%qscan(&syspbuff,&num,',()');
	%end;
	%if &stepstarted %then %do;
		quit;
	%end;
%mend _eg_conditional_dropds;


/* save the current settings of XPIXELS and YPIXELS */
/* so that they can be restored later               */
%macro _sas_pushchartsize(new_xsize, new_ysize);
	%global _savedxpixels _savedypixels;
	options nonotes;
	proc sql noprint;
	select setting into :_savedxpixels
	from sashelp.vgopt
	where optname eq "XPIXELS";
	select setting into :_savedypixels
	from sashelp.vgopt
	where optname eq "YPIXELS";
	quit;
	options notes;
	GOPTIONS XPIXELS=&new_xsize YPIXELS=&new_ysize;
%mend _sas_pushchartsize;

/* restore the previous values for XPIXELS and YPIXELS */
%macro _sas_popchartsize;
	%if %symexist(_savedxpixels) %then %do;
		GOPTIONS XPIXELS=&_savedxpixels YPIXELS=&_savedypixels;
		%symdel _savedxpixels / nowarn;
		%symdel _savedypixels / nowarn;
	%end;
%mend _sas_popchartsize;


/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%local tempdsn unique_dsn path;

%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data set. */
	    /* Construct dsn that will be unique for each concurrent session under a particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		*/
		%if "%sysfunc(getoption(filetempdir))"="" %then %do;
			filename egtmpdir '/tmp';
		%end;
		%else %do;
			filename egtmpdir "%sysfunc(getoption(filetempdir))";
		%end;
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
    %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide


ODS PROCTITLE;
OPTIONS DEV=PNG;
GOPTIONS XPIXELS=0 YPIXELS=0;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=HtmlBlue
    STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/HtmlBlue.css")
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Assign Project Library (ENEM)   */
%LET _CLIENTTASKLABEL='Assign Project Library (ENEM)';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Leandro\Documents\P939\SAS_guide\Análise ENEM.egp';
%LET _CLIENTPROJECTPATHHOST='DESKTOP-MCDRRU1';
%LET _CLIENTPROJECTNAME='Análise ENEM.egp';

GOPTIONS ACCESSIBLE;
LIBNAME ENEM BASE "C:\Users\Leandro\Documents\P939\bases\Dados\Dados_2019\ENEM 2017-2019" ;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: One-Way Frequencies   */
%LET _CLIENTTASKLABEL='One-Way Frequencies';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Leandro\Documents\P939\SAS_guide\Análise ENEM.egp';
%LET _CLIENTPROJECTPATHHOST='DESKTOP-MCDRRU1';
%LET _CLIENTPROJECTNAME='Análise ENEM.egp';

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Thursday, September 3, 2020 at 3:27:05 PM
   By task: One-Way Frequencies

   Input Data: Local:ENEM.ENEM_2017_2019_MISSING
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORT);
/* -------------------------------------------------------------------
   Sort data set Local:ENEM.ENEM_2017_2019_MISSING
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORT AS
		SELECT T.NU_ANO, T.SG_UF_RESIDENCIA, T.NU_IDADE, T.TP_SEXO, T.TP_ESTADO_CIVIL, T.TP_COR_RACA, T.TP_DEPENDENCIA_ADM_ESC
	FROM ENEM.ENEM_2017_2019_MISSING as T
;
QUIT;

TITLE;
TITLE1 "*** Análise exploratória da base amostral dos ENEMs";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC FREQ DATA=WORK.SORT
	ORDER=INTERNAL
;
	TABLES NU_ANO /  SCORES=TABLE;
	TABLES SG_UF_RESIDENCIA /  SCORES=TABLE;
	TABLES NU_IDADE /  SCORES=TABLE;
	TABLES TP_SEXO /  SCORES=TABLE;
	TABLES TP_ESTADO_CIVIL /  SCORES=TABLE;
	TABLES TP_COR_RACA /  SCORES=TABLE;
	TABLES TP_DEPENDENCIA_ADM_ESC /  SCORES=TABLE;
RUN;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORT);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Summary Statistics   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Thursday, September 3, 2020 at 3:27:05 PM
   By task: Summary Statistics

   Input Data: Local:ENEM.ENEM_2017_2019_MISSING
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:ENEM.ENEM_2017_2019_MISSING
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.NU_IDADE, T.NU_NOTA_CN, T.NU_NOTA_CH, T.NU_NOTA_LC, T.NU_NOTA_MT, T.NU_NOTA_REDACAO, T.NOTA_MEDIA
	FROM ENEM.ENEM_2017_2019_MISSING as T
;
QUIT;
/* -------------------------------------------------------------------
   Run the Means Procedure
   ------------------------------------------------------------------- */
TITLE;
TITLE1 "Summary Statistics";
TITLE2 "Results";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC MEANS DATA=WORK.SORTTempTableSorted
	FW=12
	PRINTALLTYPES
	CHARTYPE
	QMETHOD=OS
	VARDEF=DF 	
		MEAN 
		STD 
		MIN 
		MAX 
		MODE 
		N 
		NMISS	
		Q1 
		MEDIAN 
		Q3 
		P90 
		P95 
		P99	;
	VAR NU_IDADE NU_NOTA_CN NU_NOTA_CH NU_NOTA_LC NU_NOTA_MT NU_NOTA_REDACAO NOTA_MEDIA;

RUN;
ODS GRAPHICS ON;
TITLE;
/*-----------------------------------------------------
 * Use PROC UNIVARIATE to generate the histograms.
 */

TITLE;
TITLE1 "Summary Statistics";
TITLE2 "Histograms";
PROC UNIVARIATE DATA=WORK.SORTTempTableSorted	NOPRINT	;
	VAR NU_IDADE NU_NOTA_CN NU_NOTA_CH NU_NOTA_LC NU_NOTA_MT NU_NOTA_REDACAO NOTA_MEDIA;

			HISTOGRAM ;

RUN; QUIT;
TITLE;
TITLE1 "Summary Statistics";
TITLE2 "Box and Whisker Plots";
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_IDADE;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_NOTA_CN;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_NOTA_CH;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_NOTA_LC;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_NOTA_MT;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NU_NOTA_REDACAO;
RUN;QUIT;
PROC SGPLOT DATA=WORK.SORTTempTableSorted	;
	VBOX NOTA_MEDIA;
RUN;QUIT;
ODS GRAPHICS OFF;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Correlations   */
%LET _CLIENTTASKLABEL='Correlations';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Leandro\Documents\P939\SAS_guide\Análise ENEM.egp';
%LET _CLIENTPROJECTPATHHOST='DESKTOP-MCDRRU1';
%LET _CLIENTPROJECTNAME='Análise ENEM.egp';

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Thursday, September 3, 2020 at 3:27:05 PM
   By task: Correlations

   Input Data: Local:ENEM.ENEM_2017_2019_MISSING
   Server:  Local
   ------------------------------------------------------------------- */
ODS GRAPHICS ON;

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:ENEM.ENEM_2017_2019_MISSING
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.NU_NOTA_MT, T.NU_NOTA_CN
	FROM ENEM.ENEM_2017_2019_MISSING as T
;
QUIT;
TITLE;
TITLE1 "Correlation Analysis";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC CORR DATA=WORK.SORTTempTableSorted
	PLOTS=(SCATTER MATRIX)
	PEARSON
	VARDEF=DF
	;
	VAR NU_NOTA_MT;
	WITH NU_NOTA_CN;
RUN;

/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;
ODS GRAPHICS OFF;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Distribution Analysis   */
%LET _CLIENTTASKLABEL='Distribution Analysis';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Leandro\Documents\P939\SAS_guide\Análise ENEM.egp';
%LET _CLIENTPROJECTPATHHOST='DESKTOP-MCDRRU1';
%LET _CLIENTPROJECTNAME='Análise ENEM.egp';

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Thursday, September 3, 2020 at 3:27:06 PM
   By task: Distribution Analysis

   Input Data: Local:ENEM.ENEM_2017_2019_MISSING
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:ENEM.ENEM_2017_2019_MISSING
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.NU_NOTA_MT
	FROM ENEM.ENEM_2017_2019_MISSING as T
;
QUIT;
TITLE;
TITLE1 "Distribution analysis of: NU_NOTA_MT";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
	ODS EXCLUDE EXTREMEOBS MODES MOMENTS QUANTILES;
	
	GOPTIONS htext=1 cells;
	SYMBOL v=SQUARE c=BLUE h=1 cells;
	PATTERN v=SOLID
	;
PROC UNIVARIATE DATA = WORK.SORTTempTableSorted
		CIBASIC(TYPE=TWOSIDED ALPHA=0.05)
		MU0=0
;
	VAR NU_NOTA_MT;
	HISTOGRAM   NU_NOTA_MT / NORMAL	( 	W=1 	L=1 	COLOR=YELLOW  MU=EST SIGMA=EST)
	
		CFRAME=GRAY CAXES=BLACK WAXIS=1  CBARLINE=BLACK CFILL=BLUE PFILL=SOLID ;
	;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
