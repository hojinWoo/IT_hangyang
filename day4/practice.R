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

# List











