# 출력
print("hello world")
# Sequence
seq(1, 100)
1:100
# 도움말
?seq
help(print)
# 패키지 다운 및 사용
install.packages("randomForest", dep=T)
library(randomForest)


##### R 기초 #####
# 2.2 R의 주요 데이터 타입
# 변수 벡터  팩터  리스트  행렬  배열  데이터프레임

# 변수값 할당
a = 1
b <- 2
d <- c(1, 3, 5)
d[1]
mean(d) #x의 역할을 하게 됨
mean(e <- c(2, 4, 6))
mean(f = c(2, 4, 6))#"="는 함수 안에서는 인자에 대응하는 것 따라서 "="는 사용 불가
mean(x = c(2, 4, 6))
?mean
mean(x = d)

#함수 호출 시 인자 지정
seq(1, 10)
seq(from = 1, to = 10)
seq(10) #same as 1:10
seq(1, 10, by = 2)
seq(1, 10, 2)

# 숫자(정수, 부동소수 등)
a <- 3
b <- 4.5
c <- a + b
d <- 2e-10 #2*10^-10
print(d)
e <- 3e2  #3*10^2
print(e)

# NA (Not Available, 결측값, 데이터 값이 없음)
is.na()

# NULL(Undefined, 변수가 초기화 되지 않음.)
is.null()

# String(데이터 타입 따로 없음)

# Boolean

# Vector(동일한 데이터형을 가지는 원소들의 배열, 중첩 불가능)
x <- c(1, 2, 3, 4,5)
y <- c("1", "2", "3")
c(1, 2, 3, c(4, 5, 6))  #1 2 3 4 5 6
                        # 벡터 안에 벡터를 생성하면 단일 차원의 벡터로 변경됨
# 벡터 데이터 접근(색인 사용, 이름 사용, 특정 요소를 제외한 나머지 가져오기, 여러 셀 접근)
length(x)
x[1]  #index
x[3]
x[-1] #특정 원소만 제외
x[-3]
x[c(1,3)]
x[1:3]  #start:end
names(y) <- c("Kim", "Lee", "Park")
y["Lee"]
y[c("Kim", "Park")]

# Factor(범주형 데이터 표현) 명목형(nominal)과 순서형(ordinal)로 구분
gender <- factor("m", c("m", "f"))
gender
nlevels(gender)
levels(gender)
levels(gender)[1]
levels(gender)[2]
# 순서형 팩터 생성
ordered("a", c("a", "b", "c"))
factor("a", c("a", "b", "c"), ordered = T)

# List(키, 값 형태의 데이터를 담은 연관배열 / 서로 다른 데이터 타입을 담을 수 있음) // 파이썬의 dictionary와 같다
x <- list(name = "foo", height = 70)
x
x <- list(name = "foo", height = c(1, 3, 5)) #값이 스칼라일 필요 없음
x$name  #$뒤에는 key가 들어오면 된다
x[n]    #리스트에서 n번째 데이터의 서브리스트
x[[n]]  #리스트에서 n번째 저장된 값

# Array (모든 원소는 한가지 유형의 스칼라만 가능)
matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)
matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), ncol = 3)
matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3, byrow = T)
x <- matrix(1:9, ncol=3)
x[1, 1]
x[2, 1]
x[1:2, ]
x[-3, ]
x[c(1, 3), c(1, 3)] #색인에서 벡터 사용

# Dataframe
d <- data.frame(x = 1:5, 
                y=seq(2,10,2))
(d <- data.frame(x = 1:5, 
                 y=seq(2,10,2), 
                 z = c('M', 'F', 'M', 'F', 'M')))
# str() 함수
str(d)
d$x <- 6:10 #값 바꾸기기
d <- data.frame(x = 1:5, 
                y=seq(2,10,2))

d[c(1, 3), 2]
d[-1, -2]
d[, c("x", "y")]
d[, c("x")]

## 2.3 의사결정나무(iris data)
?iris #꽃받침, 꽃길이
      #
class(iris) #"data.frame"
str(iris)
dim(iris)
names(iris)
attributes(iris)
iris[1:5, ]
head(iris)
tail(iris)
iris[1:10, "Sepal.Length"]
iris$Sepal.Length[1:10]

summary(iris)
quantile(iris$Sepal.Length)
table(iris$Species)
pie(table(iris$Species))
hist(iris$Sepal.Length)
plot(density(iris$Sepal.Length))

#훈련용 데이터와 테스트 데이터로 분할
set.seed(1234)
ind <- sample(2, nrow(iris), replace = T, prob = c(0.7, 0.3)) #7:3으로 랜덤 샘플링링
ind
trainData <- iris[ind == 1, ]
testData <- iris[ind == 2, ]
nrow(trainData)
nrow(testData)

#의사결정나무 생성
install.packages("party")
library(party)
myFormula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
iris_ctree <- ctree(myFormula, data=trainData)
testPred <- predict(iris_ctree, newdata = testData)
table(testData$Species, testPred)

print(iris_ctree)
plot(iris_ctree)
plot(iris_ctree, type="simple")

# 실습1 : DAAG패키지 설치 + spam7 데이터에 대해 의사결정나무 수행 // target = yesno
install.packages("DAAG")
library(DAAG)
str(spam7)
set.seed(5678)
ind_P <- sample(2, nrow(spam7), replace = T, prob = c(0.7, 0.3))
trainData_P <- spam7[ind_P == 1, ] 
testData_P <- spam7[ind_P == 2, ] 
spam7_ctree <- ctree(yesno ~ crl.tot + dollar + bang + money + n000 + make, data = trainData_P)
testPred_P <- predict(spam7_ctree, newdata = testData_P)
table(testData_P$yesno, testPred_P)
plot(spam7_ctree, type="simple")

# 실습2 : bank-full.csv
bank = read.csv("data/bank-full.csv", header = T, sep = ";", quote = "\"");
str(bank)
set.seed(1234)
ind <- sample(2, nrow(bank), replace = T, prob = c(0.7, 0.3))
trainData <- bank[ind == 1, ]
testData <- bank[ind == 2, ]
bank_ctree <- ctree(y~., data=trainData, control = ctree_control(maxdepth = 3))
testPred <- predict(bank_ctree, newdata = testData)
table(testData$y, testPred)
plot(bank_ctree, type = "simple")

# Accurancy
# Error Rate
# Sensitivity or Recall
# Specificity
# Precision
