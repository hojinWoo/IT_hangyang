This lecture note is prepared for the lecture of *Kyoughoon Bae* and *Jiyeol Oh*. 

------

# 1. Data Import

#### CSV로 바꾸기

- excel file을 csv 형식으로 바꾸는 것이 일반적인 프로그래밍에서 data import를 하는데에 편리
- 해당 과정은 excel에서 저장할 때 저장 옵션을 csv로 설정하면 가능

#### Data Import

```{r}
rm(list=ls())
mydat = read.csv("corporate_finance_demo.csv", head=T, stringsAsFactors = F)
mydat = mydat[complete.cases(mydat),]
```

#### Data Import Check

- data import를 체크

```{r}
head(mydat)
str(mydat)
summary(mydat)
```

- int, chr, num 형식으로 모두 잘 들어온 것을 확인



# 2. Distribution

### 1. 예제 코드

#### 히스토그램, 분포도 그리기

- 각 회사의 ROA의 히스토그램(ROA : 은행 총자산이익률)
- 가시성을 위해 3 미만을 제거
- 표의 이름을 변경

```{r}
hist(mydat$LEVERAGE[mydat$LEVERAGE<3], main="총자산 히스토그램")
plot(density(mydat$LEVERAGE[mydat$LEVERAGE<3]), main="총 자산 분포도")
```

### 2. 실습

- 배당율(변수명 DIVPAY)이 0.5 미만인 회사들을 찾아 그 회사들의 히스토그램과 분포도를 그리세요
- 각각의 명칭을 원하는 대로 지정하세요

```{r, echo=T}
hist(mydat$DIVPAY[mydat$DIVPAY<0.5], main="예제1", xlab="배당율", ylab="빈도수")
plot(density(mydat$DIVPAY[mydat$DIVPAY<0.5]), main="예제2", xlab="배당율", ylab="빈도수")
```

# 3. 단순 선형회귀분석

### 1. 예제 코드

#### 변수변형

- 총 자산(AT)에 로그를 씌워보세요.

```{r}
mydat$logAT = log(mydat$AT)
summary(mydat[,c("AT","logAT")])
```

#### 선형회귀분석

- ROA에 로그총자산(logAT)과 판매량이 얼마나 영향을 주는지 선형회귀분석 시행
- 모델을 평가해보세요.

```{r}
res = lm(ROA ~ logAT + SALE, data = mydat)	
summary(res)
```

#### 더미변수를 활용한 선형회귀분석

- ROA에 로그총자산(logAT)이 얼마나 영향을 주는지 선형회귀분석 시행
- 단 이번에는 STATE를 더미변수로 만들어, 지역별 영향력을 컨트롤

```{r}
res = lm(ROA ~ logAT + SALE + factor(STATE), data = mydat)
summary(res)
```

#### 예측

- 총 자산규모가 1억 달러, 판매량이 천만 달러인 회사의 ROA를 자산규모, 판매량 변수로 95% 신뢰수준과 함께 예측

```{r}
res = lm(ROA ~ logAT + SALE, data = mydat)
newvar = data.frame(logAT = log(100), SALE=10)
predict(res, newdata=newvar, interval="confidence", level=0.95)
```



### 2. 실습

목적: 회사의 기업가치(MKTCAP)를 예측하는 모형을 만들고 싶습니다.

- 기업가치에는 판매량(SALE), 총자산(logAT), ROA, TObin's Q,(TOBINSQ), R\&D 비율 (RNDRATIO), 현금비율(CASHRATIO), 부채비율(LEVERAGE) 이 영향을 줄 것으로 예상합니다.
- 모델을 구성하고, SALE=100, AT=660, ROA=0.01, TOBINSQ=3.3, RNDRATIO=0.07, CASHRATIO=0.08, LEVERAGE=0.2인 기업의 기업가치를 99% 신뢰수준에서 추정하세요

```{r, echo=T}
res = lm(MKTCAP ~ SALE+logAT+ROA+TOBINSQ+RNDRATIO+CASHRATIO+LEVERAGE, data=mydat)
summary(res)
newvar = data.frame(SALE=100, logAT=660, ROA=0.01, TOBINSQ=3.3, RNDRATIO=0.07, CASHRATIO=0.08, LEVERAGE=0.2)
predict(res, newdata=newvar, interval="confidence", level=0.99)


```

# 4. Model Specification

- Model Specification은 시각적 효과를 극대화하기 위해 데이터를 생성해서 진행하겠습니다.

### 1. 예제 코드

#### 1-1. 선형함수로 모델링

- 데이터 생성하기

```{r}
sample_y = c(6.44,10.19,5.03,14.58,27.42,6.58,10.29,19.1,24.6,29.17,29.4,6.63,15.49,13.85,13.34,7.38,14.34,13.3,9.11,22.89,4.76,10.22,5.66,16.04,24.35,22.31,16.88,26.36,19.53,5.69,7.1,5.58,16.93,5.88,6.8,8.81,10.05,7.74,17.94,8.91,20.45,4.99,30.49,8.5,3.68,6.23,11.17,6.91,23.09,10.23,20.33)

sample_x = c(0.5,2.5,0.6,3,4.8,1.5,2.3,3.7,4.5,4.7,4.9,1.6,3.2,2.8,2.7,1.4,3.1,2.9,1.9,4.3,0.7,2.6,0.4,3.4,4.4,4.2,3.3,4.6,3.9,1,1.2,0.1,3.6,0.8,1.1,2,2.1,1.3,3.5,1.8,4,0.3,5,1.7,0.2,0.9,2.4,0,4.1,2.2,3.8)

plot(sample_y~sample_x, main="sampledat")
```

- 선형함수

```{r}
reslm = lm(sample_y~sample_x)
summary(reslm)

plot(sample_y~sample_x)
abline(reslm, col="red")
```

#### 1-2. 2차 함수로 모델링

```{r}
res2 = lm(sample_y~sample_x+I(sample_x^2))
summary(res2)

plot(sample_y~sample_x)
curve(res2$coefficients[1]+res2$coefficients[2]*x+res2$coefficients[3]*x^2, add=T, col="red")
```

#### 1-3. Log로 변수 변형하여 모델링 

```{r}
logres = lm(log(sample_y)~sample_x)
summary(logres)
plot(log(sample_y)~sample_x)
abline(logres, col="red")
```



### 2. 실습

1. 주어진 데이터 test_x, test_y를 이용하여 그래프를 그려보고, 어떤 모델링이 적합할 지 결정하세요.(여러가지가 가능합니다.)
2. 결정한 모델링에 따라 회귀모형을 적합해 보세요.
3. 결정한 회귀결과를 해석하고, 산점도는 검정색으로, 회귀직선 (혹은 회귀곡선)은 파란색으로 그려보세요.

```{r}
# Test Dataset

test_x = c(5.69,4.08,5.51,3.9,3.43,4.59,4.17,3.69,3.5,3.45,3.41,4.53,3.84,3.97,4.01,4.66,3.87,3.94,4.36,3.54,5.36,4.04,5.92,3.78,3.52,3.56,3.81,3.47,3.64,5.14,4.82,7.3,3.72,5.22,4.9,4.31,4.26,4.74,3.75,4.41,3.61,6.2,3.39,4.47,6.61,5.11,4.12,5,3.59,4.21,3.66)

test_y = c(23.56,19.81,24.97,15.42,2.58,23.42,19.71,10.9,5.4,0.83,0.6,23.37,14.51,16.15,16.66,22.62,15.66,16.7,20.89,7.11,25.24,19.78,24.34,13.96,5.65,7.69,13.12,3.64,10.47,24.31,22.9,24.42,13.07,24.12,23.2,21.19,19.95,22.26,12.06,21.09,9.55,25.01,-0.49,21.5,26.32,23.77,18.83,23.09,6.91,19.77,9.67)
```

```{r Solution4, echo=T}
#1
plot(test_y~ test_x)
#2
logres = lm(test_y~test_x+I(test_x^2))
summary(logres)
#3
plot(test_y~test_x)
curve(logres$coefficients[1]+logres$coefficients[2]*x+logres$coefficients[3]*x^2, add=T, col="blue")

```

# 5. Standard Error (표준오차) 조정하기

### 1. 예제 코드

#### 이분산성 조정

- 기업가치에 총자산이 영향을 주는 영향력을 분석해보겠습니다.

```{r}
res = lm(MKTCAP ~ logAT, data = mydat)
summary(res)
```

- 모델의 plot을 그려보겠습니다.

```{r}
plot(MKTCAP~logAT, data=mydat, main="data plot and regression line")
abline(res, col="red")
```

- 이분산성이 보이는 것 같습니다.
- 회귀분석의 잔차항을 그려보겠습니다.

```{r}
plot(mydat$logAT,resid(res), main="residual")
abline(a=0, b=0, col="red")
```

- 회귀분석에 이분산성 조정을 해보겠습니다.
- 다양한 패키지를 로드하겠습니다.

```{r}
library(lmtest); library(plm); library(sandwich)
```

- 일반 회귀분석

```{r}
summary(lm(MKTCAP~logAT, data=mydat))
```

- White Standard Error 조정 회귀분석

```{r}
res = lm(MKTCAP~logAT, data=mydat)
(white = coeftest(res, vcov = function(x) vcovHC(x, method="white1", type="HC1")))

```

- t value가 달라졌습니다.

#### 자기회귀성이 있는 데이터 분석 

- 현재 데이터는 시계열적 의존도가 존재하지 않으므로 자기회귀성이 있는 데이터를 생성해 진행하겠습니다.

- 자기회귀성이 있는 데이터 생성

```{r}
# True Parameter
a = 1; b= 0.1;

sim_x = runif(50, min=0, max=100)

e=0;
for(i in 1:50){
  eta = rnorm(1, mean =0, sd=1)
  e = c(e, 0.8*e[length(e)]+8*eta)
}
e=e[-1]
sim_y = a+b*sim_x+e
```

- 일반 회귀분석 (No Adjustment)

```{r}
res = lm(sim_y~sim_x)
summary(res)
```

- Newey-West Standard Error 조정 회귀분석 

```{r}
res = lm(sim_y~sim_x)
(newey = coeftest(res, vcov = NeweyWest(res)))
```

- t-value가 달라졌습니다.

### 2. 실습

1. 주어진 데이터 test_x, test_y를 이용하여 그래프를 그려보고, Standard Error를 어떻게 조정해야하는지 판단해보세요.
   (정확한 테스트를 진행할 필요는 없습니다. - White test, Breuth Pagan LM test 등)
2. Standard Error를 조정하지 않은 회귀분석을 시행해 보세요.
3. Standard Error를 조정한 회귀분석을 시행하고 2번과 비교해보세요.

```{r}
# Test Dataset
test_x = c(37,70.59,69.26,9.17,37.81,8.14,60.22,70.04,27.51,58.51,0.43,92.79,62.5,23.58,2.11,26.97,20.84,55.04,64.26,12.7,72.56,47.63,27.71,96.91,95.61,10.96,45.95,0.36,99.04,89.34,34.09,81.03,81.95,62.95,66.71,38.02,42.33,65.34,85.48,30.51,92.12,68.81,55.66,64.93,63.53,98.21,31.34,31.06,53.84,76.8)

test_y = c(109.1,80.6,171.61,-10.29,26.84,29.53,78.52,139.7,32.94,147.15,-16.24,206.32,84.65,-42.72,37.08,30.24,61.23,231.6,462.87,289.34,293.14,171.12,203.42,324.45,299.47,143.67,137.32,98.5,202.81,353.68,281.14,290.37,195.74,337.6,205.7,135.48,95.82,65.79,61.52,-215.37,-36.33,-77.02,-164.48,-83.29,-14.78,35.39,-103.9,-52.96,127.34,118.18)
```

```{r Solution5, echo=T}
#1
plot(test_x, type="l")
plot(test_y, type="l")
plot(test_y~test_x)
#2
res = lm(test_y~test_x)
summary(res)
#3
res = lm(test_y~test_x)
(newey = coeftest(res, vcov = NeweyWest(res)))

```

# 6. 시계열 데이터 모델링 (선형)

- 시계분 분석은 KOSPI 주가지수로 분석을 진행하겠습니다.

### 1. 예제 코드

#### Install Library

```{r}
library(quantmod)
library(forecast)
```

- 2018년도 - 2019년도의 KOSPI 주가지수 데이터를 불러옵니다.

#### Import Data

```{r}
kospi = getSymbols(Symbols="^KS11", src="yahoo", from="2018-01-01", to="2019-04-14", auto.assign=FALSE)
kospi = kospi[complete.cases(kospi),c("KS11.Adjusted")]
colnames(kospi)="index"
plot(kospi)
```

#### ACF plot

```{r}
acf(kospi,20)
pacf(kospi,20)
```

#### AR(1)

```{r}
(reg = arima(kospi, order=c(1,0,0), method="CSS"))
(predict(reg, n.ahead=10))
fcast = forecast(reg, h=100)
plot(fcast)

```



#### MA(3)

```{r}
(reg = arima(kospi, order=c(0,0,3), method="CSS"))
fcast = forecast(reg, h=100)
plot(fcast)
```

#### ARMA(1,1)

```{r}
(reg = arima(kospi, order=c(1,0,1), method="CSS"))
fcast = forecast(reg, h=30)
plot(fcast)

```

### 2. 실습

- 삼성전자(KS00593.KS)의 2019년 주가를 뽑아 ARMA(1,1) 모형으로 분석하고 내일의 주가를 예측해보세요.
- 30일치 주가를 예측해서 그래프를 그려보세요.

```{r}
samsung = getSymbols(Symbols="005930.KS", src="yahoo", from="2019-01-01", to="2019-04-14", auto.assign=FALSE)
samsung = samsung[complete.cases(samsung),c("005930.KS.Adjusted")]
colnames(samsung)="price"
plot(samsung)
```

```{r}
(reg = arima(samsung, order=c(1,0,1), method="CSS"))
(predict(reg, n.ahead=1))
fcast = forecast(reg, h=30)
plot(fcast)
```





# 7. Volatility 모형

- 이번 분석은 아시아나항공의 주가로 분석을 진행하겠습니다.

### 1. 예제 코드

- 2018년도 - 2019년도의 KOSPI 주가지수 데이터를 불러옵니다.

#### Import Data

```{r}
asiana = getSymbols(Symbols="020560.KS", src="yahoo", from="2018-01-01", to="2019-04-14", auto.assign=FALSE)
asiana = asiana[complete.cases(asiana),c("020560.KS.Adjusted")]
colnames(asiana)="price"
plot(asiana)

```

- 이번에는 주식의 수익률로 분석을 진행하겠습니다.

```{r}
asiana$return = log(asiana$price) - log(lag(asiana$price))
head(asiana)
```

#### Import Library

```{r}
library(rugarch)
library(FinTS)
```



#### ARCH Model

- ARCH Effect test

```{r}
ArchTest(asiana$return, lag=12)
```

#### ARCH Order determination

```{r}
asiana = asiana[-1,]
pacf(c(asiana$return-mean(asiana$return))^2, lag=30)
```



#### ARMA(0,0), ARCH(1) Modeling

```{r}
spec1 = ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model=list(garchOrder=c(1,0)))
(fit = ugarchfit(spec = spec1, data=asiana$return))
```

#### Prediction

```{r}
pred = ugarchforecast(fit, n.ahead=10)
plot(pred, which=1)
plot(pred, which=3)
```

#### ARMA(0,0), GARCH(1,1) Modeling

```{r}
spec1 = ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model=list(garchOrder=c(1,1)))
(fit = ugarchfit(spec = spec1, data=asiana$return))
```

#### ARMA(0,0), IGARCH(1) Modeling

```{r}
spec1 = ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model=list(model = "iGARCH", garchOrder=c(1,1)))
(fit = ugarchfit(spec = spec1, data=asiana$return))
```

### 2. 실습

- 셀트리온(068270.KS)의 2년치 주가를 다운로드받고, 1개월치 주가 수익률을 ARMA(0,0)-GARCH(1,1) 모델을 통해 예측해보세요.

```R
celt = getSymbols(Symbols="068270.KS", src="yahoo", from="2017-04-15", to="2019-04-14", auto.assign=FALSE)
celt = celt[complete.cases(celt),c("068270.KS.Adjusted")]
colnames(celt)="price"
plot(celt)

celt$return = log(celt$price) - log(lag(celt$price))
celt = celt[-1,]

spec1 = ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model=list(garchOrder=c(1,1)))
(fit = ugarchfit(spec = spec1, data=celt$return))

pred = ugarchforecast(fit, n.ahead=30)
plot(pred, which=1)
plot(pred, which=3)
```

