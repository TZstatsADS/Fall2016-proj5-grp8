###clear environment
rm(list = ls())

###load library
library(data.table)
library(dplyr)

###set directory
setwd('C:/Study/Columbia/W4243_Applied_Data_Science/Project5/data')

###load data
#only load the data you need
#load('unique_ad.RData')
#load('processed_test_data.RData')
#load('category_advertiser_result.RData')
#load('publisher_advertiser_result.RData')
#load('category_campaign_result.RData')
#load('publisher_campaign_result.RData')
load('publisher_category_result.RData')
#load('test_data_ad_detail.RData')
load('test_data_ad_document_detail.RData')
#load('topic_result.RData')
#load('publisher_result.RData')
#change all the na to -1
#test_data_for_Probability_ad_id_given_feature[is.na(test_data_for_Probability_ad_id_given_feature)]<- -1
#load('category_result.RData')
clicks_test<-fread('clicks_test.csv')



###Using the category id
#get the variable id
category_id<-test_data_for_Probability_ad_id_given_feature$category_id
#get the ad id
ad_id<-test_data_for_Probability_ad_id_given_feature$ad_id
#get the row number of the probability matrix
row_number<-match(category_id,category_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_id,unique_ad)
#using the row and column number to get the probability
probability_list<-category_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
ranked_result<-clicks_test_add_probability_ranked %>% 
               group_by(display_id) %>% 
               summarise(ad_id=paste(ad_id,collapse=" "))

###Using the topic id
#get the variable id
topic_id<-test_data_for_Probability_ad_id_given_feature$topic_id
#get the ad id
ad_id<-test_data_for_Probability_ad_id_given_feature$ad_id
#get the row number of the probability matrix
row_number<-match(topic_id,topic_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_id,unique_ad)
#using the row and column number to get the probability
probability_list<-topic_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
topic_ad_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###Using the publisher id
#get the variable id
publisher_id<-test_data_for_Probability_ad_id_given_feature$publisher_id
#get the ad id
ad_id<-test_data_for_Probability_ad_id_given_feature$ad_id
#get the row number of the probability matrix
row_number<-match(publisher_id,publisher_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_id,unique_ad)
#using the row and column number to get the probability
probability_list<-publisher_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
publisher_ad_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###combine category and publisher probability assumng they are independent
###Using the category id
#get the variable id
category_id<-test_data_for_Probability_ad_id_given_feature$category_id
#get the ad id
ad_id<-test_data_for_Probability_ad_id_given_feature$ad_id
#get the row number of the probability matrix
row_number<-match(category_id,category_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_id,unique_ad)
#using the row and column number to get the probability
probability_list_category<-category_result$probability_matrix[cbind(row_number,col_number)]
#get the variable id
publisher_id<-test_data_for_Probability_ad_id_given_feature$publisher_id
#get the ad id
ad_id<-test_data_for_Probability_ad_id_given_feature$ad_id
#get the row number of the probability matrix
row_number<-match(publisher_id,publisher_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_id,unique_ad)
#using the row and column number to get the probability
probability_list_publisher<-publisher_result$probability_matrix[cbind(row_number,col_number)]
probability_list_combine<-probability_list_category*probability_list_publisher
clicks_test_add_probability<-cbind(clicks_test,probability_list_combine)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
category_publisher_ad_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))


###
#get the document feature
document_feature<-data.matrix(test_data_ad_detail[,'category_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_detail[,'advertiser_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,category_advertiser_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,category_advertiser_result$col_number)
#using the row and column number to get the probability
probability_list<-category_advertiser_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
category_advertiser_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###using publisher_id and advertiser_id
#get the document feature
document_feature<-data.matrix(test_data_ad_detail[,'publisher_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_detail[,'advertiser_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,publisher_advertiser_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,publisher_advertiser_result$col_number)
#using the row and column number to get the probability
probability_list<-publisher_advertiser_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
publisher_advertiser_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###using publisher_id and advertiser_id
#get the document feature
document_feature<-data.matrix(test_data_ad_detail[,'publisher_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_detail[,'advertiser_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,publisher_advertiser_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,publisher_advertiser_result$col_number)
#using the row and column number to get the probability
probability_list<-publisher_advertiser_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
publisher_advertiser_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###using category_id and campaign_id
#get the document feature
document_feature<-data.matrix(test_data_ad_detail[,'category_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_detail[,'campaign_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,category_campaign_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,category_campaign_result$col_number)
#using the row and column number to get the probability
probability_list<-category_campaign_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
category_campaign_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###using publisher_id and campaign_id
#get the document feature
document_feature<-data.matrix(test_data_ad_detail[,'publisher_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_detail[,'campaign_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,publisher_campaign_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,publisher_campaign_result$col_number)
#using the row and column number to get the probability
probability_list<-publisher_campaign_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
publisher_campaign_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))

###using publisher_id and category_id
#get the document feature
document_feature<-data.matrix(test_data_ad_document_detail[,'publisher_id'])
#get the ad feature 
ad_feature<-data.matrix(test_data_ad_document_detail[,'ad_category_id'])
#get the row number of the probability matrix
row_number<-match(document_feature,publisher_category_result$row_number)
#get the column number of the probability matrix
col_number<-match(ad_feature,publisher_category_result$col_number)
#using the row and column number to get the probability
probability_list<-publisher_category_result$probability_matrix[cbind(row_number,col_number)]
#combine the clicks_test with the probability list
clicks_test_add_probability<-cbind(clicks_test,probability_list)
#rename colnumn
colnames(clicks_test_add_probability)<-c("display_id","ad_id" ,"probability")
#order the data by display id and probability
clicks_test_add_probability_ranked<-clicks_test_add_probability[order(clicks_test_add_probability$display_id,-clicks_test_add_probability$probability),]
#rank the probability within group
publisher_category_rank_result<-clicks_test_add_probability_ranked %>% 
  group_by(display_id) %>% 
  summarise(ad_id=paste(ad_id,collapse=" "))


###save data
save(ranked_result,file='ranked_result.RData')
write.csv(ranked_result,file='ranked_result.csv',row.names = FALSE)
write.csv(category_advertiser_rank_result,file='category_advertiser_rank_result.csv',row.names = FALSE)
write.csv(topic_ad_result,file='topic_ad_result.csv',row.names = FALSE)
write.csv(publisher_ad_result,file='publisher_ad_result.csv',row.names = FALSE)
write.csv(category_publisher_ad_result,file='category_publisher_ad_result.csv',row.names = FALSE)
write.csv(publisher_advertiser_rank_result,file='publisher_advertiser_rank_result.csv',row.names = FALSE)
write.csv(category_campaign_rank_result,file='category_campaign_rank_result.csv',row.names = FALSE)
write.csv(publisher_campaign_rank_result,file='publisher_campaign_rank_result.csv',row.names = FALSE)
write.csv(publisher_category_rank_result,file='publisher_category_rank_result.csv',row.names = FALSE)
