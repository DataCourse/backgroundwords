# Empty memory and read the surveys 
# (need to be downloaded from REDCap and stored input/survey.csv)
rm(list=ls())
mysurveys <- read.csv("input/mysurveys.csv", stringsAsFactors=FALSE)

# Plot the counts of survey responses over time
mycounts <- mysurveys$X.record_id
mytimes <- as.POSIXct(mysurveys$presurvey_timestamp)
png(filename="output/surveyresponse.png",width=1280,height=960,res=150)
plot(mytimes,mycounts,type="l",ylim=c(0,5000),lwd=3,xlab="Time (UTC)",ylab="# of Survey Responses")
abline(h=seq(0,5000,1000),lwd=1)
abline(h=seq(500,4500,1000),lty="dashed")
dev.off()

# Word cloud
png(filename="output/wordcloud.png",width=1200,height=1200,res=300)
library(wordcloud)
library(stringr)
myexperience <- tolower(mysurveys$prev_experience)
myexperience <- str_replace_all(myexperience,"[^[:alpha:]]"," ")
myexperience <- str_replace_all(myexperience, "[[:blank:]]+", " ")
allwords = data.frame(table(strsplit(paste(myexperience,collapse=" ")," ")))
allwords <- allwords[allwords[,1]!="",]
allwords <- allwords[!allwords[,1] %in% c('of','am','no','a','i','in',
                                          'and','have','with','as','to',
                                          'my','for','the','on','at','so',
                                          'an','or','but','ve','about','had',
                                          'did','done','do','our','is','not',
                                          'that','this','we','by','some','any',
                                          'it','none','from','was','also','there',
                                          'into','where'),]
wordcloud(allwords[,1],allwords[,2],scale=c(2,0.5),rot.per=0.1,max.words=300,
          random.order=FALSE,colors=rainbow(20,start=0.25,end=1,v=0.6),random.color=TRUE)
dev.off()
write.csv(allwords,file="output/wordfreq.csv",row.names=FALSE)