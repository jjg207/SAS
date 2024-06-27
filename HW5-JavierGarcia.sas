libname hw '/home/u63837117/hw';

/* a) Browse the descriptor portion 
      of each of the four data sets*/
proc contents data=hw.hoenn;
run;
proc contents data=hw.johto;
run;
proc contents data=hw.kanto;
run;
proc contents data=hw.sinnoh;
run;

/* b)Combine the four data sets into 
   a new data set in the work library 
   called Pokemon. If necessary, 
   rename variables such that the 
   variable names are as seen in 
   the Kanto data set. This output 
   data set should include a new 
   variable called Region, which contains 
   the region of each Pokémon 
   (i.e. ‘Hoenn’, ‘Johto’, ‘Kanto’, or ‘Sinnoh’)*/
data Pokemon;
	set hw.hoenn (IN=inhoenn 
	              rename=(hitpoints=HP))
	    hw.johto (IN=injohto 
	              rename=(t1=Type1) 
	              rename=(t2=Type2))
	    hw.kanto (IN=inkanto) 
	    hw.sinnoh (IN=insinnoh 
	               rename=(sp_attack=SpAttack) 
	               rename=(sp_defense=SpDefense));
	if inhoenn then do;
		Region='Hoenn';
	end;
	else if injohto then do;
		Region='Johto';
	end;
	else if inkanto then do;
		Region='Kanto';
	end;
	else do;
		Region='Sinnoh';
	end;
run;

/* c) Look at the values of the variable Region. 
      What do you notice about one of the values? 
      Rewrite the appropriate DATA step in part b) 
      to fix this issue and any others mentioned 
      in the warnings*/
data Pokemon;
	length Name $21. Region $6.;
	set hw.hoenn (IN=inhoenn 
	              rename=(hitpoints=HP))
	    hw.johto (IN=injohto 
	              rename=(t1=Type1) 
	              rename=(t2=Type2))
	    hw.kanto (IN=inkanto) 
	    hw.sinnoh (IN=insinnoh 
	               rename=(sp_attack=SpAttack) 
	               rename=(sp_defense=SpDefense));
	if inhoenn then do;
		region='Hoenn';
	end;
	else if injohto then do;
		region='Johto';
	end;
	else if inkanto then do;
		region='Kanto';
	end;
	else do;
		region='Sinnoh';
	end;
run;

* d) Create a report using your newly created data set;
proc print data=Pokemon n='Total Observations = ';
run;

/* e) Using Pokemon, create a new data set 
     called Pokemon_ordered that sorts the 
     values of Region in the following order: 
     Kanto, Johto, Hoenn, and Sinnoh 
     (Hint: Use a lookup table)*/
data regionlt;
length Region $6.;
input Region $ RegionValue;
datalines;
Hoenn 3   
Johto 2
Kanto 1
Sinnoh 4
;
run;

proc sort data=regionlt out=regionlt_temp;
	by region;
run;

data Pokemon_ordered;
	merge pokemon(in=a) regionlt_temp(in=b);
	by region;
	if a;
run;

proc sort data=Pokemon_ordered;
	by regionvalue;
run;

data Pokemon_ordered;
	set Pokemon_ordered;
	drop regionvalue;
run;

proc print data=Pokemon_ordered;
run;

* f) Create a listing report using Pokemon_ordered;
ods listing file='/home/u63837117/pokemon.lst';
/*Add an appropriate title, 
  display the date and time, 
  and set the starting page number to be 3*/
options date pageno=3;
proc print data=Pokemon_ordered 
	/*Suppress the observation numbers*/
	noobs 
	/*display the number of observations at the bottom*/
	n='Total Number of Observations = '
	label;
	/*Only display the variables: 
	  Name, Region, Type1, and Type2 
	  (in this order)*/
	var name region type1 type2;
	/*Display the column headers: 
	 ‘Pokemon Name’, ‘Region’, ‘Type 1’, and ‘Type 2’*/
	label name=Pokemon Name
	      region=Region
	      type1=Type1
	      type2=Type2;
run;
ods listing close;

/* h) Combine Pokemon_ordered with types, 
      into a new data set called Pokemon_final 
      to replace the abbreviated types seen 
      in both Type1 and Type2 with the corresponding 
      non-abbreviated types.*/
proc sort data=hw.types out=types;
	by Code;
run;

proc sort data=pokemon_ordered out=pt1;
	by Type1;
run;
data Pokemon_type1;
	length type1 $8.;
	merge pt1(in=a) types(in=b rename=(Code=Type1) rename=(Type=T1));
	by Type1;
	if a;
	drop type1;
run;


proc sort data=Pokemon_type1 out=pt2;
	by Type2;
run;
data Pokemon_type2;
	length type2 $8.;
	merge pt2(in=a) types(in=b rename=(Code=Type2) rename=(Type=T2));
	by Type2;
	if a;
	drop type2;
run;

/*The Pokemon_final data set should only contain: 
  1) the variables seen in Pokemon_ordered 
  2) Pokémon that are not Legendary (i.e. Legendary=0)
  Sort the values of Name in reverse alphabetical order*/
proc sort data=pokemon_type2 out=pokemon_prefinal;
	by descending name;
run;
data Pokemon_final;
	set pokemon_prefinal (rename=(t1=Type1) rename=(t2=Type2));
	where Legendary=0;
	by descending name;
run;

* i) Use Pokemon_final to create an html report;
proc print data=pokemon_final
	/*Suppress observation numbers*/
	noobs
	/*Display the total number of observations 
	  at the bottom of the report*/
	n='Total number of observations = ';
	/*Displays the variables: Name, Region, 
	  Type1, Type2, HP, and Speed (in this order)*/
	var name region type1 type2 hp speed;
	/*On the first title line, display 
	 ‘Non-Legendary Pokemon’ in green size 7 font*/
	title1 color=green height=7 'Non-Legendary Pokemon';
	/*Then on the second title line, display 
	 ‘Generations 1-4’ in blue size 5 font*/
	title2 color=blue height=5 'Generations 1-4';
	/*Display the column headers ‘Pokemon Name’, 
	 ‘Region’, ‘Type 1’, ‘Type 2’, ‘Hit Points’, 
	  and ‘Speed’*/
	label name=Pokemon Name
	      region='Region'
	      type1='Type 1'
	      type2='Type 2'
	      hp='Hit Points'
	      speed='Speed';
run;
	
	











