
# Required Packages -------------------------------------------------------

# tidyverse

# Objective ---------------------------------------------------------------

# I will attempt to create a model which returns the probability that a shot is a goal, given the characteristics
# of the shot. This will be done using a logistic regression model with the variable is_goal as the explained
# variable.

# To do so, the data will first be filtered to only include shots before being checked for errors. Then, a
# basic model will be estimated using only one variable. Thereafter, the model will be built up to include
# more variables and interactions to try to provide more accurate predictions for more specific situations.


# Data --------------------------------------------------------------------

# Note: The data used here has been cleaned and edited in a previous document (Preparing Data.R)
library(tidyverse)
events = read.csv("C:/Users/schol/OneDrive/Documents/Summer 21 Project/events_new.csv") #alter as necessary

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

shots = events[!(is.na(events$shot_place)),]
summary(shots)
# 7 observations have NA's for some of the variables, and are of event_type3, which doesn't correspond to a shot.

shots[shots$event_type == 3, "text"]
# event_type3 corresponds to fouls, and all the events in questions involved the player Dimitri Foulquier. Given that
# the data was produced by scraping text descriptions of events in games it is likely that these events were wrongly
# coded as fouls because the word "foul" is in Foulquier. These events will be coded correctly using the text
# descriptions of them.

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 3, situation to 1, and player to 
# youssef elarabi.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 3
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "youssef elarabi"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 3, situation to 1, and player to 
# jhon cordoba.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 3
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "jhon cordoba"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 11, situation to 1, and player to 
# dimitri foulquier.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 11
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "dimitri foulquier"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 15, situation to 1, and player to 
# manuel iturra.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 15
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "manuel iturra"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 3, situation to 1, and player to 
# dimitri foulquier.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 3
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "dimitri foulquier"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, shot_outcome to 2, location to 11, situation to 1, and player to dimitri foulquier.
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 11
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "dimitri foulquier"
shots[shots$event_type == 3,][1,"event_type"] = 1

shots[shots$event_type == 3,][1,]
# Change event_type to 1, event_type2 to 12, shot_outcome to 2, location to 16, situation to 1, and player to 
# ruben rochina.
shots[shots$event_type == 3,][1, "event_type2"] = 12
shots[shots$event_type == 3,][1,"shot_outcome"] = 2
shots[shots$event_type == 3,][1,"location"] = 16
shots[shots$event_type == 3,][1,"situation"] = 1
shots[shots$event_type == 3,][1,"player"] = "ruben rochina"
shots[shots$event_type == 3,][1,"event_type"] = 1

summary(shots)
# All events are now shots and there are no unexpected NA's.


# Model 1 -----------------------------------------------------------------

# The first, most basic model will be determining the probability of a shot being a goal given the placement
# of the shot, ie where the shot is placed in the goal. When using this variable, it only makes sense to
# include those shots which were on target since the probability of a shot being a goal if it is off target
# will be zero. A caveat to be mentioned is that there is no measure for the difficulty of a shot, meaning
# that the probability of a shot in the top corner is a goal might be high but there might also be a lower
# accuracy rate for shots in the top corner compared to the bottom corner, but this is not captured since
# only shots on target are considered.

logit.1 = glm(is_goal ~ shot_place, family = "binomial"(link = "logit"), 
              data = shots[shots$shot_place %in% c("3","4","5","12","13"),])
summary(logit.1)
logit.1.coef = as.data.frame(summary(logit.1)[12])

logit2prob = function(int,a) exp(int+a)/(1+exp(int+a))

logit.1.probs = c()
for (x in seq(1:nrow(logit.1.coef))){
  if (x == 1){
    logit.1.probs = c(logit.1.probs, round(logit2prob(logit.1.coef[1,1], 0), 2))
  }else{
    logit.1.prob = round(logit2prob(logit.1.coef[1,1], logit.1.coef[x,1]), 2)
    logit.1.probs = c(logit.1.probs, logit.1.prob)
  }
}

logit.1.labs = c("Bottom left corner", "Bottom right corner", "Centre of the goal", "Top left corner",
                          "Top right corner")

logit.1.tab = data.frame("Shot Place" = logit.1.labs, "Goal Probability" = logit.1.probs)
logit.1.tab[order(logit.1.tab$Goal.Probability, decreasing = T),]

# The table shows that it is better to place shots in the corners compared to the centre of the goal, which is to
# be expected since shots in the corners will be harder to save. There is not much difference between the corners
# but the bottom corners have a marginally higher probability of being goals compared to the top corners. It should
# be reiterated that this doesn't consider those shots that were aimed in the corners but missed.


# Model 2 -----------------------------------------------------------------

# Next, the location of the attempt will be used to predict the probability of a goal. Previous exploratory analysis
# of the variable location revealed that locations 1, 2, 4, and 5 do not correspond to events but instead to free
# kicks won. Moreover, location 19 (not recorded) will be excluded.

logit.2 = glm(is_goal ~ location, family = "binomial"(link = "logit"),
              data = shots[!(shots$location %in% c("1","2","4","5","19")),])
summary(logit.2)

logit.2.coef = as.data.frame(summary(logit.2)[12])

logit.2.probs = c()
for (x in seq(1:nrow(logit.2.coef))){
  if (x == 1){
    logit.2.probs = c(logit.2.probs, round(logit2prob(logit.2.coef[1,1], 0), 2))
  }else{
    logit.2.prob = round(logit2prob(logit.2.coef[1,1], logit.2.coef[x,1]), 2)
    logit.2.probs = c(logit.2.probs, logit.2.prob)
  }
}

logit.2.labs = c("Centre of the box", "Difficult angle and long range", "Difficult angle on the left",
                        "Difficult angle on the right", "Left side of the box", "Left side of the six yard box",
                        "Right side of the box", "Right side of the six yard box", "Very close range", "Penalty spot",
                        "Outside the box", "Long range", "More than 35 yards", "More than 40 yards")

logit.2.tab = data.frame("Location" = logit.2.labs, "Goal Probability" = logit.2.probs)
logit.2.tab[order(logit.2.tab$Goal.Probability, decreasing = T),]

# Penalties are obviously the most likely attempts on goal to result in a goal. Moreover, the estimated probability of
# 0.76 is roughly equivalent to other expected goals models (e.g. AWS used in the Bundesliga estimates goal probability
# of a penalty at 0.77), and equates to 76 out of 100 penalties resulting in goals on average. The next most effective 
# locations are in and around the six yard box with those from very close range having roughly a 50% chance of resulting 
# in goals on average. As would be expected, the further away from the goal an attempt gets the lower the probability of
# it resulting in a goal, with those outside of the box having a probability of 0.03 or lower.


# Model 3 -----------------------------------------------------------------

# The final model will include the variables location and bodypart, where bodypart and location will be interacted with 
# one another. The rationale is that the bodypart used, particularly whether a shot is taken using left or right foot 
# compared to using the head, certainly depends on the location of the shot. For example, it is very unlikely that a 
# player will try to score with his head from outside of the box but far more likely in the six yard box. For the latter,
# this interaction will hopefully capture the fact that headers are much more likely to be scored from crosses than other 
# assist methods.

logit.3 = glm(is_goal ~ location*bodypart, family = "binomial"(link = "logit"),
              data = shots[!(shots$location %in% c("1","2","4","5","19")),])
summary(logit.3)
# Some of the coefficients are not significant, meaning those variables or combinations do not help explain variations
# in goal probability. Some coefficients are also NAs, meaning there are no observations in the dataset which match
# those situations. The significant coefficients will be extracted by selecting those which are statistically different
# from zero with a probability (1 - p-value) greater than 0.9.

logit.3.coef = as.data.frame(summary(logit.3)[12])
logit.3.sigvars = logit.3.coef[logit.3.coef$coefficients.Pr...z.. < 0.1,]
logit.3.sigvars

logit.3.labs = c("Centre of the box (R)","Difficult angle and long range (R)","Difficult angle on the left (R)",
                 "Difficult angle on the right (R)","Left side of the box (R)","Right side of the box (R)",
                 "Right side of the six yard box (R)","Very close range (R)","Penalty spot (R)","Outside the box (R)",
                 "Long range (R)","More than 35 yards (R)","More than 40 yards (R)","Centre of the box (L)","Centre of the box (H)",
                 "Difficult angle on the left (L)","Left side of the six yard box (L)","Right side of the box (L)",
                 "Penalty spot (L)","Left side of the six yard box (H)")

logit2prob2 = function(int,a,b,ab) exp((int+a+b+ab)) / (1+exp(int+a+b+ab))

logit.3.probs = c(round(logit2prob(logit.3.coef["(Intercept)",1],0),2))
for (x in seq(2,15)){
  logit.3.prob = round(logit2prob(logit.3.coef["(Intercept)",1],logit.3.sigvars[x,1]),2)
  logit.3.probs = c(logit.3.probs, logit.3.prob)
}

for (x in seq(16,20)){
  logit.3.v1 = unlist(strsplit(rownames(logit.3.sigvars[x,]),":"))[1]
  logit.3.v2 = unlist(strsplit(rownames(logit.3.sigvars[x,]),":"))[2]
  
  logit.3.prob = round(logit2prob2(logit.3.coef["(Intercept)",1],
                                   logit.3.coef[logit.3.v1,1],
                                   logit.3.coef[logit.3.v2,1],
                                   logit.3.coef[x,1]),2)
  logit.3.probs = c(logit.3.probs, logit.3.prob)
}


logit.3.tab = data.frame("Situation" = logit.3.labs, "Goal Probability" = logit.3.probs)
logit.3.tab[order(logit.3.tab$Goal.Probability, decreasing = T),]
# The most likely shots to result in goals are obviously penalties, with left footed penalties having a larger
# probability than right footed penalties by  0.04, but the p-value of around 0.06 suggests there is a roughly
# 6% chance that the probabilities are actually equal to one another. Still, roughly 3/4 of penalties result in
# goals. Next, shots from very close range with the right foot have a goal probability of 0.57, meaning on average
# 57/100 of shots from this situation result in goals. The fact that shots from very close range with the left
# foot and head have very high p-values and reasonable standard errors suggests that this probability is roughly
# the same for these bodyparts from very close range. A similar argument applies to those situations which are not
# included in the table, such as right side of the six yard box with left foot and head. However, some of the
# situations which are exluded are due to inflated standard errors due to insufficient data. This applies to
# any situation outside of the box with the head, which very rarely happens and is incredibly unlikely to result
# in a goal.
