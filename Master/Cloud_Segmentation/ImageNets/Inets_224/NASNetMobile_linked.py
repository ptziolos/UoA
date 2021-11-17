import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import NASNetMobile


# # Network Architecture

name = "NASNetMobile_linked"

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
	NASNetMobile_base = NASNetMobile(weights=weights,
			include_top=False,
			input_shape=img_size+(3,))
	
	NASNetMobile_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(NASNetMobile_base.layers):
		if i < 726:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#NASNetMobile_base.summary()
	
	c1 = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=3).output)
	c2_l = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=14).output)
	c2_r = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=15).output)
	c3_l = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=71).output)
	c3_r = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=72).output)
	c4_l = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=308).output)
	c4_r = m.Model(inputs=NASNetMobile_base.input, outputs=NASNetMobile_base.get_layer(index=309).output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = NASNetMobile_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2) # 14
	c4_l_out = c4_l(inputs)
	c4_r_out = c4_r(inputs)
	c4_out = l.Concatenate()([c4_l_out,c4_r_out])
	out_3 = l.Concatenate()([c4_out,out_2])
	out_4 = intra_block_2(out_3, 512, 1, 1)
	out_5 = intra_block_1(out_4, 512, 2, 2) # 28
	c3_l_out = c3_l(inputs)
	c3_r_out = c3_r(inputs)
	c3_out = l.Concatenate()([c3_l_out,c3_r_out])
	out_6 = l.Concatenate()([c3_out,out_5])
	out_7 = intra_block_2(out_6, 512, 1, 1)
	out_8 = intra_block_1(out_7, 256, 2, 2) # 56
	c2_l_out = c2_l(inputs)
	c2_r_out = c2_r(inputs)
	c2_out = l.Concatenate()([c2_l_out,c2_r_out])
	out_9 = l.Concatenate()([c2_out,out_8])
	out_10 = intra_block_2(out_9, 256, 1, 1)
	out_11 = intra_block_1(out_10, 128, 2, 2) 
	out_12 = intra_block_2(out_11, 256, 2, 1) # 111
	c1_out = c1(inputs)
	out_13 = l.Concatenate()([c1_out,out_12])
	out_14 = intra_block_2(out_13, 128, 1, 1)
	out_15 = intra_block_1(out_14, 64, 2, 1)
	out_16 = intra_block_1(out_15, 64, 2, 2) # 224
	outputs = l.Conv2D(1, kernel_size=1)(out_16)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
