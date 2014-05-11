# Following instructions in Trevor Stevens Getting Started with R series
#

train <- read.csv('train.csv')
test <- read.csv('test.csv')

#summary(train$Sex)
#prop.table(table(train$Sex,train$Survived),1)

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "guess.csv", row.names = FALSE)
