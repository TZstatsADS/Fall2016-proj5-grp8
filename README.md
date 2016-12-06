# ADS Final Project: 

Term: Fall 2016

+ Team Name: Plus One Second
+ Projec title: Advertisement Click Prediction
+ Team members
	+ Weichuan Wu	
	+ Jingjing Feng 	
	+ Yiwei	Sun  	
	+ Yunyi Zhang
+ Project summary: In this project, we develop a system in predicting whether users will click on certain promoted advertisements on the browsing webpage. The idea comes from a [kaggle competition](https://www.kaggle.com/c/outbrain-click-prediction). The datasets of the browsing webpage cover its topic, category and publisher while those of the promoted advertisements cover its advertiser and related campaign. We use frequency of clicks under different webpage and advertisements features to construct the probability matrix in a form of p(advertisement feature|webpage feature) for each probability. Eventually, we conclude that the probablity matrix of p(campaign_id|publisher_id) makes the best predicting performance. Our predictions make it to the top 100 in kaggle competition. 

**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All members participated in discussion of project content and analysis design. Weichuan Wu developed the fundamental structure of the predicting model for evaluation. Yiwei Sun, Yunyi Zhang and Jingjing Feng helped in improving the model by running evaluation under different combinations of features; Yiwei Sun performed exploratory data analysis on the datasets and Jingjing Feng made the final presentation. All team members contributed to the GitHub repository and prepared the presentation. All team members approve our work presented in our GitHub repository including this contribution statement.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
