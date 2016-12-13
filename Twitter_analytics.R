
library("twitteR")
library("ROAuth")
library(RCurl)
library(tm)
library(wordcloud)
library(RColorBrewer)

setwd("D:/STUDY/R/Text mining/")
getwd()

# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

# Download "cacert.pem" file
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <-  "1yUQtJnIrS70wKZaWHSrdLs8F"
consumerSecret <- "n4rJ0zbs8F0Oyb7k4pK9yTLVEAmLw8tdTp7s2gqr2NQoZY4Fxp"
accessToken <- "131789379-GYDyuJoQSNR84QVlD9FfsubLLfiL5EnxMJbNlgqP"
accessTokenSecret <- "qrDiHd1KU5M0HpHQXotNIsMm9pDmyBUA8DETcTLHpMmMs"

setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)

load("twitter authentication.Rdata")
registerTwitterOAuth(cred)

# Sample queries.
searchTwitter("#beer", n=100)
searchTwitter('patriots', geocode='42.375,-71.1061111,10mi')
searchTwitter('world cup+brazil', resultType="popular", n=15)
searchTwitter('from:hadleywickham', resultType="recent", n=10)

# Lets start with searching for PrayForMH370 .
mh370 <- searchTwitter("PrayForMH370", n = 35)
mh370_text = sapply(mh370, function(x) x$getText())
mh370_corpus = Corpus(VectorSource(mh370_text))

# Making tdm
tdm = TermDocumentMatrix(
  mh370_corpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c("prayformh370", "prayformh", stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
)

m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

# In our wordcloud, there are many Malay stop words. So remove them.
library(XML)
df1 <- readHTMLTable('http://blog.kerul.net/2014/01/list-of-malay-stop-words.html')
df1 <- df1[[1]]
malaystopwords <- as.character(unlist(df1))[-c(320, 321)]
head(malaystopwords)

# Now adding the malaystopwords to the above code.
tdm = TermDocumentMatrix(
  mh370_corpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c("prayformh370", "prayformh", malaystopwords, stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
)

m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

