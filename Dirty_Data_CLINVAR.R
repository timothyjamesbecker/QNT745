library('stringr')
library('ggplot2')
library('reshape2')
library('mice')
library('rstudioapi')    
#set the working directory path to this folder
setwd(str_split(rstudioapi::getActiveDocumentContext()['path'],'Dirty_Data_CLINVAR.R')[[1]][1])
#alternatively you can just type in the full path below...
vcf_path <- 'clinvar_20180401.vcf.gz'  #load up a 148MB file that is ~12MB compressed
data <- fread(vcf_path,skip=28,data.table=F) #skip the first 28 lines which are headers, https://samtools.github.io/hts-specs/VCFv4.2.pdf
colnames(data) <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO')
#355E3 data rows now...
#just look at the main chromasomes in the human genome GRch37
chroms <- c('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT')

#first lets get all the bad variants, this is codes as Pathogenically Clinically Significant
R <- list() #empty list will save the results of our search inside the dirty data
for(i in 1:dim(data)[1]){ #loop over every row of data in the df
  clnsig <- str_split(str_split(data[i,'INFO'],'CLNSIG=')[[1]][2],';')[[1]][1]
  if(data[i,'CHROM'] %in% chroms && !is.na(clnsig) && clnsig == "Pathogenic"){ #if a row is missing CLNSIG, this will be NA
    R<-append(R,i) #save the index in data that had CLNSIG=Pathogenic
  }
} #50E3 data rows now...
clnsig_data <- data[as.numeric(R),] #get all the rows that had the CLNSIG=Pathogenic value

#next lets take a look at CLNVC values and ggplot2 the Duplication locations where gain of this part of DNA is bad
S <- list()
for(i in 1:dim(clnsig_data)[1]){
  clnvc <- str_split(str_split(clnsig_data[i,'INFO'],'CLNVC=')[[1]][2],';')[[1]][1]
  if(clnvc=='Duplication'){
    S <- append(S,i)
  }
}
dup_clnsig_data <- clnsig_data[as.numeric(S),]
#now we have only 4E3 rows of Pathogenic Duplication Events

#count the number of Duplication events per chrom
counts<-matrix(0,nrow=length(chroms))
rownames(counts)<-chroms
colnames(counts)<-c("Duplications")
for(i in 1:dim(dup_clnsig_data)[1]){
  counts[dup_clnsig_data[i,'CHROM'],] <- counts[dup_clnsig_data[i,'CHROM'],]+1
}
counts<-as.data.frame(counts)

#plot the result
ggplot(as.data.frame(counts), aes(x=factor(chroms,levels=chroms),y=Duplications)) + geom_bar(stat="identity")
#clearly chrom 17 has the most bad duplications, this is in fact where many ONCO genes live such as TP53 and BRCA1...
