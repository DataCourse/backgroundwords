# Empty memory and read the surveys 
# (need to be downloaded from REDCap and stored input/survey.csv)
rm(list=ls())
library(cshapes)
library(latticeExtra)
mysurveys <- read.csv("input/mysurveys.csv", stringsAsFactors=FALSE )

# Plot the counts of survey responses over time
if ("X.record_id" %in% names(mysurveys)) mysurveys$record_id <- mysurveys$X.record_id
mycounts <- mysurveys$record_id
mytimes <- as.POSIXct(mysurveys$presurvey_timestamp)
png(filename="output/surveyresponse.png",width=1280,height=960,res=150)
plot(mytimes,mycounts,type="l",ylim=c(0,6000),lwd=3,xlab="Time (UTC)",
     ylab="# of Survey Responses", xaxs="i", yaxs="i")
abline(h=seq(0,6000,1000),lwd=1)
#abline(h=seq(500,4500,1000),lty="dashed")
abline(v=as.POSIXct("2013-09-11 21:30:00")) #When the survey went out
abline(v=as.POSIXct("2013-09-16 16:00:00"),lty="dashed") #When the course was opened
dev.off()

# Age histogram
png(filename="output/ages.png",width=1200,height=800,res=150)
myages = as.numeric(mysurveys$age)
hist(myages,breaks=seq(0,100,10))
dev.off()


# Country Frequency
png(filename="output/map.png",width=1200,height=600,res=125)
countries <- read.csv(file="countries.csv")
countryFreqs <- data.frame(table(mysurveys$country))
names(countryFreqs)<- c("code","frequency")
countryFreqs <- merge(countryFreqs,countries)
write.csv(countryFreqs,file="output/countryFreq.csv",na="",row.names=FALSE)
cmap <- cshp(date=as.Date("2012-06-30"))
o <- match(cmap@data$ISO1AL3,countryFreqs$iso3)
cmap@data <- cbind(cmap@data,countryFreqs[o,c("iso3","frequency")])
p1 <- spplot(cmap,"frequency", at=c(seq(0,249,10),seq(250,499,50),500,2500),  
             col.regions=c(rainbow(32,start=0,end=0.3,v=0.9))[seq(32,1,-1)],
             lwt=0.25)
print(p1)
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
                                          'into','where', 'these', 'nil', 'both',
                                          'are','don','which','them','what','such',
                                          'their','non'),]
wordcloud(allwords[,1],allwords[,2],scale=c(2,0.5),rot.per=0.1,max.words=300,
          random.order=FALSE,colors=rainbow(20,start=0.25,end=1,v=0.6),random.color=TRUE)
dev.off()
write.csv(allwords,file="output/wordfreq.csv",row.names=FALSE)