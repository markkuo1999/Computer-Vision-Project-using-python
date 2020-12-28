#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

__author__ = 'maxim'

import numpy as np
import gensim
import string
from keras.callbacks import LambdaCallback
from keras.layers.recurrent import LSTM
from keras.layers.embeddings import Embedding
from keras.layers import Dense, Activation
from keras.models import Sequential

print('\nFetching the text...')

with open ('WholeStory.txt', "r", encoding='utf-8') as f:
    docs = f.readlines()    
   
print('\nPreparing the sentences...')
max_sentence_len = 40
'''處理text文件，以空白格分開各個單字'''
sentences = [[word for word in doc.translate(string.punctuation).split()[:max_sentence_len]] for doc in docs]
print('Num sentences:', len(sentences))
print('\nTraining word2vec...')
'''建立word2vec模型，將剛才處理完的所有單字丟入模型'''
word_model = gensim.models.Word2Vec(sentences, size=100, min_count=1, window=5, iter=10)
pretrained_weights = word_model.wv.syn0
vocab_size, emdedding_size = pretrained_weights.shape
print('Result embedding shape:', pretrained_weights.shape)


def word2idx(word):
  return word_model.wv.vocab[word].index
def idx2word(idx):
  return word_model.wv.index2word[idx]
print('\nPreparing the data for LSTM...')
'''訓練素材'''
train_x = np.zeros([len(sentences), max_sentence_len], dtype=np.int32)
train_y = np.zeros([len(sentences)], dtype=np.int32)
for i, sentence in enumerate(sentences):
  for t, word in enumerate(sentence[:-1]):
    train_x[i, t] = word2idx(word)
  train_y[i] = word2idx(sentence[-1])
print('train_x shape:', train_x.shape)
print('train_y shape:', train_y.shape)


print('\nTraining LSTM...')
model = Sequential()
model.add(Embedding(input_dim=vocab_size, output_dim=emdedding_size, weights=[pretrained_weights]))
model.add(LSTM(units=emdedding_size))
model.add(Dense(units=vocab_size))
'''使用softmax演算法'''
model.add(Activation('softmax'))
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy')

'''預測演算法'''
def sample(preds, temperature=1.0):
  if temperature <= 0:
    return np.argmax(preds)
  preds = np.asarray(preds).astype('float64')
  preds = np.log(preds) / temperature
  exp_preds = np.exp(preds)
  preds = exp_preds / np.sum(exp_preds)
  probas = np.random.multinomial(1, preds, 1)
  return np.argmax(probas)
'''產生下一個字'''
def generate_next(text, num_generated=200):
  word_idxs = [word2idx(word) for word in text.split()]
  for i in range(num_generated):
    prediction = model.predict(x=np.array(word_idxs))
    idx = sample(prediction[-1], temperature=0.7)
    word_idxs.append(idx)
  return ' '.join(idx2word(idx) for idx in word_idxs)

def on_epoch_end(epoch, _):
  print('\nGenerating text after epoch: %d' % epoch)
  texts = [
   'sleep', 'street', 'and'
  ]
  for text in texts:
    sample = generate_next(text)
    print('%s... -> %s' % (text, sample))
'''執行訓練成果'''
model.fit(train_x, train_y,
          batch_size=128,
          epochs=3,
          callbacks=[LambdaCallback(on_epoch_end=on_epoch_end)])