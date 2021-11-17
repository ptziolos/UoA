import tensorflow as tf
from tensorflow.keras import layers as l
from tensorflow.keras import regularizers as r
from tensorflow.keras import activations as a


# Network Architecture of Unet

name = "Unet"

def conv_unit(inputs, f, k, s, d=(1,1), p='same'):
  out = l.Conv2D(filters=f, kernel_size=k, strides=s, dilation_rate=d, padding=p)(inputs)
  out = l.BatchNormalization()(out)
  out = l.Activation('gelu')(out)
  return out

def single_block(inputs, f, k, s, d=(3,3)):
  out = conv_unit(inputs, f, k, s, d)
  out = conv_unit(out, f, k, s, d)
  return out

def intra_block_1(inputs, f, k1, s1, k2, s2):
  out_1 = single_block(inputs, f, k1, s1)
  out_2 = conv_unit(out_1, f, k2, s2, p='valid')
  return out_1, out_2

def intra_block_2(inputs, f, k1, s1, k2, s2):
  out = single_block(inputs, f, k1, s1)
  out = l.Conv2DTranspose(filters=f/2, kernel_size=k2, strides=s2)(out)
  out = l.BatchNormalization()(out)
  out = l.Activation('gelu')(out)
  return out

def create_model(img_size):
  inputs = tf.keras.Input(shape=(img_size + (3,)))
  (out_1,out_2) = intra_block_1(inputs, 16, 3, 1, 2, 2)
  (out_3,out_4) = intra_block_1(out_2, 32, 3, 1, 2, 2)
  (out_5,out_6) = intra_block_1(out_4, 64, 3, 1, 3, 2)
  (out_7,out_8) = intra_block_1(out_6, 128, 3, 1, 3, 2)
  out_9 = intra_block_2(out_8, 256, 3, 1, 3, 2)
  out_10 = l.Concatenate()([out_7,out_9])
  out_11 = intra_block_2(out_10, 128, 3, 1, 3, 2)
  out_12 = l.Concatenate()([out_5,out_11])
  out_13 = intra_block_2(out_12, 64, 3, 1, 2, 2)
  out_14 = l.Concatenate()([out_3,out_13])
  out_15 = intra_block_2(out_14, 32, 3, 1, 2, 2)
  out_16 = l.Concatenate()([out_1,out_15])
  out_17 = single_block(out_16, 16, 2, 1)
  outputs = l.Conv2D(1, kernel_size=1, activation='sigmoid')(out_17)
  model = tf.keras.Model(inputs,outputs)
  return model
