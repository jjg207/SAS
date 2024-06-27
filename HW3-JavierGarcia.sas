/*1(a) 
  Create a SAS data set named work.netflix by writing a DATA step 
  that only uses column input to read in and create all 
  the variables*/ 
data work.netflix;
	infile '/home/u63837117/netflix.txt';
	input Title $ 1-34 Genre $ 36-69 
	      Premiere $ 71-77 Finale $ 89-97 
	      Seasons 107;
run;
proc print data=netflix;
run;


/*1(c) 
  Create a report displaying the descriptor portion of the data set*/
proc contents data=netflix;
run;


/*1(d)
  Create a listing report that displays the data portion of the data set*/
ods listing file = '/home/u63837117/netflixhw(1d).lst';

/*Start the page numbers at 2. Display the date and time. 
  Set the line size to 130 and the page size to 90.*/
options pageno=2 date linesize=130 pagesize=90;

/*Display the total number of observations 
  at the bottom of the report.*/
proc print data=netflix 
	N='Total number of observations = ';
*Assign an appropriate title;      
title 'Netflix Content Report';
run;
ods listing close;


/*2(a) 
  Create another SAS data set named work.netflix2 by writing a DATA step 
  that only uses formatted input to read in and create all the variables. 
  Use pointer control AND appropriate informats*/
data work.netflix2;
	infile '/home/u63837117/netflix.txt';
	input @1   Title $33. 
	      @36  Genre $33.
	      @71  Premiere DATE7. 
	      @89  Finale DATE9.
	      @107 Seasons; 
run;
proc print data=netflix2;
run;


/*2(b) 
  Create a listing that displays the data portion of the data set*/
ods listing file = '/home/u63837117/netflixhw(2b).lst';

*Set the starting page number to 4, and set the line size to 150;
options pageno=4 linesize=150;
		
proc print data=netflix2;
	/*Display the values of Premiere in the form of 04/25/2024 
	  and the values of Finale in the form of 04/25/24*/
	format premiere mmddyy10.
           finale mmddyy8.;	
*Assign an appropriate title in bold green text, with a height of 6;      
title color=green bold height=6
	'Netflix Content Report';
run;
ods listing close;


/*3(a) 
  Modify the DATA step from exercise 2A) to assign 
  the following attributes to the 
  Premiere, Finale, Title, and Seasons variables*/
data work.netflix2;
	infile '/home/u63837117/netflix.txt';
	input @1   Title $33. 
	      @36  Genre $33.
	      @71  Premiere DATE7. 
	      @89  Finale DATE9.
	      @107 Seasons;
	/*i. Assign a format to the Premiere and Finale variables 
	     that displays the dates as mm/dd/yyyy*/
	format premiere mmddyy10. finale mmddyy10.; 
	/*ii. Assign the label ‘Title of Show’ to the Title variable
      iii. Assign the label ‘Date of Premiere’ to the Premiere variable
      iv. Assign the label ‘Date of Finale’ to the Finale variable
      v. Assign the label ‘Number of Seasons’ to the Seasons variable*/
	label title='Title of Show'
	      premiere='Date of Premiere'
	      finale='Date of Finale'
	      seasons='Number of Seasons';
run;
*vi. Run PROC CONTENTS to verify that the changes were made;
proc contents data=netflix2;
run;


/*3(b) 
 Use PROC DATASETS to change the following 
 attributes of the Finale and Title variables*/
proc datasets library=work;
	modify netflix2;
	/*i. Assign a format to the Finale variable 
	     that displays the dates as ddmmmyyyy*/
	format finale date9.;
	/*ii. Assign the label ‘Show Title’ to the Title variable
      iii. Assign the label ‘Finale Date’ to the Finale variable*/
	label title='Show Title'
	      finale='Finale Date';
run;
*iv. Run PROC CONTENTS to verify that the changes were made;
proc contents data=netflix2;
run;


/*4(a)
  Use the netflix2 data set from exercise 3. 
  Sort the data set by Seasons(largest to smallest), 
  Genre (alphabetically), and Title (alphabetically). 
  Output the sorted data set into the temporary data set, 
  netflix2_sorted*/
proc sort data=netflix2 out=work.netflix2_sorted;
	by descending Seasons Genre Title;
run;
proc print data=netflix2_sorted;
run;


/*4(b)
 Use the sorted data set to create a listing report that*/
ods listing file = '/home/u63837117/netflixhw(4b).lst';

/*ix. Displays page numbers; set the starting page number to be 6
   x. Displays the date and time
  xi. Set the line size to 98*/
options number pageno=6 date linesize=98;
		
/*viii. Display the total number of observations in each group*/
proc print data=netflix2_sorted label N='Total number of observations = ';
	/*iv. Only displays observations where the value of Premiere 
	      is between (inclusive) February 1st, 2015 and January 31st 2020. 
          Hint: mdy(4,25,2024) returns the SAS date value 
          corresponding to April 25th, 2024.*/
	where premiere between mdy(2,1,2015) and mdy(1,31,2020);
	/*v. Displays the variables: 
	     Genre, Title, and Finale (in this order)*/
	var genre title finale;
	/*vi. Displays the label ‘Number of Seasons’ for Seasons. 
	      Displays the column headers: 
	      ‘Genre’, ‘Show Title’, and ‘Finale Date’*/
	label seasons='Number of Seasons'
	      genre='Genre'
	      title='Show Title'
	      finale='Finale Date';
	/*vii. Groups the observations by Seasons, 
	       with different grouped values of Seasons 
	       on separate pages*/
	by descending seasons;
	pageby seasons;
	
/*i. Has the title ‘Netflix Original Shows’ on the first line
  ii. Has the title ‘- Sorted by Seasons, Genre, Title -’ on the second line
  iii. Has the footnote ‘Note: These shows have ended.’*/      
title1 'Netflix Original Shows';
title2 '- Sorted by Seasons, Genre, Title -';
footnote 'Note: These shows have ended';
run;
ods listing close;




























