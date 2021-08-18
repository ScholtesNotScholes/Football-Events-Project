
# Required Packages -------------------------------------------------------

# tidyverse

# Importing and Editing Data ----------------------------------------------------------

# Import data in README.md as csv, and label it as "events".

events = read.csv("C:/Users/schol/OneDrive/Documents/Summer 21 Project/Datasets/Football Events/events.csv") # Edit file location as necessary
  
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
# Far fewer games in the Premier League recorded. Bundesliga also has fewer events but this is because fewer
# games are played per season (18 teams compared to 20 teams).
events[events$league == "Premier League",][1,]
# The first Premier League event occurs after over 330,000 events in the dataset (which is chronologically ordered)
# meaning that recordings for Premier League games started later than for the other leagues.


# Edit 3: Change some numerical variables to factors.

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

write.csv(events, "events_new.csv")
