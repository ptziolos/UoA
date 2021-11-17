import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import DenseNet201


# # Network Architecture

name = "DenseNet201_linked"

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
	DenseNet201_base = DenseNet201(weights="imagenet",
			include_top=False,
			input_shape=img_size+(3,))
	
	DenseNet201_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(DenseNet201_base.layers):
		if i < 679:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#DenseNet201_base.summary()
	
	c1 = m.Model(inputs=DenseNet201_base.input, outputs=DenseNet201_base.get_layer('conv1/conv').output)
	c2 = m.Model(inputs=DenseNet201_base.input, outputs=DenseNet201_base.get_layer('conv2_block1_0_relu').output)
	c3 = m.Model(inputs=DenseNet201_base.input, outputs=DenseNet201_base.get_layer('conv3_block1_0_relu').output)
	c4 = m.Model(inputs=DenseNet201_base.input, outputs=DenseNet201_base.get_layer('conv4_block1_0_relu').output)
	
# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = DenseNet201_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 2)
	c4_out = c4(inputs)
	out_3 = l.Concatenate()([c4_out,out_2])
	out_4 = intra_block_1(out_3, 512, 3, 2)
	c3_out = c3(inputs)
	out_5 = l.Concatenate()([c3_out,out_4])
	out_6 = intra_block_1(out_5, 256, 3, 2)
	c2_out = c2(inputs)
	out_7 = l.Concatenate()([c2_out,out_6])
	out_8 = intra_block_1(out_7, 128, 2, 2)
	c1_out = c1(inputs)
	out_9 = l.Concatenate()([c1_out,out_8])
	out_10 = intra_block_1(out_9, 64, 2, 2)
	outputs = l.Conv2D(1, kernel_size=1)(out_10)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
