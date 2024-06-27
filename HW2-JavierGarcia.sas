*Dowload the 'space' data set file and 
upload the file to the Files(Home) directory 
and use the SET statement to read in the file 
into the work (temporary) library from the 
Files(Home) folder;
data work.temp_space;
	set home.space;
run;

*A) Display the descriptor portion of the dataset 'space';
proc contents data = work.temp_space;
run;


*B) In one step: Create a user-defined format that assigns;
proc format;

	/*i.‘Active’ to the value ‘A’
      ii.‘Completed’ to the value ‘C’
      iii.‘Planned’ to the value ‘P’*/
	value $statusfmt A=Active
	                 C=Completed
	                 P=Planned;
	                 
	/*i.‘Less than 1 Billion’ to values <1,000,000,000
      ii.‘At least 1 Billion’ to values ≥ 1,000,000,000*/
	value costfmt low-999999999='Less than 1 Billion'
	              1000000000-high='At least 1 Billion';
	              
run;	                 

*Print the results of the user-define format;
proc print data = work.temp_space;
	format status $statusfmt. cost costfmt.;
run;


*C) Create a report using the space data set such that;

*i. Output to a listing report and an html report;
ods listing file = '/home/u63837117/spacehw.lst';

/*ii. Do not display page numbers, display the 
      date and time, and set the line size to 100*/
options nonumber nodate linesize=100;

		
proc format;
	/*vii. Apply the user-defined formats 
	       (created in part B) to the 
	       appropriate variables.*/
	value $statusfmt A=Active
	                 C=Completed
	                 P=Planned; 
	value costfmt low-999999999='Less than 1 Billion'
	              1000000000-high='At least 1 Billion';
run;

/*ix. Display the total number of observations 
      at the bottom of the report.*/
proc print data = work.temp_space label 
	N='Total number of observations = ';
	
	/*iii. Display the variables: Name, Type, Target, 
	       Status, Launch, and Cost (in this order).*/
	var name type target status launch cost;
	
	/*iv. Only display observations 
	      where the Status is ‘A’ or ‘P’.*/
	where status='A' or status='P';
	
	/*v. Assign the following column headers: 
	     ‘Mission Name’, ‘Mission Type’, 
	     ‘Target or Destination’, ‘Mission Status’, 
	     ‘Launch Date’, and ‘Estimated Cost’.*/
	label name='Mission Name'
	      type='Mission Type'
	      status='Mission Status'
	      target='Target or Destination'
	      launch='Launch Date'
	      cost='Estimated Cost';
	
	/*vi. Apply a format to the date values such that 
	      they display in the form of ‘18APR24’.*/
	format status $statusfmt. cost costfmt. launch date7.;
	
/*viii. Create an appropriate title for the report; 
        set the color to red, make it bold, 
        set the height to 7, 
        and align it to the left.*/
title color=red bold height=7 justify=left 
	'Space Missions Report';
run;

ods listing close;


