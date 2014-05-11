# Following instructions in Trevor Stevens Getting Started with R series
#

#install.packages('rattle')
#install.packages('rpart.plot')
#install.packages('RColorBrewer')
library(rattle)
library(rpart.plot)
library(RColorBrewer)

train <- read.csv('train.csv')
test <- read.csv('test.csv')

library(rpart)

fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train,
             method="class", control=rpart.control(minsplit=5, cp=0))

new.fit <- snip.rpart(fit, toss = 33)
new.fit <- snip.rpart(new.fit, toss = 129)
new.fit <- snip.rpart(new.fit, toss = 156)
new.fit <- snip.rpart(new.fit, toss = 106)

fancyRpartPlot(new.fit)

Prediction <- predict(new.fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "guess.csv", row.names = FALSE)
