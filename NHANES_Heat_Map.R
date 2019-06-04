library('NHANES')
library('ggplot2')
library('reshape2')
library('mice')

#[1] explore the full datset by looking at its columns
NHANES

#[2] get the column names
colnames(NHANES)

#[3] get a new toy dataset (1000 rows) with Race, Gender, Smoking and Weight
data<-NHANES[1:1000,c('Race1','Gender','Age','SmokeNow','Weight')]

#[4] impute the missing data
imp<-mice(data,m=30)
imp_data<-complete(imp)

#[5] convert numerics for coorelation
imp_data[,'Race1']<-as.numeric(imp_data[,'Race1'])
imp_data[,'Gender']<-as.numeric(imp_data[,'Gender'])
imp_data[,'SmokeNow']<-as.numeric(imp_data[,'SmokeNow'])
cor_data<-cor(imp_data)

#[6] ggplot2 the coorelations
ggplot(data=melt(cor_data), aes(x=Var1, y=Var2, fill=value)) + geom_tile()

#[7] which ones are the most linked?
