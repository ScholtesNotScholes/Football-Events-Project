<b>Note:</b> The data which this project is based on was not directly imported in the code. Instead, to use the code download the data from the link in the README file for this project and import it as "events" as follows:
events = read.csv("-directory to data/events.csv")
 
----
  
<b>Summary of tasks performed in Preparing Data R code:</b>

1. Rename match ID variable to make it more intuitive.

2. Create a variable giving the league that the match of each event took place in.

3. Recode appropriate variables as factors to make further analysis easier to perform.

4. Checked for duplicated event IDs corresponding to an error inputting data (none were found).
