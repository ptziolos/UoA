import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import NASNetLarge


# # Network Architecture

name = "NASNetLarge_linked"

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
	NASNetLarge_base = NASNetLarge(weights=weights,
			include_top=False,
			input_shape=img_size+(3,))
	
	NASNetLarge_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(NASNetLarge_base.layers):
		if i < 1004:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#NASNetLarge_base.summary()
	
	c1 = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=7).output)
	c2_l = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=14).output)
	c2_r = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=15).output)
	c3_l = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=71).output)
	c3_r = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=72).output)
	c4_l = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=398).output)
	c4_r = m.Model(inputs=NASNetLarge_base.input, outputs=NASNetLarge_base.get_layer(index=399).output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = NASNetLarge_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	out_3 = intra_block_2(out_2, 512, 2, 1) # 21
	c4_l_out = c4_l(inputs)
	c4_r_out = c4_r(inputs)
	c4_out = l.Concatenate()([c4_l_out,c4_r_out])
	out_4 = l.Concatenate()([c4_out,out_3])
	out_5 = intra_block_2(out_4, 512, 1, 1)
	out_6 = intra_block_1(out_5, 512, 2, 2) # 42
	c3_l_out = c3_l(inputs)
	c3_r_out = c3_r(inputs)
	c3_out = l.Concatenate()([c3_l_out,c3_r_out])
	out_7 = l.Concatenate()([c3_out,out_6])
	out_8 = intra_block_2(out_7, 512, 1, 1)
	out_9 = intra_block_1(out_8, 256, 2, 2)
	out_10 = intra_block_2(out_9, 256, 2, 1) # 83
	c2_l_out = c2_l(inputs)
	c2_r_out = c2_r(inputs)
	c2_out = l.Concatenate()([c2_l_out,c2_r_out])
	out_11 = l.Concatenate()([c2_out,out_10])
	out_12 = intra_block_2(out_11, 256, 1, 1)
	out_13 = intra_block_1(out_12, 128, 2, 2)
	out_14 = intra_block_2(out_13, 128, 2, 1) # 165
	c1_out = c1(inputs)
	out_15 = l.Concatenate()([c1_out,out_14])
	out_16 = intra_block_2(out_15, 128, 1, 1)
	out_17 = intra_block_1(out_16, 64, 2, 2)
	out_18 = intra_block_1(out_17, 64, 2, 1) # 331
	outputs = l.Conv2D(1, kernel_size=1)(out_18)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
