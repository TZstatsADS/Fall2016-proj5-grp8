###clear environment
rm(list = ls())

###load library
library(dplyr)

###set directory
setwd('C:/Study/Columbia/W4243_Applied_Data_Science/Project5/data')

###read data
#notice: only load the data you need
load('train_data_for_Probability_ad_id_given_feature.RData')
load('train_data_ad_detail.RData')
load('train_data_ad_document_detail.RData')
train_data_for_Probability_ad_id_given_feature[is.na(train_data_for_Probability_ad_id_given_feature)]<- -1


###calculate the unique value count of single feature
length(unique(train_data_for_Probability_ad_id_given_feature$source_id)) #4807
length(unique(train_data_for_Probability_ad_id_given_feature$publisher_id)) #485
length(unique(train_data_for_Probability_ad_id_given_feature$category_id)) #91
length(unique(train_data_for_Probability_ad_id_given_feature$topic_id)) #301
length(unique(train_data_for_Probability_ad_id_given_feature$document_id)) #756510
length(unique(train_data_for_Probability_ad_id_given_feature$ad_id)) #478950

###calculate the min value of each feature except na, so that I decide assign -1 to all na
train_data_ad_detail  #min 1000
unique_source<-unique(train_data_for_Probability_ad_id_given_feature$source_id)      #min 1
unique_publisher<-unique(train_data_for_Probability_ad_id_given_feature$publisher_id)      #min 2
unique_topic<-unique(train_data_for_Probability_ad_id_given_feature$topic_id)      #min 0
unique_ad<-unique(train_data_for_Probability_ad_id_given_feature$ad_id)
unique_campaign_id<-unique(train_data_ad_detail$campaign_id)                      #min 0
unique_advertiser_id<-unique(train_data_ad_detail$advertiser_id)                  #min 0

###The function to calculate the probability
probability_ad_id_given_feature<-function(data,variable_name,ad_feature)
{
  unique_value<-unique(data.matrix(data[,variable_name]))
  row_length<-length(unique_value)
  unique_ad_feature<-unique(data.matrix(data[,ad_feature]))
  col_length<-length(unique_ad_feature)
  probability_matrix<-matrix(data=0,nrow=row_length,ncol=col_length)
  count<-1
  col_num<-match(variable_name,colnames(data))
  for(i in unique_value)
  {
    data_part<-data %>% 
               filter(data[,col_num]==i)
    recommend_count<-data_part %>% group_by_(ad_feature)%>% summarise(count_num=n())
    clicked_count<-data_part %>% group_by_(ad_feature)%>% summarise(count_num=sum(clicked))
    shresh<-min(quantile(recommend_count$count_num,probs = c(0.75)),8)
    recommend_count[recommend_count$count_num<shresh,]$count_num=
      recommend_count[recommend_count$count_num<shresh,]$count_num+round(50/shresh)*shresh
    click_probability<-clicked_count$count_num/recommend_count$count_num
    probability_matrix[count,match(as.data.frame(recommend_count)[,ad_feature],unique_ad_feature)]<-click_probability
    #print the process
    print(paste(as.character(count/row_length*100),'%',' completed',sep=''))
    count=count+1
  }
  probability_matrix[probability_matrix<0.0001]<-0.0001
  result<-list('probability_matrix'=probability_matrix,'row_number'=unique_value,'col_number'=unique_ad_feature)
  return(result)
}

###calculate some result
#category_result<-probability_ad_id_given_feature('category_id')
#   topic_result<-probability_ad_id_given_feature('topic_id')
#publisher_result<-probability_ad_id_given_feature('publisher_id')
category_advertiser_result<-probability_ad_id_given_feature(train_data_ad_detail,'category_id','advertiser_id')
publisher_advertiser_result<-probability_ad_id_given_feature(train_data_ad_detail,'publisher_id','advertiser_id')
source_advertiser_result<-probability_ad_id_given_feature(train_data_ad_detail,'source_id','advertiser_id')
publisher_category_result<-probability_ad_id_given_feature(train_data_ad_document_detail,'publisher_id','ad_category_id')

###save data
save(category_result,file='category_result.RData')
save(topic_result,file='topic_result.RData')
save(publisher_result,file='publisher_result.RData')
save(unique_ad,file='unique_ad.RData')
save(category_advertiser_result,file='category_advertiser_result.RData')
save(publisher_category_result,file='publisher_category_result.RData')





