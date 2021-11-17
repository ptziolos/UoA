import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import EfficientNetB4


# # Network Architecture

name = "EfficientNetB4"

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
  
def create_model(img_size, state):
	EfficientNetB4_base = EfficientNetB4(weights="imagenet",
			include_top=False,
			input_shape=img_size+(3,))
	
	EfficientNetB4_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(EfficientNetB4_base.layers):
		if i < 456:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#EfficientNetB4_base.summary()
	
	c1 = m.Model(inputs=EfficientNetB4_base.input, outputs=EfficientNetB4_base.get_layer('block2a_expand_activation').output)
	c2 = m.Model(inputs=EfficientNetB4_base.input, outputs=EfficientNetB4_base.get_layer('block3a_expand_activation').output)
	c3 = m.Model(inputs=EfficientNetB4_base.input, outputs=EfficientNetB4_base.get_layer('block4a_expand_activation').output)
	c4 = m.Model(inputs=EfficientNetB4_base.input, outputs=EfficientNetB4_base.get_layer('block6a_expand_activation').output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = EfficientNetB4_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	out_3 = intra_block_2(out_2, 512, 2, 1)
	c4_out = c4(inputs)
	out_4 = l.Concatenate()([c4_out,out_3])
	out_5 = intra_block_1(out_4, 512, 2, 2)
	c3_out = c3(inputs)
	out_6 = l.Concatenate()([c3_out,out_5])
	out_7 = intra_block_1(out_6, 256, 2, 2)
	out_8 = intra_block_2(out_7, 256, 2, 1)
	c2_out = c2(inputs)
	out_9 = l.Concatenate()([c2_out,out_8])
	out_10 = intra_block_1(out_9, 128, 2, 2)
	c1_out = c1(inputs)
	out_11 = l.Concatenate()([c1_out,out_10])
	out_12 = intra_block_1(out_11, 64, 2, 2)
	outputs = l.Conv2D(1, kernel_size=1)(out_12)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
