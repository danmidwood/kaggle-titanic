# Following instructions in Trevor Stevens Getting Started with R series
#

#install.packages('rattle')
#install.packages('rpart.plot')
#install.packages('RColorBrewer')
library(rattle)
library(rpart.plot)
library(RColorBrewer)

#install.packages('randomForest')
library(randomForest)

#install.packages('party')
library(party)

train <- read.csv('train.csv')
test <- read.csv('test.csv')

test$Survived <- NA
combi <- rbind(train, test)
combi$Name <- as.character(combi$Name)

combi$Title <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
combi$Title <- sub(' ', '', combi$Title)

combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir', 'Jonkheer')] <- 'Sir'
combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess')] <- 'Lady'
combi$Title <- factor(combi$Title)
combi$FamilySize <- combi$SibSp + combi$Parch + 1
combi$Surname <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep="")
combi$FamilyID[combi$FamilySize <= 2] <- 'Small'

famIDs <- data.frame(table(combi$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
combi$FamilyID <- factor(combi$FamilyID)

Agefit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize, data=combi[!is.na(combi$Age),], method="anova")
combi$Age[is.na(combi$Age)] <- predict(Agefit, combi[is.na(combi$Age),])
combi$Embarked[which(combi$Embarked == '')] = "S"
combi$Embarked <- factor(combi$Embarked)
combi$Fare[which(is.na(combi$Fare))] <- median(combi$Fare, na.rm=TRUE)

combi$Deck <- substr(combi$Cabin, 0, 1)

combi$Deck[which(combi$Deck == 'A')] = 1
combi$Deck[which(combi$Deck == 'B')] = 2
combi$Deck[which(combi$Deck == 'C')] = 3
combi$Deck[which(combi$Deck == '')] = 3
combi$Deck[which(combi$Deck == 'D')] = 4
combi$Deck[which(combi$Deck == 'E')] = 5
combi$Deck[which(combi$Deck == 'F')] = 6
combi$Deck[which(combi$Deck == 'G')] = 7
combi$Deck[which(combi$Deck == 'T')] = 8
combi$Deck <- as.numeric(combi$Deck)

train <- combi[1:891,]
test <- combi[892:1309,]

set.seed(415)
fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID + Deck, data = train, controls=cforest_unbiased(ntree=2000, mtry=3))

Prediction <- predict(fit, test, OOB=TRUE, type = "response")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "guess.csv", row.names = FALSE)
