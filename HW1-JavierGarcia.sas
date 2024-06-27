/* 1. Create a folder called homework in your home folder in SAS Studio. 
Now create a library called hw that points to the homework folder */
libname hw '/home/u63837117/homework';


/* 2. Use the talent data set located in the data1 library. Create a single report that:

a) Only displays the following variables (in this order): 
   FirstName, LastName, Address2, Height, and Rate.

b) Displays the following column headers: 
   ‘First Name’, ‘Last Name’, ‘Location’, ‘Height (in)’, and ‘Daily Rate’.

c) Only displays people whose Address2 is not ‘CANTON, NJ’ and whose Rate is less than 2700.

d) Displays the number of observations at the bottom of the report */
libname data1 '/home/u63837117/data1';
proc print data = data1.talent N = 'Number of Observations = ' label;
	var FirstName LastName Address2 Height Rate;
	where Address2 <> 'CANTON, NJ' & Rate < 2700;
	label	FirstName = 'First Name'
			LastName = 'Last Name'
			Address2 = 'Location'
			Height = 'Height (in)'
			Rate = 'Daily Rate';
run;


/* 3. Create a data set called paintings in the hw library that contains the following 
variables: title, first, last, year, price_paid. The data is as follows: */
data hw.paintings;
input title $ first $ last $ year price_paid;
datalines;
SalvatorMundi Leonardo daVinci 1500 450000000
Interchange Willem deKooning 1955 300000000
TheCardPlayers Paul Cezanne 1895 250000000
NafeaFaaIpoipo Paul Gauguin 1892 210000000
Number17A Jackson Pollock 1948 200000000
No6 Mark Rothko 1951 186000000
;
run;


/* Create a report using your newly created data set. Suppress the observation column
and display ‘Title of Painting’, ‘Artist First Name’, ‘Artist Last Name’, ‘Year Completed’,
and ‘Most Recent Price Paid’ as the column headers. Display the total of price_paid
at the bottom of the report. What do you notice about many of the values of title? */
PROC print noobs label;
		label	title = 'Title of Painting'
				first = 'Artist First Name'
				last = 'Artist Last Name'
				year = 'Year Completed'
				price_paid = 'Most Recent Price Paid';
		sum price_paid;
run;

/* According to the Output Data window, character variables 
have a length of 8 thus a maximum of 8-character values (or 8 bytes) 
are displayed in the Results window for each data entry in the 
Title of Painting, Artist First Name, and Artist Last Name columns, 
which are character variables. */