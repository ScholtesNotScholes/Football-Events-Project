
# Required Packages -------------------------------------------------------

# tidyverse
# ggplot2


# Exploratory Analysis ----------------------------------------------------

events = read.csv("C:/Users/schol/OneDrive/Documents/Summer 21 Project/Datasets/Football Events/events_new.csv") # Edit file location as necessary

# Some variables should be converted to factors to make analysis easier. Namely, those variables which contain 
# numbers corresponding to a certain level of something, e.g. shot_outcome = 1 corresponds to "On target". 
# These variables are: event_type, event_type2, side, shot_place, shot_outcome, is_goal, location, bodypart, 
# assist_method, situation, and fast_break.
library(tidyverse)
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

summary(events)


# Time:

library(ggplot2)
ggplot(events) + geom_bar(aes(x = time), fill = "dark blue", width = 1) + 
  labs(x = "Minute", y = "Number of Events", title = "Number of Events in each Minute") +
  annotate("text", x = 45, y = 25000, label = "45'") +
  annotate("text", x = 90, y = 44000, label = "90'")
# There appears to be a slight upward trend from 0-90 with respect to the number of events occurring in each
# minute. Moreover, there are two spikes in the plot which correspond to the 45th and 90th minute. This is 
# likely because some events which happened during injury time, e.g. the 45+2 minute, may have been coded as
# the 45th minute, and the same for the 90th minute. The fact that the spike in the 90th minute is larger than
# that for the 45th minute is probably because there tends to be more time added on at the end of the second half 
# of a game than the first, mostly because of substitutions or injuries when players get tired.


# Event type:

event_type.labs = c("0" = "Announcement", "1" = "Attempt", "2" = "Corner", "3" = "Foul", "4" = "Yellow card",
                    "5" = "Second yellow card", "6" = "Red card", "7" = "Substitution", "8" = "Free kick won", 
                    "9" = "Offside", "10" = "Hand ball", "11" = "Penalty conceded")
events %>% add_count(event_type) %>% ggplot() +
  geom_bar(aes(y = reorder(event_type, n)), fill = "dark red") + 
  scale_y_discrete("Event Type", labels = event_type.labs) +
  labs(x = "Number of Events", title = "Number of Events by Type")
# The three most common events by a large margin are free kicks won, fouls, and attempts respectively, each
# with over 200,000 events. The next most common event is corners, with almost 100,000 events. The rest of
# the event types are around 50,000 occurrences or less, with the lowest event types being penalties conceded
# and sending offs (red card and second yellow card), with there being no second yellow cards in the data.
# Generally, this suggests that the best events to analyse would be fouls (including free kicks won) or attempts, 
# since these are the events for which there is the most data.

event_type2.labs = c("12" = "Key pass", "13" = "Failed through ball", "14" = "Sending off", "15" = "Own goal")
events[!(is.na(events$event_type2)),] %>% add_count(event_type2) %>% ggplot() +
  geom_bar(aes(y = reorder(event_type2, n)), fill = "dark blue") +
  scale_y_discrete("Event Type", labels = event_type2.labs) +
  labs(x = "Number of Events", title = "Number of Events by Type 2")
# Most of the observations for event_type2 are NA, because they are characterised by one of the events in the
# event_type category, therefore NAs have been excluded in this plot. The most common event in this category
# is key passes by a large margin, followed by a failed through ball.


# Event team:

events %>% add_count(event_team) %>% filter(n > 10000) %>% ggplot() +
  geom_bar(aes(y = reorder(event_team, n), fill = league)) +
  scale_fill_discrete("League") +
  labs(y = "Team", x = "Number of Events", title = "Number of Events per Team for Common Teams")
# The plot shows the number of events per team for teams with more than 10,000 events in the data.
# Interestingly, most of the top 10 teams are from the Serie A (Italy), even though they play the same number
# of games per season as Ligue 1 and La Liga. The Bundesliga teams only occur at the lower end of the plot,
# which is due to there being fewer games per season in the Bundesliga.

events %>% add_count(event_team) %>% filter(n > 10000) %>% ggplot() +
  geom_bar(aes(y = reorder(event_team, n), fill = event_type)) +
  scale_fill_discrete("Event Type", labels = event_type.labs) +
  labs(y = "Team", x = "Number of Events", title = "Number of Events per Team for Common Teams")
# The breakdown of events for common teams by type shows what was shown in the previous plot of event types:
# that the most common types are attempts, fouls, and free kicks won. Thereafter, there is some fluctuation
# with some teams having more corners and others having more offsides, as is expected with different teams
# using different strategies and tactics.


# Player:

events[!(is.na(events$player)) & !(is.na(events$event_type)),] %>% add_count(player) %>% filter (n > 1000) %>%
  ggplot() + geom_bar(aes(y = reorder(player, n), fill = event_type)) +
  scale_fill_discrete("Event Type", labels = event_type.labs) +
  labs(y = "Player", x = "Number of Events", title = "Number of Events per Player for Common Players")
# Common players are filtered as those who have more than 1,000 events. The most frequently occuring players
# are typically world class players who are forwards and therefore have a lot of attempts. However, there are some
# notable exceptions in the plot. Stefan Kiessling, a centre forward who played in the Bundesliga, is the fifth
# most frequent player in the data, but has far fewer attempts than the players above him. Kiessling's events
# were mostly winning free kicks and fouling other players, and also having attempts. Juanfran is another
# interesting exception, given he is a defender, but he clearly took the corners for his team for a long time
# with more corners than attempts.


# Shot place and bodypart:

shot_place.labs = c("1" = "Bit too high", "2" = "Blocked", "3" = "Bottom left corner", "4" = "Bottom right corner",
                    "5" = "Centre of the goal", "6" = "High and wide", "7" = "Hits the bar", 
                    "8" = "Misses to the left", "9" = "Misses to the right", "10" = "Too high", 
                    "11" = "Top centre of the goal", "12" = "Top left corner", "13" = "Top right corner")
bodypart.labs = c("1" = "Right foot", "2" = "Left foot", "3" = "Head")
events[!(is.na(events$shot_place)),] %>% add_count(shot_place) %>% ggplot() +
  geom_bar(aes(y = reorder(shot_place, n), fill = bodypart)) +
  scale_y_discrete("Shot Place", labels = shot_place.labs) +
  scale_fill_discrete("Bodypart", labels = bodypart.labs) +
  labs(x = "Number of Shots", title = "Shot placement and Bodypart Used")
# By far the most common shot placement is that the shot is blocked, so the placement cannot be identified. 
# Thereafter, shots usually miss to the left or right or go in the centre of the goal, then the bottom corners,
# and then shots which are too high and wide. For all of the shot placements, the most common bodypart is the
# right foot, typically followed by left foot and then header. This makes sense since it is most common for
# players to be right footed, and headers will not happen as common as shots with feet.


# Location:

location.labs = c("1" = "Attacking half", "2" = "Defensive half", "3" = "Centre of the box", "4" = "Left wing",
                  "5" = "Right wing", "6" = "Difficult angle and long range", "7" = "Difficult angle on the left",
                  "8" = "Difficult angle on the right", "9" = "Left side of the box", "10" = 
                    "Left side of the six yard box", "11" = "Right side of the box", "12" = 
                    "Right side of the six yard box", "13" = "Very close range", "14" = "Penalty spot",
                  "15" = "Outside of the box", "16" = "Long range", "17" = "More than 35 yards", "18" = 
                    "More than 40 yards", "19" = "Not recorded")
events[!(is.na(events$location)),] %>% add_count(location) %>% ggplot() +
  geom_bar(aes(y = reorder(location, n), fill = event_type)) +
  scale_y_discrete("Location", labels = location.labs) + 
  scale_fill_discrete("Event Type", labels = event_type.labs) +
  labs(x = "Number of Events", title = "Number of Events by Location on Pitch")
# Looking at the breakdown of locations by event type, we see that only two event types have a location 
# attached to them, which are attempts and free kicks won. Moreover, some of the location tags correspond
# to attempts and some to free kicks won but none to both. 
# For free kicks won, the most common location is defensive half, followed by attacking half, and then left 
# and right wing. It is unclear whether events on the left and right wing are in the attacking and defensive 
# half, or whether any events in either half are on the wings given a lack of information about the variables. 
# However, the combination of attacking half, left wing, and right wing would be close to the number of events
# in the defensive half, so the wings could be considered in the attacking half.
# For attempts, most of them occur outside of the box and then from the centre of the box. Then, there is a 
# large gap before right and left side of the box before the rest, which have a small number of events 
# relatively speaking.


# Assist method:

assist_method.labs = c("0" = "None", "1" = "Pass", "2" = "Cross", "3" = "Headed pass", "4" = "Through ball")
events[!(is.na(events$assist_method)),] %>% add_count(assist_method) %>% ggplot() +
  geom_bar(aes(y = reorder(assist_method, n), fill = is_goal)) +
  scale_y_discrete("Assist Method", labels = assist_method.labs) +
  scale_fill_discrete("Goal Scored", labels = c("No", "Yes"))
  labs(x = "Number of Events", title = "Assist Methods")
# The overwhelming majority of goals are categorized as without an assist, meaning the last player to touch
# the ball before the attempt was an opposition player or the attacker intercepted / tackled to gain possession
# before the attempt without passing. Moreover, it could be that some attempts which had assists were not coded
# and were simply assigned to none as opposed to the correct assist. There are some ambiguities with this variable
# caused by a lack of explanation for distinction between levels. For example, it is unclear what constitutes
# a pass compared to a cross or through ball. This ambiguity makes it difficult to perform analysis with the
# variable because interpretation will be difficult.
