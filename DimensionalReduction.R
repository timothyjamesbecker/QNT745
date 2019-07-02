library('ggplot2')
library('reshape2')
library('Rtsne')
iris_unique <- unique(iris)      #remove duplicates
species <- iris_unique$Species   #pull out the species names for every row for coloring
set.seed(0)                      #set a random seed so you get the same picture
tsne_out <- as.data.frame(Rtsne(as.matrix(iris_unique[,1:4]))$Y) #run TSNE
colnames(tsne_out)<-c('y2','y1')                                 #set a nice column label
ggplot(tsne_out, aes(y1,y2,colour=species)) + geom_point()       #basic ggplot2 scatter