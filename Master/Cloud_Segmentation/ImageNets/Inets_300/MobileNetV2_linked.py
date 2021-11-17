import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import MobileNetV2


# # Network Architecture

name = "MobileNetV2_linked"

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
	MobileNetV2_base = MobileNetV2(weights="imagenet",
			include_top=False,
			input_shape=img_size+(3,))
	
	MobileNetV2_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(MobileNetV2_base.layers):
		if i < 133:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	MobileNetV2_base.summary()
	
	c1 = m.Model(inputs=MobileNetV2_base.input, outputs=MobileNetV2_base.get_layer('Conv1_relu').output)
	c2 = m.Model(inputs=MobileNetV2_base.input, outputs=MobileNetV2_base.get_layer('block_1_depthwise_relu').output)
	c3 = m.Model(inputs=MobileNetV2_base.input, outputs=MobileNetV2_base.get_layer('block_3_depthwise_relu').output)
	c4 = m.Model(inputs=MobileNetV2_base.input, outputs=MobileNetV2_base.get_layer('block_6_depthwise_relu').output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = MobileNetV2_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	out_3 = intra_block_2(out_2, 512, 2, 1) # 19
	c4_out = c4(inputs)
	out_4 = l.Concatenate()([c4_out,out_3])
	out_5 = intra_block_2(out_4, 512, 1, 1)
	out_6 = intra_block_1(out_5, 512, 2, 2) # 38
	c3_out = c3(inputs)
	out_7 = l.Concatenate()([c3_out,out_6])
	out_8 = intra_block_2(out_7, 512, 1, 1)
	out_9 = intra_block_1(out_8, 256, 2, 2)
	out_10 = intra_block_2(out_9, 256, 2, 1) # 75
	c2_out = c2(inputs)
	out_11 = l.Concatenate()([c2_out,out_10])
	out_12 = intra_block_2(out_11, 256, 1, 1)
	out_13 = intra_block_1(out_12, 128, 2, 2) # 150
	c1_out = c1(inputs)
	out_14 = l.Concatenate()([c1_out,out_13])
	out_15 = intra_block_2(out_14, 128, 1, 1)
	out_16 = intra_block_1(out_15, 64, 2, 2) # 300
	outputs = l.Conv2D(1, kernel_size=1)(out_16)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
