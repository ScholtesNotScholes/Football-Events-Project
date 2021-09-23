# Football-Events-Project

Summer project taking a look at a popular football dataset found on Kaggle.com posted by Alin Secareanu (https://www.kaggle.com/secareanualin/football-events/data).

The dataset contains three files: events, ginf, and dictionary. The events file will be most important for my work since this gives a detailed breakdown of individual events occuring in football matches from the top divisions of England, Spain, Germany, Italy, and France between 2011-2017. Specifically, the data contains information about 9,074 games and yields 941,009 events in those games. The ginf file contains metadata and market odds for each game and the dictionary contains references for variables used in the events data which describe the nature of an event.

Before any analysis, I looked at how clean the data was and tried to make some improvements by adding a variable for the league of a match, to look at comparisons by league. Some exploratory analysis was then done to investigate some patterns in the variables. Finally, I attempted to build a fairly basic expected goals model using a logistic regression.
