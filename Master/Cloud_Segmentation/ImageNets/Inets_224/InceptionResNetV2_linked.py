import tensorflow as tf
from tensorflow.keras import models as m
from tensorflow.keras import layers as l
from tensorflow.keras import activations as a
from tensorflow.keras.applications import InceptionResNetV2


# # Network Architecture

name = "InceptionResNetV2_linked"

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
	InceptionResNetV2_base = InceptionResNetV2(weights=weights,
			include_top=False,
			input_shape=img_size+(3,))
	InceptionResNetV2_base.trainable = state

	"""
	# make last layers trainable
	for i,layer in enumerate(InceptionResNetV2_base.layers):
		if i < 762:
			layer.trainable = False
		else:
			layer.trainable = True
		print(i,"layer {} is {}".format(layer.name, '+++trainable' if layer.trainable else '---frozen'))
	"""

	#InceptionResNetV2_base.summary()
	
	c1 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=3).output)
	c2 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=6).output)
	c3 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=13).output)
	c4 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=16).output)
	c5 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=20).output)
	c6 = m.Model(inputs=InceptionResNetV2_base.input, outputs=InceptionResNetV2_base.get_layer(index=274).output)

	# Network
	inputs = tf.keras.Input(shape=(img_size+(3,)))
	out_1 = InceptionResNetV2_base(inputs)
	out_2 = intra_block_1(out_1, 512, 2, 1)
	out_3 = intra_block_1(out_2, 512, 2, 2)
	c6_out = c6(inputs)
	out_4 = l.Concatenate()([c6_out,out_3])
	out_5 = intra_block_1(out_4, 256, 3, 2)
	c5_out = c5(inputs)
	out_6 = l.Concatenate()([c5_out,out_5])
	out_7 = intra_block_1(out_6, 256, 4, 2)
	c4_out = c4(inputs)
	out_8 = l.Concatenate()([c4_out,out_7])
	out_9 = intra_block_1(out_8, 256, 3, 1)
	c3_out = c3(inputs)
	out_10 = l.Concatenate()([c3_out,out_9])
	out_11 = intra_block_1(out_10, 128, 3, 2)
	c2_out = c2(inputs)
	out_12 = l.Concatenate()([c2_out,out_11])
	out_13 = intra_block_1(out_12, 128, 3, 1)
	c1_out = c1(inputs)
	out_14 = l.Concatenate()([c1_out,out_13])
	out_15 = intra_block_1(out_14, 64, 4, 2)
	outputs = l.Conv2D(1, kernel_size=1)(out_15)
	outputs = l.Activation('sigmoid')(outputs)
	model = tf.keras.Model(inputs,outputs)
	model.summary()
	return model
