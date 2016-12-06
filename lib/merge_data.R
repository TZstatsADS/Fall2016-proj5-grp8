###clear environment
rm(list = ls())

###load library
library(data.table)

###set directory
setwd('C:/Study/Columbia/W4243_Applied_Data_Science/Project5/data')

###read data
#note that your memory may not be large enough to read them all,only read the data you need
#and remove the data once it's useless
clicks_train<-fread('clicks_train.csv')
clicks_test<-fread('clicks_test.csv')
events<-fread('events.csv')
documents_meta<-fread('documents_meta.csv')
documents_categories<-fread('documents_categories.csv')
documents_entities<-fread('documents_entities.csv')
documents_topics<-fread('documents_topics.csv')
promoted_content<-fread('promoted_content.csv')
sample_submission<-fread('sample_submission.csv')


#######################################################################merge data for the clicks_train
###get the display_id
display_rank<-clicks_train$display_id
#choose from the events whose display_id equal display_rank and only take the document id
events_for_merge<-events[match(display_rank,events$display_id),]$document_id
#remove the display_id colname when it's useless
clicks_train$display_id<-NULL
#merge the click_train and events through display_id
merge_5<-cbind(clicks_train,events_for_merge)
#change the column names
colnames(merge_5)<-c("ad_id", "clicked" ,"document_id")

#get the document_id 
documents_rank<-merge_5$document_id
#choose from the documents_meta whose document_id equal documents_rank
documents_meta_for_merge<-documents_meta[match(documents_rank,documents_meta$document_id),]
#remove document_id and publish time
documents_meta_for_merge$document_id<-NULL
documents_meta_for_merge$publish_time<-NULL
merge_6<-cbind(merge_5,documents_meta_for_merge)

#choose from the documents_category whose document_id equal documents_rank
documents_categories_for_merge<-documents_categories[match(documents_rank,documents_categories$document_id),]
#remove document_id and confidence level
documents_categories_for_merge$document_id<-NULL
documents_categories_for_merge$confidence_level<-NULL
merge_7<-cbind(merge_6,documents_categories_for_merge)

#choose from the documents_topic whose document_id equal documents_rank
documents_topics_for_merge<-documents_topics[match(documents_rank,documents_topics$document_id),]
#remove document_id and confidence level
documents_topics_for_merge$document_id<-NULL
documents_topics_for_merge$confidence_level<-NULL
train_data_for_Probability_ad_id_given_feature<-cbind(merge_7,documents_topics_for_merge)

###add the ad_id detail to the data frame
promoted_content_for_merge<-promoted_content[match(train_data_for_Probability_ad_id_given_feature$ad_id,promoted_content$ad_id),]
promoted_content_for_merge$ad_id<-NULL
train_data_ad_detail<-cbind(train_data_for_Probability_ad_id_given_feature,promoted_content_for_merge)
colnames(train_data_ad_detail)<-c("ad_id","clicked","document_id","source_id","publisher_id","category_id","topic_id",
                                  "ad_document_id",'campaign_id','advertiser_id')

##through ad_document_id,add it's document feature
ad_document_id<-train_data_ad_detail$ad_document_id
#choose from the documents_category whose document_id equal documents_rank
documents_categories_for_merge<-documents_categories[match(ad_document_id,documents_categories$document_id),]
#remove document_id and confidence level
documents_categories_for_merge$document_id<-NULL
documents_categories_for_merge$confidence_level<-NULL
merge_7<-cbind(train_data_ad_detail,documents_categories_for_merge)

#choose from the documents_topic whose document_id equal documents_rank
documents_topics_for_merge<-documents_topics[match(ad_document_id,documents_topics$document_id),]
#remove document_id and confidence level
documents_topics_for_merge$document_id<-NULL
documents_topics_for_merge$confidence_level<-NULL
train_data_ad_document_detail<-cbind(merge_7,documents_topics_for_merge)
colnames(train_data_ad_document_detail)<-c("ad_id", "clicked","document_id" ,"source_id" ,"publisher_id" ,"category_id","topic_id",      
"ad_document_id","campaign_id" ,"advertiser_id" ,"ad_category_id" ,"ad_topic_id")    

#######################################################################merge data for the clicks_test
###merge display_id with document features
display_rank<-clicks_test$display_id
#choose from the events whose display_id equal display_rank and only take the document id
events_for_merge<-events[match(display_rank,events$display_id),]$document_id
#remove the display_id colname when it's useless
clicks_test$display_id<-NULL
#merge the click_train and events through display_id
merge_5<-cbind(clicks_test,events_for_merge)
#change the column names
colnames(merge_5)<-c("ad_id" ,"document_id")

#get the document_id 
documents_rank<-merge_5$document_id
#choose from the documents_meta whose document_id equal documents_rank
documents_meta_for_merge<-documents_meta[match(documents_rank,documents_meta$document_id),]
#remove document_id and publish time
documents_meta_for_merge$document_id<-NULL
documents_meta_for_merge$publish_time<-NULL
merge_6<-cbind(merge_5,documents_meta_for_merge)

#choose from the documents_category whose document_id equal documents_rank
documents_categories_for_merge<-documents_categories[match(documents_rank,documents_categories$document_id),]
#remove document_id and confidence level
documents_categories_for_merge$document_id<-NULL
documents_categories_for_merge$confidence_level<-NULL
merge_7<-cbind(merge_6,documents_categories_for_merge)

#choose from the documents_topic whose document_id equal documents_rank
documents_topics_for_merge<-documents_topics[match(documents_rank,documents_topics$document_id),]
#remove document_id and confidence level
documents_topics_for_merge$document_id<-NULL
documents_topics_for_merge$confidence_level<-NULL
test_data_for_Probability_ad_id_given_feature<-cbind(merge_7,documents_topics_for_merge)

###add the ad_id detail to the data frame
promoted_content_for_merge<-promoted_content[match(test_data_for_Probability_ad_id_given_feature$ad_id,promoted_content$ad_id),]
promoted_content_for_merge$ad_id<-NULL
test_data_ad_detail<-cbind(test_data_for_Probability_ad_id_given_feature,promoted_content_for_merge)
colnames(test_data_ad_detail)<-c("ad_id","document_id","source_id","publisher_id","category_id","topic_id",
                                  "ad_document_id",'campaign_id','advertiser_id')

##through ad_document_id,add it's document feature
ad_document_id<-test_data_ad_detail$ad_document_id
#choose from the documents_category whose document_id equal documents_rank
documents_categories_for_merge<-documents_categories[match(ad_document_id,documents_categories$document_id),]
#remove document_id and confidence level
documents_categories_for_merge$document_id<-NULL
documents_categories_for_merge$confidence_level<-NULL
merge_7<-cbind(test_data_ad_detail,documents_categories_for_merge)

#choose from the documents_topic whose document_id equal documents_rank
documents_topics_for_merge<-documents_topics[match(ad_document_id,documents_topics$document_id),]
#remove document_id and confidence level
documents_topics_for_merge$document_id<-NULL
documents_topics_for_merge$confidence_level<-NULL
test_data_ad_document_detail<-cbind(merge_7,documents_topics_for_merge)
colnames(test_data_ad_document_detail)<-c("ad_id","document_id" ,"source_id" ,"publisher_id" ,"category_id","topic_id",      
                                           "ad_document_id","campaign_id" ,"advertiser_id" ,"ad_category_id" ,"ad_topic_id") 


###save data
save(test_data_for_Probability_ad_id_given_feature,file='processed_test_data.RData')
save(train_data_for_Probability_ad_id_given_feature,file='train_data_for_Probability_ad_id_given_feature.RData')
save(train_data_ad_detail,file='train_data_ad_detail.RData')
save(test_data_ad_detail,file='test_data_ad_detail.RData')
save(train_data_ad_document_detail,file='train_data_ad_document_detail.RData')
save(test_data_ad_document_detail,file='test_data_ad_document_detail.RData')
