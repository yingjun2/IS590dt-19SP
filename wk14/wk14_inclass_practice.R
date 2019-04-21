######################################
# Movielense and Recommender System  #
######################################

library(dplyr)
library(ggplot2)
library(recommenderlab)
library(reshape2)

# Exploratory Data Analysis
# Download the MovieLens 1M Dataset. You’ll find four files: README, movies.dat, ratings.dat, and users.dat. 
# Check the readme file to understand the format of the other three files.
# Load the data into R.

# ratings data
# use colClasses = 'NULL' to skip columns
ratings = read.csv('ratings.dat', sep = ':', 
                   colClasses = c('integer', 'NULL'), header = FALSE)
colnames(ratings) = c('UserID', 'MovieID', 'Rating', 'Timestamp')
dim(ratings) # 1000209-by-4
ratings[1:4, ]

# movies data
# In movies.dat, some movie names contain single colon (:), so the above 
# method does not work. 

movies = readLines('movies.dat')
movies = strsplit(movies, split = "::", fixed = TRUE, useBytes = TRUE)
movies = matrix(unlist(movies), ncol = 3, byrow = TRUE)
movies = data.frame(movies, stringsAsFactors = FALSE)
colnames(movies) = c('MovieID', 'Title', 'Genres')
movies$MovieID = as.integer(movies$MovieID)

# Explore the relationship between movie ratings and movie genres. First, simplify movie genres: multiple genres to ‘Multiple’.

movies$Genres = ifelse(grepl('\\|', movies$Genres), "Multiple", 
                       movies$Genres)

# Then merge ratings and movie datasets.

rating_merged = merge(x = ratings, y = movies, by.x = "MovieID")

# Use ggplot to make a bar graph.

ggplot(rating_merged, aes(x = factor(Genres), y = Rating), 
       color = factor(vs)) + stat_summary(fun.y = mean, position =
                                            position_dodge(), geom = "bar") + labs(x = "Genres", y = "Mean
       ratings", title = "Mean ratings by genres") + theme(axis.text.x =
                                                             element_text(angle = 90, hjust = 1))
## prepare training and test data
ratings$Timestamp = NULL;
colnames(ratings) = c('user', 'movie', 'rating')
set.seed(100)
train.id = sample(nrow(ratings), floor(nrow(ratings)) * 0.6)
train = ratings[train.id, ]
head(train)

test = ratings[-train.id, ]
test.id = sample(nrow(test), floor(nrow(test)) * 0.5)
test = test[test.id, ]
head(test)

label = test[c('user', 'rating')]
test$rating = NULL
head(label)
head(test)

## Recommender System
# We train a recommender system and make prediction on the test data.
# First, create a utility matrix.

R = acast(train, user ~ movie)
R = as(R, 'realRatingMatrix')

# Normalize the utility matrix and visualize data:

R_m = normalize(R)
head(getRatingMatrix(R_m))

# visualize
image(R, main = "Raw Ratings")
image(R_m, main = "Normalized Ratings")

## Learn a recommender. According to recommenderlab: A Framework for Developing and Testing Recommendation Algorithms.
## check paper here: https://cran.r-project.org/web/packages/recommenderlab/vignettes/recommenderlab.pdf

recommenderRegistry$get_entries(dataType = "realRatingMatrix")
rec = Recommender(R, method = 'UBCF',
                  parameter = list(normalize = 'Z-score', method = 'Cosine', nn = 5)
)

# a short summary of the model
print(rec)
names(getModel(rec))

## making prediction

recom = predict(rec, R, type = 'ratings')  # predict ratings. This may be slow.
rec_list = as(recom, 'list')  # each element are ratings of that user

test$rating = NA

# For all lines in test file, one by one
for (u in 1:nrow(test)){
  
  # Read userid and movieid from columns 2 and 3 of test data
  userid = as.character(test$user[u])
  movieid = as.character(test$movie[u])
  
  rating = rec_list[[userid]][movieid]
  # 2.5 may be too arbitrary
  test$rating[u] = ifelse(is.na(rating), 2.5, rating)
}

# write submission file
write.table(test, file = 'myoutput.csv', row.names = FALSE,
            col.names = TRUE, sep = ',')

# other refs: http://rstudio-pubs-static.s3.amazonaws.com/248530_18970dc8eb4046a6b4f2fba987fe2a50.html
