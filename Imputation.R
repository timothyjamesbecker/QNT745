#install.packages(c('ggplot2','mice','NHANES')) #uncomment to install packages
library('mice')
library('NHANES')
data('NHANES')

?nhanes #will open the documentation that explains the data frame

#display the data frame or df
#[1]df are a tabular data format where each column has a specific data type
nhanes #display the data frame or df

#[2] notice that each of the data types are numeric or decimal/floating version of a real number
# we can convert the data type of each row by selecting it nhanes[,'age'] will get only the age column
nhanes[,'age']<-as.factor(nhanes[,'age'])    #will get factors 1,2,3 no missing. Factors are good for categories
nhanes[,'hyp']<-as.logical(nhanes[,'hyp']-1) #will get logical (T,F) and NA which is missing value

?mice #open docs for mice package, scroll down and open the vignetts(tutorials) for more if needed!
md.pattern(nhanes) #output the number of missing values and plot
#[3] notice how there are 7 out of the 25 rows that have no data other than the age most of which are age group 1
#because there seems to be a pattern to the missingness of the data, we can't assume that the missing data is random
#in which case we will need to consider more carefully how to impute (fill in the missing values)

#mean--------------------------------------------------------------------------
imp<-mice(nhanes,method='mean',m=1) #pretty bad to fill in with the mean values
complete(imp) #show the resulting fake data
densityplot(nhanes[,'bmi'])        #plot original
densityplot(complete(imp)[,'bmi']) #plot bad fake data

#mice algorithm----------------------------------------------------------------
imp<-mice(nhanes,m=30) #pretty great multivariate imputation
complete(imp) #show the resulting fake data
densityplot(nhanes[,'bmi'])        #plot original
densityplot(complete(imp)[,'bmi']) #plot better fake data

