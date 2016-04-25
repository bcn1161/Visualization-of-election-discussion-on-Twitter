library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "(your conumser key here)"
consumerSecret <- "(your consumer secret here)"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")
library(streamR)
load("~/my_oauth.Rdata")
filterStream("tweet.json", track = c("bernie","sanders", "hillary", "clinton", "o'malley"), timeout = 6000, oauth = my_oauth)
tweets.df <- parseTweets("tweets.json", simplify = TRUE)
length(grep("bernie sanders",   tweets.df$text, ignore.case = TRUE))
length(grep("halliary clinton", tweets.df$text, ignore.case = TRUE))
