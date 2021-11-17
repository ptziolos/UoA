import tensorflow as tf
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import EfficientNetB6


# # Network Architecture

name = "EfficientNetB6"

def intra_block_1(inputs, f, k1, s1):
	out = l.Conv2DTranspose(filters=f, kernel_size=k1, strides=s1)(inputs)
	out = l.BatchNormalization()(out)
	out = l.Activation('gelu')(out)
	return out
  
def intra_block_2(inputs, f, k1, s1):
	out = l.Conv2D(filters=f, kernel_size=k1, strides=s1)(inputs)
	out = l.BatchNormalization()(out)
	out = l.Activation('gelu')(out)
	return out
  
def create_model(img_size, weights, state):
	EfficientNetB6_base = EfficientNetB6(weights=weights,
			include_top=False,
			input_shape=img_size+(3,))
	
	EfficientNetB6_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(EfficientNetB6_base.layers):
		if i < 648:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#EfficientNetB6_base.summary()
	
# Network
	inputs = tf.keras.Input(shape=(img_size + (3,)))
	out_1 = EfficientNetB6_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	out_3 = intra_block_1(out_2, 512, 2, 2)
	out_4 = intra_block_1(out_3, 256, 2, 2)
	out_5 = intra_block_1(out_4, 128, 2, 2)
	out_6 = intra_block_1(out_5, 64, 2, 2)
	outputs = l.Conv2D(1, kernel_size=1)(out_6)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
