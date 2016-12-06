###EDA ads proj 5
library(data.table)
library(dplyr)
library(MASS) 
setwd("C:/Users/ys2882/Downloads")
load("merge_2.RData")
load("merge_3.RData")
load("merge_4.RData")
load("train_data_ad_detail.RData")
sorted_main=sort(table(ad_id),decreasing=T)
sorted_main_100=sorted_main[1:100]

sorted_main_p1=sort(table(ad_id[which(platform==1)]),decreasing=T)
sorted_main__p1_100=sorted_main[1:100]

# attach(merge_3)
# merge_3$entity_id<-NULL
# merge_3$entities_confidence_level<-NULL
# new=merge_3
# new[is.na(new)] <- 0
# detach(merge_3)
# nnet1 = nnet (x=new[1:10000,8:14],y=class.ind(new$advertiser_id[1:10000]),softmax=TRUE,size=1,maxit=10000)
NA_result=colSums(is.na(train_data_for_Probability_ad_id_given_feature))##detect NA
write.csv(file="NA_result_train_data.csv",NA_result)
write.csv(head(train_data_ad_detail),file="sample.csv")

##EDA
