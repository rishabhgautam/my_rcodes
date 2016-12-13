
#Required packages
install.packages("twitteR")
install.packages("RCurl")
install.packages("devtools")
library(twitteR)
library(sentimentr)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
require(devtools)
require(sentimentr)

#Steps to get a Twitter Consumer Key and Consumer Secret key
#1.	Go to https://dev.twitter.com/apps/new and log in, if necessary
#2.	Supply the necessary required fields and submit the form.
#3.	Go to the API Keys tab, there one can find Consumer key and Consumer secret keys.
#4.	Copy the consumer key (API key) and consumer secret.

#Set Twitter Developer Account Details
consumer_key <- "goWrJ9Jvs0WzSXHmEtOWccL4r"
consumer_secret <- "VdjMiPPyBamj4ijvMBvXo1j0ErKhQsYiOl3uUqL7Th9hNrrhsB"
access_token <- "131789379-tl1TE7gcwqgWPAUD9hXpAiN8rJcytgWEeZMpTj1k"
access_secret <- "HH5xUEgYALu0H5MZ7BqZycBPk2nvZd8moGUCrJy5QAGCO"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#Fetch Tweets
my_tweets <- searchTwitter("#westernunion", n=5000, lang="en")
my_tweets

# get the text
my_txt = sapply(my_tweets, function(x) x$getText())
# remove retweet entities
my_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", my_txt)
# remove at people
my_txt = gsub("@\\w+", "", my_txt)
# remove punctuation
my_txt = gsub("[[:punct:]]", "", my_txt)
# remove numbers
my_txt = gsub("[[:digit:]]", "", my_txt)
# remove html links
my_txt = gsub("http\\w+", "", my_txt)
# remove unnecessary spaces
my_txt = gsub("[ \t]{2,}", "", my_txt)
my_txt = gsub("^\\s+|\\s+$", "", my_txt)

# define "tolower error handling" function 
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  # result
  return(y)
}
# lower case using try.error with sapply 
my_txt = sapply(my_txt, try.error)

# remove NAs in my_txt
my_txt = my_txt[!is.na(my_txt)]
names(my_txt) = NULL

# classify emotion
class_emo = classify_emotion(my_txt, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"


# classify polarity
class_pol = classify_polarity(my_txt, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

#data frame with results
sent_df = data.frame(text=my_txt, emotion=emotion, polarity=polarity, stringsAsFactors=FALSE)

# sort data frame
sent_df = within(sent_df,
                 emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))

# plot distribution of emotions
ggplot(sent_df, aes(x=emotion)) +
  geom_bar(aes(y=..count.., fill=emotion)) +
  scale_fill_brewer(palette="Dark2") +
  labs(x="emotion categories", y="number of tweets") +
  theme(plot.title = element_text(size=12))

# plot distribution of polarity

ggplot(sent_df, aes(x=polarity)) +
  geom_bar(aes(y=..count.., fill=polarity)) +
  scale_fill_brewer(palette="RdGy") +
  labs(x="polarity categories", y="number of tweets") +
  theme(plot.title = element_text(size=12))


# separating text by emotion

emos = levels(factor(sent_df$emotion))
nemo = length(emos)
emo.docs = rep("", nemo)
for (i in 1:nemo)
{
  tmp = my_txt[emotion == emos[i]]
  emo.docs[i] = paste(tmp, collapse=" ")
}


# remove stopwords

emo.docs = removeWords(emo.docs, stopwords("english"))

# create corpus

corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = emos


R-Code for Word Cloud

comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                 scale = c(3,.5), random.order = FALSE, title.size = 1.5)


