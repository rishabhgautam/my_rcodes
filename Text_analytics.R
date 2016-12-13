
# Text Mining.

setwd("D:/STUDY/R/Text mining/data/textmining")
getwd()

library(tm)           # Framework for text mining.
library(qdap)         # Quantitative discourse analysis of transcripts.
library(qdapDictionaries)
library(dplyr)        # Data wrangling, pipe operator %>%().
library(RColorBrewer) # Generate palette of colours for plots.
library(ggplot2)      # Plot word frequencies.
library(scales)       # Include commas in numbers.
library(Rgraphviz)    # Correlation plots.
library(SnowballC)

docs <- Corpus(DirSource("D:/STUDY/R/Text mining/data/textmining"))


# In case, we have pdf/doc documents. convert them to txt using this.
docs <- Corpus(DirSource(cname), readerControl=list(reader=readPDF))
docs <- Corpus(DirSource(cname), readerControl=list(reader=readDOC))

#inspect a particular document
writeLines(as.character(docs[[30]]))

# Pre processing.
getTransformations()

#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) 
  {
  return (gsub(pattern, " ", x))
  })

docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")

#Remove punctuation - replace punctuation marks with " "
docs <- tm_map(docs, removePunctuation)

docs <- tm_map(docs, toSpace, "'")
docs <- tm_map(docs, toSpace, "'")
docs <- tm_map(docs, toSpace, " -")

#Transform to lower case (need to wrap in content_transformer)
docs <- tm_map(docs,content_transformer(tolower))

#Strip digits (std transformation, so no need for content_transformer)
docs <- tm_map(docs, removeNumbers) 

#remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords("english"))

#Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)

# Remove Own Stop Words
docs <- tm_map(docs, removeWords, c("department", "email"))

# Stemming
writeLines(as.character(docs[[30]]))

#Stem document
docs <- tm_map(docs,stemDocument)
writeLines(as.character(docs[[30]]))


# Specific Transformations
toString <- content_transformer(function(x, from, to) gsub(from, to, x))
docs <- tm_map(docs, toString, "harbin institute technology", "HIT")
docs <- tm_map(docs, toString, "shenzhen institutes advanced technology", "SIAT")
docs <- tm_map(docs, toString, "chinese academy sciences", "CAS")

docs <- tm_map(docs, content_transformer(gsub), pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer(gsub), pattern = "organis", replacement = "organ")
docs <- tm_map(docs, content_transformer(gsub), pattern = "andgovern", replacement = "govern")
docs <- tm_map(docs, content_transformer(gsub), pattern = "inenterpris", replacement = "enterpris")
docs <- tm_map(docs, content_transformer(gsub), pattern = "team-", replacement = "team")

# document term matrix(DTM)- 
# matrix that lists all occurrences of words in the corpus, by document
dtm <- DocumentTermMatrix(docs)

inspect(dtm[1:2,1000:1005])

# Mining the corpus
freq <- colSums(as.matrix(dtm))
length(freq)

#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

#inspect most frequently occurring terms
freq[head(ord)]

#inspect least frequently occurring terms
freq[tail(ord)]


# Removing Sparse Terms
dim(dtm)
dtms <- removeSparseTerms(dtm, 0.1)
dim(dtms)
inspect(dtms)

# Here we are telling R to include only those words that occur in  
# 3 to 27 documents. We have also enforced lower and upper limit to 
# length of the words included (between 4 and 20 characters).
dtmr <-DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20),
                      bounds = list(global = c(3,27))))

freqr <- colSums(as.matrix(dtmr))
#length should be total number of terms
length(freqr)

#create sort order (asc)
ordr <- order(freqr,decreasing=TRUE)

#inspect most frequently occurring terms
freqr[head(ordr)]

#inspect least frequently occurring terms
freqr[tail(ordr)]

# return all the words which occur more than 80 times.
findFreqTerms(dtmr,lowfreq=80)

# correlation is a quantitative measure of the co-occurrence 
# of words in multiple documents.
findAssocs(dtmr,"project",0.6)

findAssocs(dtmr,"enterpris",0.6)

# Frequency histogram.
wf=data.frame(term=names(freqr),occurrences=freqr)
p <- ggplot(subset(wf, freqr>100), aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# Creating the wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(42)
#limit words by specifying min frequency
wordcloud(names(freqr),freqr, min.freq=50)
# Reducing Clutter With Max Words.
set.seed(142)
wordcloud(names(freqr), freq, max.words=100)

#.add color
wordcloud(names(freqr),freqr,min.freq=70,colors=brewer.pal(6,"Dark2"))


