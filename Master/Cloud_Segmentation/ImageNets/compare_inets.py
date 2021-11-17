import tensorflow as tf
import tensorflow_addons as tfa
import keras.backend as K
from tensorflow.keras import optimizers as o
from tensorflow_addons import optimizers as op
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from keras.callbacks import LearningRateScheduler
import matplotlib.pyplot as plt
from tqdm import tqdm
import numpy as np
import pickle
import shutil
import os
import loss_functions as lf
import metrics as m
from Inets_224 import VGG16
from Inets_224 import VGG16_linked
from Inets_224 import VGG19
from Inets_224 import VGG19_linked
from Inets_224 import ResNet50
from Inets_224 import ResNet50_linked
from Inets_224 import ResNet101
from Inets_224 import ResNet101_linked
from Inets_224 import ResNet152
from Inets_224 import ResNet152_linked
from Inets_224 import ResNet50V2
from Inets_224 import ResNet50V2_linked
from Inets_224 import ResNet101V2
from Inets_224 import ResNet101V2_linked
from Inets_224 import ResNet152V2
from Inets_224 import ResNet152V2_linked
from Inets_224 import InceptionV3
from Inets_224 import InceptionV3_linked
from Inets_224 import InceptionResNetV2
from Inets_224 import InceptionResNetV2_linked
from Inets_224 import Xception
from Inets_224 import Xception_linked
from Inets_224 import MobileNet
from Inets_224 import MobileNet_linked
from Inets_224 import MobileNetV2
from Inets_224 import MobileNetV2_linked
from Inets_224 import DenseNet121
from Inets_224 import DenseNet121_linked
from Inets_224 import DenseNet169
from Inets_224 import DenseNet169_linked
from Inets_224 import DenseNet201
from Inets_224 import DenseNet201_linked
from Inets_224 import NASNetMobile
from Inets_224 import NASNetMobile_linked
from Inets_224 import NASNetLarge
from Inets_224 import NASNetLarge_linked
from Inets_224 import EfficientNetB0
from Inets_224 import EfficientNetB0_linked
from Inets_224 import EfficientNetB1
from Inets_224 import EfficientNetB1_linked
from Inets_224 import EfficientNetB2
from Inets_224 import EfficientNetB2_linked
from Inets_224 import EfficientNetB3
from Inets_224 import EfficientNetB3_linked
from Inets_224 import EfficientNetB4
from Inets_224 import EfficientNetB4_linked
from Inets_224 import EfficientNetB5
from Inets_224 import EfficientNetB5_linked
from Inets_224 import EfficientNetB6
from Inets_224 import EfficientNetB6_linked
from Inets_224 import EfficientNetB7
from Inets_224 import EfficientNetB7_linked


unet_dictionary = {
	"n1": VGG16,
	"n2": VGG16_linked,
	"n3": VGG19,
	"n4": VGG19_linked,
	"n5": ResNet50,
	"n6": ResNet50_linked,
	"n7": ResNet101,
	"n8": ResNet101_linked,
	"n9": ResNet152,
	"n10": ResNet152_linked,
	"n11": ResNet50V2,
	"n12": ResNet50V2_linked,
	"n13": ResNet101V2,
	"n14": ResNet101V2_linked,
	"n15": ResNet152V2,
	"n16": ResNet152V2_linked,
	"n17": InceptionV3,
	"n18": InceptionV3_linked,
	"n19": InceptionResNetV2,
	"n20": InceptionResNetV2_linked,
	"n21": Xception,
	"n22": Xception_linked,
	"n23": MobileNet,
	"n24": MobileNet_linked,
	"n25": MobileNetV2,
	"n26": MobileNetV2_linked,
	"n27": DenseNet121,
	"n28": DenseNet121_linked,
	"n29": DenseNet169,
	"n30": DenseNet169_linked,
	"n31": DenseNet201,
	"n32": DenseNet201_linked,
	"n33": NASNetMobile,
	"n34": NASNetMobile_linked,
	"n35": NASNetLarge,
	"n36": NASNetLarge_linked,
	"n37": EfficientNetB0,
	"n38": EfficientNetB0_linked,
	"n39": EfficientNetB1,
	"n40": EfficientNetB1_linked,
	"n41": EfficientNetB2,
	"n42": EfficientNetB2_linked,
	"n43": EfficientNetB3,
	"n44": EfficientNetB3_linked,
	"n45": EfficientNetB4,
	"n46": EfficientNetB4_linked,
	"n47": EfficientNetB5,
	"n48": EfficientNetB5_linked,
	"n49": EfficientNetB6,
	"n50": EfficientNetB6_linked,
	"n51": EfficientNetB7,
	"n52": EfficientNetB7_linked,
	}


preprocess_input_dictionary = {
	"p1": tf.keras.applications.vgg16.preprocess_input,
	"p2": tf.keras.applications.vgg16.preprocess_input,
	"p3": tf.keras.applications.vgg19.preprocess_input,
	"p4": tf.keras.applications.vgg19.preprocess_input,
	"p5": tf.keras.applications.resnet.preprocess_input,
	"p6": tf.keras.applications.resnet.preprocess_input,
	"p7": tf.keras.applications.resnet.preprocess_input,
	"p8": tf.keras.applications.resnet.preprocess_input,
	"p9": tf.keras.applications.resnet.preprocess_input,
	"p10": tf.keras.applications.resnet.preprocess_input,
	"p11": tf.keras.applications.resnet.preprocess_input,
	"p12": tf.keras.applications.resnet.preprocess_input,
	"p13": tf.keras.applications.resnet.preprocess_input,
	"p14": tf.keras.applications.resnet.preprocess_input,
	"p15": tf.keras.applications.resnet.preprocess_input,
	"p16": tf.keras.applications.resnet.preprocess_input,
	"p17": tf.keras.applications.inception_v3.preprocess_input,
	"p18": tf.keras.applications.inception_v3.preprocess_input,
	"p19": tf.keras.applications.inception_resnet_v2.preprocess_input,
	"p20": tf.keras.applications.inception_resnet_v2.preprocess_input,
	"p21": tf.keras.applications.xception.preprocess_input,
	"p22": tf.keras.applications.xception.preprocess_input,
	"p23": tf.keras.applications.mobilenet.preprocess_input,
	"p24": tf.keras.applications.mobilenet.preprocess_input,
	"p25": tf.keras.applications.mobilenet_v2.preprocess_input,
	"p26": tf.keras.applications.mobilenet_v2.preprocess_input,
	"p27": tf.keras.applications.densenet.preprocess_input,
	"p28": tf.keras.applications.densenet.preprocess_input,
	"p29": tf.keras.applications.densenet.preprocess_input,
	"p30": tf.keras.applications.densenet.preprocess_input,
	"p31": tf.keras.applications.densenet.preprocess_input,
	"p32": tf.keras.applications.densenet.preprocess_input,
	"p33": tf.keras.applications.nasnet.preprocess_input,
	"p34": tf.keras.applications.nasnet.preprocess_input,
	"p35": tf.keras.applications.nasnet.preprocess_input,
	"p36": tf.keras.applications.nasnet.preprocess_input,
	"p37": tf.keras.applications.efficientnet.preprocess_input,
	"p38": tf.keras.applications.efficientnet.preprocess_input,
	"p39": tf.keras.applications.efficientnet.preprocess_input,
	"p40": tf.keras.applications.efficientnet.preprocess_input,
	"p41": tf.keras.applications.efficientnet.preprocess_input,
	"p42": tf.keras.applications.efficientnet.preprocess_input,
	"p43": tf.keras.applications.efficientnet.preprocess_input,
	"p44": tf.keras.applications.efficientnet.preprocess_input,
	"p45": tf.keras.applications.efficientnet.preprocess_input,
	"p46": tf.keras.applications.efficientnet.preprocess_input,
	"p47": tf.keras.applications.efficientnet.preprocess_input,
	"p48": tf.keras.applications.efficientnet.preprocess_input,
	"p49": tf.keras.applications.efficientnet.preprocess_input,
	"p50": tf.keras.applications.efficientnet.preprocess_input,
	"p51": tf.keras.applications.efficientnet.preprocess_input,
	"p52": tf.keras.applications.efficientnet.preprocess_input,
	}


dataset_dictionary = {
	"d1": "clouds_60_20_20",
	}


path_dictionary = {
	"path1": "/home/ptziolos/Desktop/Datasets_Nets/clouds_60_20_20",
}


def get_images(input_dir, target_dir, img_size=(224, 224, 3)):
	input_img_paths = sorted([os.path.join(input_dir, fname) for fname in os.listdir(input_dir) if fname.endswith(".png")])

	target_paths = sorted([os.path.join(target_dir, fname) for fname in os.listdir(target_dir) if fname.endswith(".png") and not fname.startswith(".")])

	x = []
	y = []

	for i in tqdm(range(len(input_img_paths))):
#		x.append(np.squeeze(preprocess(img_to_array(load_img(input_img_paths[i], target_size=img_size+(3,))))))
		x.append(img_to_array(load_img(input_img_paths[i], target_size=img_size+(3,))))
		y.append((img_to_array(load_img(target_paths[i], color_mode = "grayscale", target_size=img_size+(1,)))))

	return np.array(x), np.array(y)


def load_dataset():
# loading sets from path

	train_input_dir = path+"/train_x"
	train_target_dir = path+"/train_y"

	train_x, train_y = get_images(train_input_dir, train_target_dir, img_size)


	val_input_dir = path+"/val_x"
	val_target_dir = path+"/val_y"

	val_x, val_y = get_images(val_input_dir, val_target_dir, img_size)


	test_input_dir = path+"/test_x"
	test_target_dir = path+"/test_y"

	test_x, test_y = get_images(test_input_dir, test_target_dir, img_size)

# Normalization of values

	train_x = train_x.astype('float32')
	train_y = train_y.astype('float32')

	train_x = train_x / 255
	train_y = train_y / 255

	val_x = val_x.astype('float32')
	val_y = val_y.astype('float32')

	val_x = val_x / 255
	val_y = val_y / 255

	test_x = test_x.astype('float32')
	test_y = test_y.astype('float32')

	test_x = test_x / 255
	test_y = test_y / 255

	return train_x,train_y,val_x,val_y,test_x,test_y


def train_network():

# Initialize the model

	model = net.create_model(img_size, weights, state)
	# model.build(input_shape=((None,)+img_size+(3,)))
	# model.summary()

# Train the model

	model.compile(
		  loss=lf.logCoshDice,
		  optimizer=op.LAMB(learning_rate=1e-4),
		  metrics=['accuracy']
	)


	# earlystopper = tf.keras.callbacks.EarlyStopping(patience=4, verbose=1)

	checkpointer = tf.keras.callbacks.ModelCheckpoint(
	                                   filepath = r"/home/ptziolos/Desktop/inet_untrained_results/" + net.name+"_"+dataset, 
		                                 save_format='tf', verbose=1, save_best_only=True)

	reduce_lr = tf.keras.callbacks.ReduceLROnPlateau(monitor='val_loss', 
		          factor=0.95, patience=3, min_lr=1e-5, verbose=1)

	def scheduler(epoch):
		if epoch < 11:
			K.set_value(model.optimizer.lr, 1e-3)
		elif epoch < 21:
			K.set_value(model.optimizer.lr, 5e-4)
		elif epoch < 31:
			K.set_value(model.optimizer.lr, 1e-4)
		else :
			K.set_value(model.optimizer.lr, 5e-5)
		return K.get_value(model.optimizer.lr)

	change_lr = LearningRateScheduler(scheduler)

	history = model.fit(train_x,
			train_y,
			epochs=31,
			batch_size = 6,
			shuffle=True,
			validation_data=(val_x, val_y),
			verbose=2,
			callbacks=[checkpointer,change_lr],
			)


# Save the model

	#model.save(r"/home/ptziolos/Desktop/" + net.name+"_"+dataset,save_format='tf')

# Save history

	with open(r"/home/ptziolos/Desktop/inet_untrained_results/" + net.name+"_"+dataset + "__History", 'wb') as the_file:
		pickle.dump(history.history, the_file)

# Evaluate the model

	#test_loss, test_acc = model.evaluate((test_x), test_y)
	#print(f"Test accuracy: {test_acc:.3f}")


# main
for i in range(1,2):
	path = path_dictionary[f"path{i}"]
	dataset = dataset_dictionary[f"d{i}"]
	for j in range(1,53):
		net = unet_dictionary[f"n{j}"]
		preprocess = preprocess_input_dictionary[f"p{j}"]

		if j == 35 or j == 36:
			img_size = (331, 331)
		else:
			img_size = (224, 224)

		train_x,train_y,val_x,val_y,test_x,test_y = load_dataset()
		#weights = "imagenet"
		weights = None
		state = True
		train_network()



