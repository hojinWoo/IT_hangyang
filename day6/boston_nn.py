# -*- coding: utf-8 -*-
"""
Created on Mon May  6 10:10:59 2019

@author: kjw
"""

from keras.datasets import boston_housing
from keras import models
from keras import layers
import numpy as np
import matplotlib.pyplot as plt

num_epochs = 20
bath_size = 1

(train_data, train_targets), (test_data, test_targets) =  boston_housing.load_data()
train_data.shape
test_data.shape
train_targets

# 데이터 준비
mean = train_data.mean(axis=0)
train_data -= mean
std = train_data.std(axis=0)
train_data /= std

test_data -= mean
test_data /= std

val_data = train_data[:100]
partial_train_data = train_data[100:]
val_targets = train_targets[:100]
partial_train_targets = train_targets[100:]

model = models.Sequential()
model.add(layers.Dense(64, activation='relu',
                       input_shape=(train_data.shape[1],)))
model.add(layers.Dense(64, activation='relu'))
model.add(layers.Dense(1))
model.compile(optimizer='rmsprop', loss='mse', metrics=['mae'])

history=model.fit(partial_train_data, partial_train_targets,
              epochs=num_epochs, batch_size=1, verbose=1,validation_data=(val_data,val_targets))

score = model.evaluate(test_data, test_targets, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
print(model.summary())

#graph
train_mae = history.history['mean_absolute_error']
train_loss = history.history['loss']
val_mae = history.history['val_mean_absolute_error']
val_loss = history.history['val_loss']

epochs = range(1, len(train_mae) + 1)

# ‘bo’는 파란색 점을 의미합니다
plt.plot(epochs, train_loss, 'bo', label='Training loss')
# ‘b’는 파란색 실선을 의미합니다
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend()

plt.figure()
plt.plot(epochs, train_mae, 'bo', label='Training MAE')
plt.plot(epochs, val_mae, 'b', label='Validation MAE')
plt.title('Training and validation MAE')
plt.xlabel('Epochs')
plt.ylabel('MAE')
plt.legend()
plt.show()
