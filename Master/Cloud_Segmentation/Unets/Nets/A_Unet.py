import tensorflow as tf
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a


# Network Architecture

name = "A_Unet"

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
	out_2 = conv_unit(out_1, 2*f, k2, s2, p='valid')
	return out_1, out_2

def intra_block_2(inputs, f, k1, s1, k2, s2):
	out_1 = single_block(inputs, f, k1, s1)
	out_2 = l.Conv2DTranspose(filters=f/2, kernel_size=k2, strides=s2)(out_1)
	out_2 = l.BatchNormalization()(out_2)
	out_2 = l.Activation('gelu')(out_2)
	return out_1, out_2

def attention_block(x, y, f, k):
	out_1 = conv_unit(x, 1, k, 2, p='valid')
	out_2 = conv_unit(y, 1, k, 1, d=(3,3))
	out_3 = l.add([out_1,out_2])
	out_3 = l.BatchNormalization()(out_3)
	out_3 = l.Conv2D(filters=1, kernel_size=1, padding='same')(out_3)
	out_3 = l.BatchNormalization()(out_3)
	out_3 = l.Conv2DTranspose(filters=1, kernel_size=k, strides=2)(out_3)
	out_3 = l.BatchNormalization()(out_3)
	out_3 = l.Activation('sigmoid')(out_3)
	out_4 = l.GlobalMaxPool2D()(x)
	out_4 = l.Reshape((1,1,out_4.shape[-1]))(out_4)
	out_5 = l.GlobalAveragePooling2D()(x)
	out_5 = l.Reshape((1,1,out_5.shape[-1]))(out_5)
	out_9 = l.Concatenate(axis=1)([out_4,out_5])
	out_11 = l.Conv2D(filters=f, kernel_size=(2,1), strides=2)(out_9)
	out_7 = l.GlobalMaxPool2D()(y)
	out_7 = l.Reshape((1,1,out_7.shape[-1]))(out_7)
	out_8 = l.GlobalAveragePooling2D()(y)
	out_8 = l.Reshape((1,1,out_8.shape[-1]))(out_8)
	out_10 = l.Concatenate(axis=1)([out_7,out_8])
	out_12 = l.Conv2D(filters=f, kernel_size=(2,1), strides=2)(out_10)
	out_13 = l.Concatenate()([out_11,out_12])
	out_13 = l.Conv2D(filters=f, kernel_size=1)(out_13)
	out_13 = l.Activation('sigmoid')(out_13)
	out = l.multiply([out_3,out_13])
	out = conv_unit(out, f, 1, 1)
	return out

def create_model(img_size):
	inputs = tf.keras.Input(shape=(img_size + (3,)))
	(out_1,out_2) = intra_block_1(inputs, 16, 3, 1, 2, 2)
	(out_3,out_4) = intra_block_1(out_2, 32, 3, 1, 2, 2)
	(out_5,out_6) = intra_block_1(out_4, 64, 3, 1, 3, 2)
	(out_7,out_8) = intra_block_1(out_6, 128, 3, 1, 3, 2)
	(out_9,out_10) = intra_block_2(out_8, 256, 3, 1, 3, 2)
	out_11 = attention_block(out_7, out_9, 128, 3)
	out_12 = l.Concatenate()([out_10,out_11])
	(out_13,out_14) = intra_block_2(out_12, 128, 3, 1, 3, 2)
	out_15 = attention_block(out_5, out_13, 64, 3)
	out_16 = l.Concatenate()([out_14,out_15])
	(out_17,out_18) = intra_block_2(out_16, 64, 3, 1, 2, 2)
	out_19 = attention_block(out_3, out_17, 32, 2)
	out_20 = l.Concatenate()([out_18,out_19])
	(out_21,out_22) = intra_block_2(out_20, 32, 3, 1, 2, 2)
	out_23 = attention_block(out_1, out_21, 16, 2)
	out_24 = l.Concatenate()([out_22,out_23])
	out_25 = single_block(out_24, 16, 2, 1)
	outputs = l.Conv2D(1, kernel_size=1, activation='sigmoid')(out_25)
	model = tf.keras.Model(inputs,outputs)
	return model
