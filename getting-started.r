# Following instructions in Trevor Stevens Getting Started with R series
#

train <- read.csv('train.csv')
test <- read.csv('test.csv')

#summary(train$Age)

train$Child <- 0
train$Child[train$Age < 18] <- 1

#table(train$Child)

#aggregate(Survived ~ Child + Sex, data=train, FUN=sum)
#aggregate(Survived ~ Child + Sex, data=train, FUN=length)
#aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)})


train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

#aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "guess.csv", row.names = FALSE)
