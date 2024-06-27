libname hw '/home/u63837117/hw';

*** a);
* Create a report that displays the descriptor portion of the data set;
proc contents data=hw.employees;
run;

*** b) ;
* Create a vertical bar chart for the variable Years;
proc gchart data=hw.employees;
	* Do not treat Years as a continuous variable;
	vbar years / discrete;
run;

* Create a horizontal bar chart for the variable Salary;
proc gchart data=hw.employees;
	hbar salary;
run;

*** c);
data employees_valid;
	set hw.employees;
	* Modify the code in part B to only display valid values for Years;
	where years >= 0;
run;

proc gchart data=employees_valid;
	vbar years / discrete;
run;

*** d);
* Create a pie chart that displays the average Salary for the different Education levels;
proc gchart data=hw.employees;
	* i. Use a solid pattern;
	* ii. Emphasize the slice for ‘Bachelor’;
	pie education / sumvar=salary 
	type=mean
	fill=solid
	explode='Bachelor';
	* iii. Format the average salary with a dollar sign, comma, and two decimal places;
	format salary dollar10.2;
run;

*** e);
* Create a scatterplot of Salary by Years for employees with Master’s degrees;
proc gplot data=hw.employees;
	* ii. Define the scale of the vertical axis (label tick marks for every $5,000);
	* vi. Add a regression equation;
	plot salary * years / vaxis=60000 to 100000 by 5000
	                      regeqn;
	where education='Master';
	* i. Use green star symbols;
	* vii. Add a regression line;
	symbol1 c=green v=star i=rl;
	* iii. Display ‘Annual Salary vs. Years of Experience’ in the first title line;
	title1 'Annual Salary vs Years of Experience';
	* iv. Display ‘Employees with Master’s Degrees’ in the second title line;
	title2 "Employees with Master's Degrees";
	* v. Label the axes as 'Annual Salary' and 'Years of Experience';
	label years='Years of Experience'
	      salary='Annual Salary';
	* viii. Display the salaries with dollar signs, commas, and no decimal places;
	format salary dollar10.2;
run;
quit;

*** f);
* Use the employees data set to create two new data sets (e1, e2) each with a running total (SalaryRT) of the Salary;
data e1;
	set hw.employees;
	* i. In the e1 data set, use the sum() function;
	SalaryRT=sum(SalaryRT,Salary);
	retain;
run;
* Create a report using this data set, but only display the variables EmployeeID, Salary, and SalaryRT;
proc print data=e1;
	var employeeid salary salaryrt;
run;

* ii. In the e2 data set, use the sum statement;
data e2;
	set hw.employees;
	SalaryRT+Salary;
run;
* Create a report using this data set, but only display the variables EmployeeID, Salary, and SalaryRT;
proc print data=e2;
	var employeeid salary salaryrt;
run;

*** g);
* Use the employees data set to create a new data set (e3) with one accumulated totalsalary (TotalSalary) for each Branch;
proc sort data=hw.employees out=branch_sort;
	by branch;
run;

data e3;
	set branch_sort;
	by branch;
	if First.Branch then TotalSalary=0;
	TotalSalary+Salary;
	if Last.Branch;
	*  Only keep the variables Branch and TotalSalary;
	keep branch totalsalary;
run;

* Print out the data set;
proc print data=e3;
	* Display the total salaries with dollar signs, commas, and no decimal places;
	format totalsalary dollar15.2;
run;

* h);
* Create a data set, work.salary, which contains the salary projections for the next two years;
data salary;
	set hw.employees;
	* Los Angeles and Boston branches will receive a 5.1% annual salary increase;
	year=1;
	if branch='Los Angeles' | branch='Boston' then do;
		Salary_Proj=salary*1.051;
	end;
	* Miami and Seattle will receive a 4.9% annual salary increase;
	else do;
		Salary_Proj=salary*1.049;
	end;
	output;
	year=2;
	if branch='Los Angeles' | branch='Boston' then do;
		Salary_Proj=Salary_Proj*1.051;
	end;
	else do;
		Salary_Proj=Salary_Proj*1.049;
	end;
	output;
run;
* Create a report using work.salary;
proc print data=salary label;
	var employeeid branch salary year salary_proj;
	label employeeid='Employee ID'
	      branch='Branch'
	      salary='Current Salary'
	      year='Year'
	      salary_proj='Projected Salary';
	format salary dollar10.2 salary_proj dollar10.2;
run;

*** i); 
* Using ONE data step, separate the employees data set into three individual data sets, 
  each of which only contains observations for the corresponding value of MaritalStatus;
data single (drop=commutedistance maritalstatus yearssincepromotion) 
     married
     divorced (keep=employeeid branch years salary);
	set hw.employees;
	if maritalstatus='Single' then output single;
	if maritalstatus='Married' then output married;
	if maritalstatus='Divorced' then output divorced;
run;

*** j);
proc contents data=single;
run;
proc contents data=married;
run;
proc contents data=divorced;
run;
	


	