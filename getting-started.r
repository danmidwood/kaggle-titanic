# Following instructions in Trevor Stevens Getting Started with R series
#
# http://trevorstephens.com/post/72918760617/titanic-getting-started-with-r-part-1-booting-up-r
#

train <- read.csv('train.csv')
test <- read.csv('test.csv')

test$Survived <- rep(0,nrow(test))

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "guess.csv", row.names = FALSE)
