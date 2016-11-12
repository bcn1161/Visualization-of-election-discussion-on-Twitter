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


#topic
#military: military, army, soldier, war, troop
pMilitary <- "military|army|soldier|war|troop"
#Economy
pEconomy <- "economy|job|wage|tax|income|debt|loan|employment|trade|import|export|tpp|tpa|business|economic|financial|finance"
#Immigration
pImmi <- "immigrant|legislation|refugee|border|citizen|immigration|citizenship|resident|deport"
#Health Care
pHealth <- "insurance|medical|obamacare|afford|health|medicare|hospital|affordable|medicine"
#Gun control: gun, second amendment, arms, constitution, weapons
pGun <- "gun|amendment|arms|constitution|weapon|violence"
#Race/Ethnicity: African Americans, Hispanic, Middle Eastern, Black, race
pRace <- "African|Hispanic|Middle Eastern|Black|race|white|Latinos|racist|racism|Jew|Jewish|#compaignzero|#blacklivesmatter"
#Gender/Sex
pGender <- "gender|sex|women|sexist|sexism|gay|homosexual|women's rights|same sex|samesex|misogyny|misogynist|chauvinist"
#Climate change: global warming, climate change, environment, sea level, emissions, fossil
pClimate <- "warming|climate|environment|sea|emission|fossil"
#religion: islam, islamic, christian, muslim, God
pReligion <- "islam|religion|christian|muslim|God|islamic|abortion"
#International politics
pInt <- "Arabic|isarel|palestine|foreign|syria|Arab|Africa|Asian|Taiwan|African|Germany|France|German|French|Brussels|Belgium|China|Asia|Chinese|human rights|cyber|beijing|European|Europe|Middle East|Iran|North Korea|ISIS|Iraq|afghanistan"
#verbal attack
pVer <- "idiot|fraud|dumbass|puppet|ignorant|dickhead|dick|suck|fake|disgusting|criminal|crook|sociopath|insance|mad|stupid|fuck|damn|bitch|fucking|ass|retard|hate|hell|loser|asshole|scum|sexist|sexism|puke"
#Election News
pElec <- "USA Today|supertuesday|CBS|hillaryemails|election2016|compaign|wikileaks|turnout|vote|republican|democrat|voter|partisan|nytimes|newsroom|nomination|delegate|TIME magazine|beat|speech|endorse|poll|predictions|caucus|primary|primaries|CNN|result|win|lose|lost|loses|wins|won|election|debate|Bloomberg|NY Times|Fox|New York Times"
#show support
pSupport <- "feelthebern|nevertrump|bernie2016|hillary2016|neverclinton|neverhillary|neversanders|wethepeople|bern|makeamericagreatagain|unitewithcruz|congratulation|politicalrevolution|we just won|alwaystrump|hillary2016|birdiesanders|alwaysclinton|neverclinton|keepmovingforward|sanders2016|trump2016|clinton2016|cruz2016|notcruz|notclinton|nottrump|notsanders|politicalstreetart|stillsanders|sandersorbust"

#by topic
tweets$topic <- ifelse(grepl(pMilitary,tweets$text, ignore.case = T) == T , "military", 
                       ifelse(grepl(pSupport,tweets$text,ignore.case = T) == T, "support",
                              ifelse(grepl(pInt,tweets$text,ignore.case = T) == T, "international",
                  ifelse(grepl(pEconomy,tweets$text,ignore.case = T) == T, "economy",
                         ifelse(grepl(pVer,tweets$text,ignore.case = T) == T, "verbalattack",
                                ifelse(grepl(pElec,tweets$text,ignore.case = T) == T, "election",
                         ifelse(grepl(pReligion,tweets$text,ignore.case = T) == T, "religion",
                                ifelse(grepl(pImmi,tweets$text,ignore.case = T) == T, "immigration",
                                       ifelse(grepl(pHealth,tweets$text,ignore.case = T) == T, "healthcare",
                                              ifelse(grepl(pGun,tweets$text,ignore.case = T) == T, "guncontrol",
                                                     ifelse(grepl(pGender,tweets$text,ignore.case = T) == T, "gender",
                                                            
                                                                   ifelse(grepl(pRace,tweets$text,ignore.case = T) == T, "race",
                                                                          ifelse(grepl(pClimate,tweets$text,ignore.case = T) == T, "climatechange","NA")))))))))))))




#sentiment analysis
lexicon <- read.csv("lexicon.csv", stringsAsFactors=F)
pos.words <- lexicon$word[lexicon$polarity=="positive"]
neg.words <- lexicon$word[lexicon$polarity=="negative"]

clean_tweets <- function(text){
  # loading required packages
  lapply(c("tm", "Rstem", "stringr"), require, c=T, q=T)
  # avoid encoding issues by dropping non-unicode characters
  utf8text <- iconv(text, to='UTF-8-MAC', sub = "byte")
  # remove punctuation and convert to lower case
  words <- removePunctuation(utf8text)
  words <- tolower(words)
  # spliting in words
  words <- str_split(words, " ")
  return(words)
}

text <- clean_tweets(s$text)


classify <- function(words, pos.words, neg.words){
  # count number of positive and negative word matches
  pos.matches <- sum(words %in% pos.words)
  neg.matches <- sum(words %in% neg.words)
  return(pos.matches - neg.matches)
}


s$score <- unlist(lapply(text, classify, pos.words, neg.words))

