# Koia Game Jam 2022
 
#### sources

I used TangentFoxy's Markov chain generator implementation for generating my text: https://github.com/TangentFoxy/Markov

For OOP in Love2D I used 30log: https://github.com/Yonaba/30log

I grabbed a few datasets of text from the TweetEval github: https://github.com/cardiffnlp/tweeteval/tree/main/datasets

These were the training text from the "hate" and "offensive" Tweet categories. I removed a few hashtags, @user calls and censored especially egregious slurs that I didn't want in my game. I also changed references to Tweets and Twitter.

I also used the HappyDB dataset to try and "fix" hateful text. https://www.kaggle.com/datasets/ritresearch/happydb

For procedural sound effects I used sfxrlua. https://github.com/nucular/sfxrlua

I knew I wanted a bunch of silly sliders and buttons and things so I grabbed SUIT, the Simple User Interface Toolkit. https://github.com/vrld/SUIT