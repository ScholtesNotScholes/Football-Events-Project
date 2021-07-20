
# Required Packages -------------------------------------------------------

- tidyverse

# Importing and Editing Data ----------------------------------------------------------

# Import data in README.md as csv, and label it as "events".

summary(events)


# Edit 1: Change labels of id_odsp to id_match for readability.

library(tidyverse)
events = rename(events, id_match = id_odsp)


# Edit 2: Create a variable for the league of the match.

ger = c("Hamburg SV", "Borussia Dortmund", "FC Augsburg", "SC Freiburg", "Werder Bremen", "Kaiserslautern",
        "Hertha Berlin", "Nurnberg", "VfL Wolfsburg", "FC Cologne", "VfB Stuttgart", "Schalke 04", "Hannover 96",
        "TSG Hoffenheim", "Mainz", "Bayer Leverkusen", "Bayern Munich", "Borussia Monchengladbach", 
        "SpVgg Greuther Furth", "Fortuna Dusseldorf", "Eintracht Frankfurt", "TSV Eintracht Braunschweig", 
        "SC Paderborn", "SV Darmstadt 98", "FC Ingolstadt 04", "RB Leipzig")

fra = c("Lorient", "Paris Saint-Germain", "Valenciennes", "Caen", "Evian Thonon Gaillard", "Brest", "AC Ajaccio",
        "Toulouse", "Nice", "Lyon", "AS Nancy Lorraine", "Lille", "Montpellier", "AJ Auxerre", "Sochaux",
        "Marseille", "Bordeaux", "St Etienne", "Stade Rennes", "Dijon FCO", "Stade de Reims", "Troyes", "Bastia", 
        "AS Monaco", "Guingamp", "Nantes", "Metz", "Lens", "Angers", "GFC Ajaccio")

spa = c("Sporting Gijon", "Real Sociedad", "Valencia", "Racing Santander", "Real Madrid", "Real Zaragoza",
        "Sevilla", "Malaga", "Rayo Vallecano", "Athletic Bilbao", "Getafe", "Levante", "Osasuna", "Atletico Madrid",
        "Espanyol", "Mallorca", "Villarreal", "Barcelona", "Real Betis", "Granada", "Celta Vigo", 
        "Deportivo La Coruna", "Real Valladolid", "Almeria", "Elche", "Eibar", "Cordoba", "Las Palmas",
        "Alaves", "Leganes")

ita = c("AC Milan", "Lazio", "Cesena", "Napoli", "Internazionale", "Palermo", "Novara", "Chievo Verona", 
        "Juventus", "Parma", "Udinese", "Lecce", "Siena", "Catania", "AS Roma", "Cagliari", "Fiorentina",
        "Bologna", "Atalanta", "Genoa", "Torino", "Sampdoria", "US Pescara", "Hellas Verona", "Sassuolo",
        "Livorno", "Empoli", "Frosinone", "Carpi", "Crotone")

eng = c("Aston Villa", "Hull", "Fulham", "Stoke City", "Sunderland", "Manchester Utd", "Liverpool", 
        "Crystal Palace", "Everton", "Manchester City", "Newcastle", "Cardiff", "West Brom", "Arsenal", "West Ham",
        "Tottenham", "Chelsea", "Norwich City", "Swansea", "Southampton", "QPR", "Leicester City", "Burnley",
        "Bournemouth", "Watford", "Middlesbrough")

events$league = NA
events$league[events$event_team %in% ger] = "Bundesliga"
events$league[events$event_team %in% fra] = "Ligue 1"
events$league[events$event_team %in% spa] = "La Liga"
events$league[events$event_team %in% ita] = "Serie A"
events$league[events$event_team %in% eng] = "Premier League"
table(events$league, useNA = "ifany")


# Edit 3: Create a variable that gives the season in which the match occurred.

# To create this variable, I counted the number of matches that would occur in a season in each league and
# then used the variable id_match to label the first n number of unique match IDs as the first season, where
# n is the number of games in a season for a league. This method relies on every game being present for every
# season in the data because if there is one game missing in the first season then the first game of the next
# season will be the last game of the first season for every season.

# Bundesliga: 18 teams = 18*17 = 306 per season
events$season = ""
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[1:306]] = "11/12"
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[307:613]] = "12/13"
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[613:919]] = "13/14"
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[919:1215]] = "14/15"
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[1215:1521]] = "15/16"
events$season[events$id_match %in% unique(events[events$league == "Bundesliga",1])[1521:1608]] = "16/17"
# Note length(unique(events[events$league == "Bundesliga",1])) = 1608, used in the last line.

# Ligue 1: 20 teams = 20*19 = 380 per season
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[1:380]] = "11/12"
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[380:760]] = "12/13"
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[760:1140]] = "13/14"
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[1140:1520]] = "14/15"
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[1520:1900]] = "15/16"
events$season[events$id_match %in% unique(events[events$league == "Ligue 1",1])[1900:2076]] = "16/17"

# La Liga: 20 teams = 380 per season
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[1:380]] = "11/12"
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[380:760]] = "12/13"
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[760:1140]] = "13/14"
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[1140:1520]] = "14/15"
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[1520:1900]] = "15/16"
events$season[events$id_match %in% unique(events[events$league == "La Liga",1])[1900:2015]] = "16/17"

# Serie A: 20 teams = 380 per season
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[1:380]] = "11/12"
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[380:760]] = "12/13"
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[760:1140]] = "13/14"
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[1140:1520]] = "14/15"
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[1520:1900]] = "15/16"
events$season[events$id_match %in% unique(events[events$league == "Serie A",1])[1900:2076]] = "16/17"

# Premier League: 20 teams = 380 per season
length(unique(events[events$league == "Premier League",1]))
# The number of match IDs for the Premier League is much lower than the other leagues, meaning there is 
# likely a large amount of data missing for this league. Therefore, the Premier League will be removed
# from the analysis.


# Edit 4: Change some numerical variables to factors.

# Specifically, those variables which contain numbers corresponding to a certain level of something,
# e.g. shot_outcome = 1 corresponds to "On target". These variables are: event_type, event_type2, side,
# shot_place, shot_outcome, is_goal, location, bodypart, assist_method, situation, and fast_break.

events = events %>% mutate(
  event_type = as.factor(event_type),
  event_type2 = as.factor(event_type2),
  side = as.factor(side),
  shot_place = as.factor(shot_place),
  shot_outcome = as.factor(shot_outcome),
  is_goal = as.factor(is_goal),
  location = as.factor(location),
  bodypart = as.factor(bodypart),
  assist_method = as.factor(assist_method),
  situation = as.factor(situation),
  fast_break = as.factor(fast_break)
)


# Check for duplicated rows.

table(duplicated(events$id_event))
# No duplicated event IDs, so each row seems to be a unique event.

summary(events)
