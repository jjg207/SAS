*1. Use the bestsellers.xlsx file posted on Canvas;

/*a) Write an IMPORT procedure to create a SAS data set 
     named bestsellers from the Excel file. Import the 
     worksheet named Pt1.*/
proc import datafile='/home/u63837117/bestsellers.xlsx'
		out=work.bestsellers
		dbms=xlsx replace;
	sheet='Pt1';
	getnames=yes;
run;

/*b) Create an html report displaying the 
     data portion of the bestsellers data set. 
     Add an appropriate title, bold, left-justified, 
     in blue text that has a height of 6.*/
proc print data=bestsellers 
	N='Total number of observations = '; 
	title bold justify=left color=blue height=6
		'Sales of Best Sellers';
run;

/*c) Create a listing report displaying the 
     descriptor portion of the bestsellers data set. 
     Display the date and time, but do not display 
     the page numbers. Set the line size to be 76.*/
ods listing file='/home/u63837117/bestsellers.lst';
	proc contents data=bestsellers;
	options date nonumber linesize=76;
run;
ods listing close;


/*2. Use the bestsellers data set created in Exercise 1.
     This data set contains information on the bestselling 
     books worldwide.*/
 
/*a) Create a temporary SAS data set named books that 
     reads in the bestsellers data set.*/ 
data work.books;
	set bestsellers;
	/*Then do the following in books:
	  i. Create a variable named Language 
	     that is assigned a value 
	     (i.e. French, Chinese, English, etc.) 
	     based on the value of the variable 
	     Original (FRE, CHI, ENG, etc.): 
	     French: FRE
	     Chinese: CHI
	     English: ENG
	     Spanish: SPA
	     Other: all other values*/
	IF index(original,'FRE') THEN DO;
		Language='French';
	END;
	ELSE IF index(original,'CHI') THEN DO;
		Language='Chinese';
	END;
	ELSE IF index(original,'ENG') THEN DO;
		Language='English';
	END;
	ELSE IF index(original,'SPA') THEN DO;
		Language='Spanish';
	END;
	ELSE DO;
		Language='Other';
	END;
	/*ii. The books dataset should only contain 
	      the variables Book, Author, Language, 
	      Year, SalesM, and Genre.*/
	drop original;
run;

/*b) Now create a report using the books data set: 
     i. Display the first 100 observations*/
proc print data=books (obs=100) label;
	*ii. Create an appropriate title;
	 title 'Best Selling Books';
	/*iii. Display the variables Title, Author, Language, 
	       Year, Genre, and SalesM (in this order)*/
	 var title author language year genre salesm;
	/*iv. Display the following column headers: 
	      ‘Original Language’ for Language, 
	      ‘Year Published’ for Year, and 
	      ‘Approximate Sales in Millions’ for SalesM*/
	label language='Original Language'
	      year='Year Published'
	      salesm='Approximate Sales in Millions';
run;

/*d) Modify the code from part A to fix this problem 
     (highlight the updated code in your pdf file). 
     Hint: use a format or length statement. 
     Rerun your updated code and your code in part B. 
     Check the output to see if the problem has been fixed*/
data work.books;
	set bestsellers;
	length Language $7;
	IF index(original,'FRE') THEN DO;
		Language='French';
	END;
	ELSE IF index(original,'CHI') THEN DO;
		Language='Chinese';
	END;
	ELSE IF index(original,'ENG') THEN DO;
		Language='English';
	END;
	ELSE IF index(original,'SPA') THEN DO;
		Language='Spanish';
	END;
	ELSE DO;
		Language='Other';
	END;
	drop original;
run;

proc print data=books (obs=100) label;
	title 'Best Selling Books';
	var title author language year genre salesm;
	label language='Original Language'
	      year='Year Published'
	      salesm='Approximate Sales in Millions';
run;

/*e) Use the updated books data set from part D.
     i. Create a SAS data set named books2 from 
	    the books data set that only reads in the 
	    variables Title, Author, Language, Year, 
	    and SalesM.*/
data work.books2;
	set books;
	drop genre;	
	/*ii. Create a variable named SalesLevel. 
	      Assign the SalesLevel values as follows: 
	      
	      ‘Under 25 million’ when SalesM < 25 
	      ‘25 to 50 million’ when 25 ≤ SalesM ≤ 50
	      ‘More than 50 million’ when SalesM > 50
	      
	      *Make sure that the values of SalesLevel 
	      are displayed correctly.*/
	length SalesLevel $20;
	IF salesm<25 THEN DO;
		SalesLevel=' Under 25 million';
	END;
	ELSE IF salesm>50 THEN DO;
		SalesLevel='More than 50 million';
	END;
	ELSE DO;
		SalesLevel='25 to 50 million';
	END;
	/*iii. Create a variable named Published that 
	       categorizes the year the book was published. 
	       Assign the Published values as follows:
	       
	       ‘2000-present’ when the Year is between 2000-2024
	       ‘1950-1999’ when the Year is between 1950-1999
	       ‘1900-1949’ when the Year is between 1900-1949
	       ‘1850-1899’ when the Year is between 1850-1899
	       ‘1800-1849’ when the Year is between 1800-1849
	       ‘1700-1799’ when the Year is between 1700-1799*/
	IF year>=2000 & year<=2024 THEN DO;
		Published='2000-present';
	END;
	ELSE IF year>=1950 & year<=1999 THEN DO;
		Published='1950-1999';
	END;
	ELSE IF year>=1900 & year<=1949 THEN DO;
		Published='1900-1949';
	END;
	ELSE IF year>=1850 & year<=1899 THEN DO;
		Published='1850-1899';
	END;
	ELSE IF year>=1800 & year<=1849 THEN DO;
		Published='1800-1849';
	END;
	ELSE IF year>=1700 & year<=1799 THEN DO;
		Published='1700-1799';
	END;
run;

/*f) Now create a report using the books2 data set:
  ii. Within each Published, display the sorted descending 
	  values of SalesLevel. Within each value of SalesLevel, 
	  display the values of Language sorted alphabetically. 
	  Within each value of Language, 
	  display the values of Title sorted alphabetically.*/ 
proc sort data=books2 out=temp_books2;
	by published descending saleslevel language title;
run;

/*vi.  Suppress the observation numbers column
  vii. Display the number of observations at the 
       bottom of each group*/
proc print data=temp_books2 
	noobs 
	N='Total number of observations = ' label;
	*i. Display an appropriate title;
	title 'Best Selling Books By Period Published';
	/*ii. Group the values by Published and place each 
	      value of Published on its separate page*/
	by published;
	pageby published; 
	*iii. Set the Published as an identification variable;
	id published;
	*iv. Only display SalesLevel, Language, Title, and Author;
	var SalesLevel Language Title Author;
	*v. Display ‘Sales in Millions’ as the column header for SalesLevel 
	    and ‘Original Language’ for Language.;
	label saleslevel='Sales in Millions'
	      language='Original Language';
run;




