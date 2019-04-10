####################
## input file to generate wordcloud
def show_wordcloud(data, title=None):
    wordcloud = WordCloud(
        background_color='white',
        stopwords=stopwords,
        max_words=200,
        max_font_size=40,
        random_state=3
    ).generate(str(data))

    # fig = plt.figure(1, figsize=(12, 12))
    fig = plt.figure(1)
    plt.axis('off')
    if title:
        fig.suptitle(title, fontsize=20)
        # fig.subplots_adjust(top=2.3)

    plt.imshow(wordcloud)
    plt.savefig('wordcloud.png')
    plt.show()

from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
stopwords = set(STOPWORDS)


f = open("Declaration of Independence.txt", "r")
text = f.readline()
# print(f.readlines())
f.close()

show_wordcloud(text, title='Declaration of Independence')



#####################
## other online tools for making the wordcloud
# https://worditout.com/word-cloud/create
# https://minimaxir.com/2016/05/wordclouds/




#####################
## wordcloud from dictionary
d = {'will':3, 'free':9,'people':4,'the':0,'independence':5}
import matplotlib.pyplot as plt
from wordcloud import WordCloud

wordcloud = WordCloud()
wordcloud.generate_from_frequencies(frequencies=d)
plt.figure()
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.show()

#######################
## examples of tf-idf calculation
from sklearn.feature_extraction.text import TfidfVectorizer
docA = "The car is driven on the road"
docB = "The truck is driven on the highway"
tfidf = TfidfVectorizer()
response = tfidf.fit_transform([docA, docB])
feature_names = tfidf.get_feature_names()
for col in response.nonzero()[1]:
    print(feature_names[col], ' - ', response[0, col])

d_s1={}
for col in response.nonzero()[1]:
    d_s1[feature_names[col]] = response[0, col]

print(d_s1)
