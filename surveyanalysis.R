# Empty memory and read the surveys 
# (need to be downloaded from REDCap and stored input/survey.csv)
rm(list=ls())
library(cshapes)
library(latticeExtra)
mysurveys <- read.csv("input/mysurveys.csv", stringsAsFactors=FALSE )
mytimes <- as.POSIXct(mysurveys$presurvey_timestamp)
mystart <- as.POSIXct("2013-01-01")
myend <- as.POSIXct("2015-01-31")
mysurveys<-mysurveys[mytimes>=mystart & mytimes<=myend,]

# Plot the counts of survey responses over time
if ("X.record_id" %in% names(mysurveys)) mysurveys$record_id <- mysurveys$X.record_id
# mycounts <- mysurveys$record_id # no more using survey id from REDCap
mycounts <- seq(1,nrow(mysurveys))
mytimes <- as.POSIXct(mysurveys$presurvey_timestamp)
png(filename="output/surveyresponse.png",width=1280,height=960,res=150)
plot(mytimes,mycounts,type="l",ylim=c(0,15000),lwd=3,xlab="Time (UTC)",
     ylab="# of Survey Responses", xaxs="i", yaxs="i")
abline(h=seq(0,15000,1000),lwd=1)
abline(v=as.POSIXct("2013-09-11 21:30:00")) #When the survey went out
abline(v=as.POSIXct("2013-09-16 15:00:00"),lty="dashed") #When the session 001 was opened
abline(v=as.POSIXct("2014-06-02 13:00:00"),lty="dashed") #When the session 002 was opened
abline(v=as.POSIXct("2014-10-27 13:00:00"),lty="dashed") #When the session 003 was opened
dev.off()
print("Made survey responses over time")

# Age histogram
png(filename="output/ages.png",width=1200,height=800,res=150)
myages = as.numeric(mysurveys$age)
myages<-myages[myages>0 & myages<100]
maintext = paste(c("Age of Survey Respondents\n(N=",dim(mysurveys)[1],")"),collapse="")
hist(myages,breaks=seq(0,100,5),main=maintext,
     xlab="Age (years)", ylab="Number of Responses", col="blue", 
     border="white")
dev.off()
print("Made age distribution")

# How did they find out about the course
png(file="output/howfound.png",width=1200,height=600,res=150)
myfoundout = c(
  sum(mysurveys$found_out___1),
  sum(mysurveys$found_out___2),
  sum(mysurveys$found_out___3),
  sum(mysurveys$found_out___4),
  sum(mysurveys$found_out___5),
  sum(mysurveys$found_out___6),
  sum(mysurveys$found_out___7)
)
names(myfoundout) <- c(
  "Coursera website","Press Coverage",
  "Vanderbilt University Publicity", "Friend/Colleague",
  "Search Engine", "From the REDCap consortium", "Other"
  )
par(mar=c(2,13,2,1))
barplot(sort(myfoundout), horiz=TRUE, las=1, 
        main='"How did you find out about this course?"', 
        xlim=c(0,max(myfoundout)+499),col="black",border="white")
dev.off()
print("Made how found")

# Education Level
png(file="output/education.png",width=1200,height=600,res=150)
edulabels = c(
  "Junior high / middle school or less",
  "Some high school",
  "High school graduate",
  "Postsecondary school other than college",
  "Some college",
  "College degree",
  "Some graduate school",
  "Graduate degree"
)
myeducations <- factor( mysurveys$highest_education , labels=edulabels)
par(mar=c(2,17,2,1))
plot(myeducations,horiz=TRUE,las=1,col="black",border="white",
     main="Education Level",,xlim=c(0,max(table(myeducations))+499))
dev.off()
print("Made education level")

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
p1 <- spplot(cmap,"frequency", at=c(seq(0,249,10),seq(250,499,50),seq(500,999,100),seq(1000,5000,1000)),  
             col.regions=c(rainbow(40,start=0,end=0.3,v=0.9))[seq(40,1,-1)],
             lwt=0.25, colorkey=FALSE)
print(p1)
dev.off()
print("Made country maps")

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
print("Made word cloud")
