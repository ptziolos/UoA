import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import Xception


# # Network Architecture

name = "Xception_linked"

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
	Xception_base = Xception(weights="imagenet",
			include_top=False,
			input_shape=img_size+(3,))
	
	Xception_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(Xception_base.layers):
		if i < 126:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	Xception_base.summary()
	
	c1 = m.Model(inputs=Xception_base.input, outputs=Xception_base.get_layer('block1_conv1_act').output)
	c2 = m.Model(inputs=Xception_base.input, outputs=Xception_base.get_layer('block1_conv2_act').output)
	c3 = m.Model(inputs=Xception_base.input, outputs=Xception_base.get_layer(index=15).output)
	c4 = m.Model(inputs=Xception_base.input, outputs=Xception_base.get_layer(index=25).output)
	c5 = m.Model(inputs=Xception_base.input, outputs=Xception_base.get_layer(index=35).output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = Xception_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	out_3 = intra_block_2(out_2, 512, 2, 1) # 19
	c5_out = c5(inputs)
	out_4 = l.Concatenate()([c5_out,out_3])
	out_5 = intra_block_2(out_4, 512, 1, 1)
	out_6 = intra_block_1(out_5, 512, 2, 2) 
	out_7 = intra_block_2(out_6, 512, 2, 1) # 37
	c4_out = c4(inputs)
	out_8 = l.Concatenate()([c4_out,out_7])
	out_9 = intra_block_2(out_8, 512, 1, 1)
	out_10 = intra_block_1(out_9, 256, 2, 2) # 74
	c3_out = c3(inputs)
	out_11 = l.Concatenate()([c3_out,out_10])
	out_12 = intra_block_2(out_11, 256, 1, 1)
	out_13 = intra_block_1(out_12, 128, 2, 2)
	out_14 = intra_block_2(out_13, 128, 2, 1) # 147
	c2_out = c2(inputs)
	out_15 = l.Concatenate()([c2_out,out_14])
	out_16 = intra_block_2(out_15, 128, 1, 1)
	out_17 = intra_block_1(out_16, 128, 3, 1)
	c1_out = c1(inputs)
	out_18 = l.Concatenate()([c1_out,out_17])
	out_19 = intra_block_1(out_18, 64, 4, 2) # 300
	outputs = l.Conv2D(1, kernel_size=1)(out_19)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
