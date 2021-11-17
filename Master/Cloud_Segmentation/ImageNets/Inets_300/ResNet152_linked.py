import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import ResNet152


# # Network Architecture

name = "ResNet152"

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
	ResNet152_base = ResNet152(weights="imagenet",
			include_top=False,
			input_shape=img_size+(3,))
	
	ResNet152_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(ResNet152_base.layers):
		if i < 505:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#ResNet152_base.summary()
	
	c1 = m.Model(inputs=ResNet152_base.input, outputs=ResNet152_base.get_layer('conv1_relu').output)
	c2 = m.Model(inputs=ResNet152_base.input, outputs=ResNet152_base.get_layer('conv2_block1_1_relu').output)
	c3 = m.Model(inputs=ResNet152_base.input, outputs=ResNet152_base.get_layer('conv3_block1_1_relu').output)
	c4 = m.Model(inputs=ResNet152_base.input, outputs=ResNet152_base.get_layer('conv4_block1_1_relu').output)


	# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = ResNet152_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2) # 20
	out_2 = intra_block_2(out_2, 512, 2, 1)
	c4_out = c4(inputs)
	out_3 = l.Concatenate()([c4_out,out_2])
	out_4 = intra_block_1(out_3, 512, 2, 2) # 38
	c3_out = c3(inputs)
	out_5 = l.Concatenate()([c3_out,out_4])
	out_6 = intra_block_1(out_5, 256, 2, 2) # 76
	out_6 = intra_block_2(out_6, 256, 2, 1)
	c2_out = c2(inputs)
	out_7 = l.Concatenate()([c2_out,out_6])
	out_8 = intra_block_1(out_7, 128, 2, 2) # 150
	c1_out = c1(inputs)
	out_9 = l.Concatenate()([c1_out,out_8])
	out_10 = intra_block_1(out_9, 64, 2, 2) # 300
	outputs = l.Conv2D(1, kernel_size=1)(out_10)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
