libname hw '/home/u63837117/hw';

/* 1a) Use the MEANS procedure (with default options) 
   to create a report of summary statistics. */
proc means data=hw.airbnb;
run;

/* 1b) Does this represent all of 
       the variables in the data set? */
proc contents data=hw.airbnb;
run;

/* 1c) */
proc print data=hw.airbnb;
run;

/* 1d) Now run the MEANS procedure again, 
       but this time only analyze the variables:
       price, n_reviews, and host_listings
       
       Display the following statistics (with no decimal places):
       mean, min, median, and max*/
proc means data=hw.airbnb mean min median max maxdec=0;
	var price n_reviews host_listings;
run;

/* 1e) Sort the data set on the values of city and 
       save the sorted data set as Airbnb_sorted 
       in the work library. 
       
       Using the sorted data set, modify the code 
       from part D to display summaries for 
       the subgroups of city 
       
       In addition to displaying:
       the mean, min, median, and max, 
       also display the number of observations */
proc sort data=hw.airbnb out=airbnb_sorted;
	by city;
run;

proc means data=airbnb_sorted mean min median max maxdec=0 n;
	var price n_reviews host_listings;
	by city;
run;


/* 2a) Use the FREQ procedure (with default options) 
       to create a frequency report */
proc freq data=hw.airbnb;
run;

/* 2b)  Create a user-defined format that assigns the numeric 
        values of reviews_month to the corresponding categories:
		< 2 = ‘At most 2’
		2 - 4 = ‘Between 2 and 4’
		> 4 = ‘More than 4’ */
proc format;
	value rmfmt low-2='At most 2' 
	            2-4='Between 2 and 4' 
	            4-high='More than 4';
run;

proc freq data=hw.airbnb;
	format reviews_month rmfmt.;
run;

/* 2c)  Create a frequency report with only the following tables: 
        city and reviews_month 
        
        Use the formatted reviews_month categories, 
        as created in part B */
proc freq data=hw.airbnb;
	tables city reviews_month;
	format reviews_month rmfmt.;
run;

/* 2d) Create a two-way frequency table of city by the reviews_month categories 
       
       Only display the listings whose room_type is ‘Entire home/apt’ */
proc freq data=hw.airbnb;
	tables city * reviews_month;
	format reviews_month rmfmt.; 
	where room_type = 'Entire home/apt';
run;


/* 3a)  Look at the range of values for the variable min_nights */
proc tabulate data=hw.airbnb;
	class min_nights;
	table min_nights;
run;

/* Use a DATA step to create a data set named Airbnb_updated 
   from Airbnb where the negative values of min_nights and price 
   are set to be missing */
data airbnb_updated;
	set hw.airbnb;
	if min_nights < 0 then min_nights=.;
	if price < 0 then price=.;
run;

proc tabulate data=airbnb_updated;
	class min_nights;
	table min_nights;
run;

/* 3b) Use Airbnb_updated: In a single PROC step, 
       create a one-way table for min_nights with default statistics, 
       and a one-way table for city that displays the average price. */
proc tabulate data=airbnb_updated;
	class city;
	var min_nights price;
	table min_nights;
	table city*price=''*mean='average price';
run; 

/* 3c) Now create a two-way table for the city categories by 
       the min_nights categories */
proc tabulate data=airbnb_updated;
	class min_nights city;
	/* Add totals to both dimensions
       
       Add the labels ‘City’ and ‘Minimum Number of Nights’ 
       to the respective variables */
	table city='City' all, min_nights='Minimum Number of Nights' all;
run; 

/* 3f) Now modify your code from part D 
       so that the table displays the mean of price */
proc tabulate data=airbnb_updated;
	class min_nights city;
	var price;
	table city='City' all, min_nights='Minimum Number of Nights'*price=''*mean='Average Price' all;
run; 

/* 4a) Create a list report called airbnb_list.lst that displays variables: 
       city, reviews_month, and price (in this order) */
ods listing file='/home/u63837117/hw/airbnb_list.lst';
proc report data=airbnb_updated;
	column city reviews_month price;
	define reviews_month / format=rmfmt.;
run;
ods listing close;

/* 4b) Modify the code in part A to create a summary report 
       called airbnb_summary.lst that combines observations on 
       city and reviews_month, and displays the mean price */
ods listing file='/home/u63837117/hw/airbnb_summary.lst';
* i. Display the date and time, and set the starting page number to be 5;
options date pageno=5;
* ii. Add an appropriate title;
title 'Los Angeles Airbnb Performance Report';
*iii. Place a line below the column headers;
*iv. Skip a line below the column headers;
proc report data=airbnb_updated headline headskip;
	column city reviews_month price;
	/* v. Display the following column headers: 
	      ‘City’, ‘Reviews Per Month’, and 
	      ‘Average Daily Price’ */
	define city / group 'City';
	define reviews_month / group 'Reviews Per Month' format=rmfmt.; 
	* Format the price with dollar signs, commas, and two decimal places;
	define price / mean 'Average Daily Price' format=dollar10.2;
	/* vii. Add a subtotal (mean) after each City group
	        Add a double line above this subtotal */
	break after city / summarize dol;
	/* viii. Add a total (mean) at the end of the report
	         Add a single line above this total */
	rbreak after / summarize ol;
run;
ods listing close;
      
      
      
      

