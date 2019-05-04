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
trainData.bal <- ovun.sample(y~., data = trainData, p=0.5, seed=1, method="both")$data
table(trainData.bal$y)  #균형을 잡았기 때문에 비슷하게 되도록 설정
View(trainData.bal)
bank_ctree_bal <- ctree(y~., data=trainData.bal, control = ctree_control(maxdepth = 3)) #모델 생성
testPred_bal <- predict(bank_ctree_bal, newdata = testData)
table(testData$y, testPred_bal)


