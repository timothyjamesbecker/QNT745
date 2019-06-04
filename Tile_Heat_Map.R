library('ggplot2')
library('reshape2')

#[1] retrieve the completed imputed nhanes dataset from Imputation session
data<-complete(imp)
data[,'age']<-as.numeric(data[,'age'])
data[,'hyp']<-as.numeric(data[,'hyp'])

#[2] cooralation of the varaibles in the result
cor_data<-cor(data)

#[3] use ggplot2 to visualize the results
ggplot(data=melt(cor_data), aes(x=Var1, y=Var2, fill=value)) + geom_tile()

#[4] which are the most coorelated? 