###clear environment
rm(list = ls())

###load library
library(dplyr)

###set directory
setwd('C:/Study/Columbia/W4243_Applied_Data_Science/Project5/data')

###read data
load('train_data_for_Probability_ad_id_given_feature.RData')
train_data_for_Probability_ad_id_given_feature[is.na(train_data_for_Probability_ad_id_given_feature)]<- -1


###calculate the unique value count of single feature
length(unique(train_data_for_Probability_ad_id_given_feature$source_id)) #4807
length(unique(train_data_for_Probability_ad_id_given_feature$publisher_id)) #485
length(unique(train_data_for_Probability_ad_id_given_feature$category_id)) #91
length(unique(train_data_for_Probability_ad_id_given_feature$topic_id)) #301
length(unique(train_data_for_Probability_ad_id_given_feature$document_id)) #756510
length(unique(train_data_for_Probability_ad_id_given_feature$ad_id)) #478950

###calculate the min value of each feature except na, so that I decide assign -1 to all na
unique_category<-unique(train_data_for_Probability_ad_id_given_feature$category_id)  #min 1000
unique_source<-unique(train_data_for_Probability_ad_id_given_feature$source_id)      #min 1
unique_publisher<-unique(train_data_for_Probability_ad_id_given_feature$publisher_id)      #min 2
unique_topic<-unique(train_data_for_Probability_ad_id_given_feature$topic_id)      #min 0
unique_ad<-unique(train_data_for_Probability_ad_id_given_feature$ad_id)

###The function to calculate the probability
probability_ad_id_given_feature<-function(variable_name)
{
  unique_value<-unique(train_data_for_Probability_ad_id_given_feature[,variable_name])
  row_length<-length(unique_value)
  probability_matrix<-matrix(data=0,nrow=row_length,ncol=478950)
  count<-1
  for(i in unique_value)
  {
    data_part<-train_data_for_Probability_ad_id_given_feature %>% filter(variable_name==i)
    ad_id_recommend_count<-data_part %>% group_by(ad_id)%>% summarise(count_num=n())
    ad_id_clicked_count<-data_part %>% group_by(ad_id)%>% summarise(count_num=sum(clicked))
    shresh<-quantile(ad_id_recommend_count$count_num,probs = c(0.75))
    ad_id_recommend_count[ad_id_recommend_count$count_num<shresh,]$count_num=
      ad_id_recommend_count[ad_id_recommend_count$count_num<shresh,]$count_num+round(50/shresh)*shresh
    click_probability<-ad_id_clicked_count$count_num/ad_id_recommend_count$count_num
    probability_matrix[count,match(ad_id_recommend_count$ad_id,unique_ad)]<-click_probability
    #print the process
    print(paste(as.character(count/row_length*100),'%',' completed',sep=''))
    count=count+1
  }
  probability_matrix[probability_matrix<0.0001]<-0.0001
  result<-list('probability_matrix'=probability_matrix,'row_number'=unique_value)
  return(result)
}

###
category_result<-probability_ad_id_given_feature('category_id')
topic_result<-probability_ad_id_given_feature('topic_id')
publisher_result<-probability_ad_id_given_feature('publisher_id')
#source_result<-probability_ad_id_given_feature('source_id')

###save data
save(category_result,file='category_result.RData')
save(topic_result,file='topic_result.RData')
save(publisher_result,file='publisher_result.RData')
