# Remind :  bank-full.csv
#  - by UCI Machine Learning Repository
#  - 포르투칼 은행 정기 프로모션을 통해 상환 여부 응답 여부
#  - target value : y
#Data 분할 >> 균형화 >> 모형 >> 평가
#install.packages("party")
library(party)
bank = read.csv("data/bank-full.csv", header = T, sep = ";", quote = "\""); #quote > 따옴표를 구분(default)
str(bank) #  - 17개 필드, 45211 레코드
#plot(bank$y)
#table(bank$y)
set.seed(1234)  #Decision Tree 만들기(모형)
ind <- sample(2, nrow(bank), replace = T, prob = c(0.7, 0.3)) #복원추출
trainData <- bank[ind == 1, ]
testData <- bank[ind == 2, ]
bank_ctree <- ctree(y~., data=trainData, control = ctree_control(maxdepth = 3))
testPred <- predict(bank_ctree, newdata = testData)
table(testData$y, testPred) #sensitivity(민감도) = Recall(재현율 : 550/1556)
                            #Precision(positive 중 맞힌 개수 550/856)
plot(bank_ctree, type = "simple")

## 분류 모형의 평가 ##
# Accurancy
# Error Rate
# Sensitivity or Recall
# Specificity
# Precision
#install.packages("caret") >
library(caret)
confusionMatrix(testPred, testData$y, positive ="yes",mode="prec_recall")

## 균형화
#install.packages("ROSE")
library(ROSE)
nrow(trainData)
table(trainData$y)
# Over-sampling, under-sampling, combination of over- and under-sampling.
result <- ovun.sample(y~., data = trainData, p=0.5, seed=1, method="both")
class(result) #ovun.sample
str(result)
class(result$data)  #data.frame
str(result$data)
trainData_bal <- ovun.sample(y~., data = trainData, p=0.5, seed=1, method="both")$data
table(trainData_bal$y)  #균형을 잡았기 때문에 비슷하게 되도록 설정
View(trainData_bal)
bank_ctree_bal <- ctree(y~., data=trainData_bal, control = ctree_control(maxdepth = 3)) #모델 생성
testPred_bal <- predict(bank_ctree_bal, newdata = testData)
table(testData$y, testPred_bal)
confusionMatrix(testPred, testData$y, positive ="yes",mode="prec_recall")
confusionMatrix(testPred_bal, testData$y, positive ="yes",mode="prec_recall")
#성능 체크

## 통신데이터
rm(list = ls())
churn_train <- read.csv("data/churnTrain.csv")
churn_test <- read.csv("data/churnTest.csv")
str(churn_train)
# View(churn_train)
str(churn_test)
bank_ctree <- ctree(churn~., data=churn_train, control = ctree_control(maxdepth = 3))
testPred <- predict(bank_ctree, newdata = churn_test)
table(churn_test$churn, testPred)
traindata_bal <- ovun.sample(churn~., data = churn_train, p=0.5, seed=1, method="both")$data
bank_ctree_bal <- ctree(churn~., data=traindata_bal, control = ctree_control(maxdepth = 3))
testPred_bal <- predict(bank_ctree_bal, newdata = churn_test)
table(churn_test$churn, testPred_bal)
confusionMatrix(testPred, churn_test$churn, positive ="yes",mode="prec_recall")
confusionMatrix(testPred_bal, churn_test$churn, positive ="yes",mode="prec_recall")


## R로 그리는 인공신경망 기본 실습
rm(list = ls())
set.seed(1234)
ind <- sample(2, nrow(iris), replace = T, prob = c(0.7, 0.3))
trainData <- iris[ind==1, ]
testData <- iris[ind==2, ]
install.packages("nnet")
library(nnet) #single neural network
model.nnet <- nnet(Species~., data=trainData, size = 2, decay = 5e-04)
summary(model.nnet)
testPred <- predict(model.nnet, testData, type="class")
table(testPred, testData$Species)


## 실습
rm(list = ls())
bank = read.csv("data/bank-full.csv", header = T, sep = ";", quote = "\"");
set.seed(1234)
ind <- sample(2, nrow(bank), replace = T, prob = c(0.7, 0.3))
trainData  <- bank[ind == 1, ]
testData <- bank[ind == 2, ]
bank_nnet <- nnet(y~., data = trainData, size = 4, decay=5e-4)
testPred <- predict(bank_nnet, testData, type="class")
table(testPred, testData$y)
trainData_bal <- ovun.sample(y~., data = trainData, p=0.5, seed=1, method="both")$data
bank_nnet_bal <- nnet(y~., data = trainData_bal, size = 4, decay=5e-4)
testPred_bal <- predict(bank_nnet_bal, testData, type="class")
table(testPred_bal, testData$y)
#str(factor(testPred))
#as.factor(testPred)
str(testData$y)
bank_ctree <- ctree(y~., data=trainData, control = ctree_control(maxdepth = 3))
DTtestPred <- predict(bank_ctree, newdata = testData)
bank_ctree_bal <- ctree(y~., data=trainData_bal, control = ctree_control(maxdepth = 3))
DTtestPred_bal <- predict(bank_ctree_bal, newdata = testData)
confusionMatrix(as.factor(testPred), testData$y, positive ="yes",mode="prec_recall")
confusionMatrix(DTtestPred, testData$y, positive ="yes",mode="prec_recall")
confusionMatrix(as.factor(testPred_bal), testData$y, positive ="yes",mode="prec_recall")
confusionMatrix(DTtestPred_bal, testData$y, positive ="yes",mode="prec_recall")



