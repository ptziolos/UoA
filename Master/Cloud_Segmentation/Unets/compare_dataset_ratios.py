import tensorflow as tf
import tensorflow_addons as tfa
import keras.backend as K
from tensorflow.keras import optimizers as o
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from keras.callbacks import LearningRateScheduler
import matplotlib.pyplot as plt
from tqdm import tqdm
import numpy as np
import pickle
import shutil
import os
from Nets import Unet
from Nets import D_Unet
from Nets import A_Unet
from Nets import R_Unet
from Nets import W_Unet


unet_dictionary = {
	"n1": Unet,
	"n2": A_Unet,
	"n3": D_Unet,
	"n4": W_Unet,
	"n5": R_Unet,
	}


dataset_dictionary = {
	"d1": "clouds_60_20_20",
	"d2": "clouds_65_15_20",
	"d3": "clouds_70_10_20",
	"d4": "clouds_70_15_15",
	"d5": "clouds_80_10_10",
	}


path_dictionary = {
	"path1": "/home/ptziolos/Desktop/Datasets_Nets/clouds_60_20_20",
	"path2": "/home/ptziolos/Desktop/Datasets_Nets/clouds_65_15_20",
	"path3": "/home/ptziolos/Desktop/Datasets_Nets/clouds_70_10_20",
	"path4": "/home/ptziolos/Desktop/Datasets_Nets/clouds_70_15_15",
	"path5": "/home/ptziolos/Desktop/Datasets_Nets/clouds_80_10_10",
}


img_size = (300, 300)


def get_images(input_dir, target_dir, img_size=(224, 224, 3)):
	input_img_paths = sorted([os.path.join(input_dir, fname) for fname in os.listdir(input_dir) if fname.endswith(".png")])

	target_paths = sorted([os.path.join(target_dir, fname) for fname in os.listdir(target_dir) if fname.endswith(".png") and not fname.startswith(".")])

	x = []
	y = []

	for i in tqdm(range(len(input_img_paths))):
		x.append(img_to_array(load_img(input_img_paths[i], target_size=img_size+(3,))))
		y.append(img_to_array(load_img(target_paths[i], color_mode = "grayscale", target_size=img_size+(1,))))

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

# Dice loss function

	def dice(y_true, y_pred, smooth=1):
		intersection = tf.reduce_sum(y_true * y_pred)
		union = tf.reduce_sum(y_true + y_pred)
		f1 = (2 * intersection + smooth) / (union + smooth)
		return (1 - f1) * smooth

# Initialize the model

	model = net.create_model(img_size)
	# model.build(input_shape=((None,)+img_size+(3,)))
	# model.summary()

# Train the model

	model.compile(
		  loss=dice,
		  optimizer=o.Adam(learning_rate=1e-3),
		  #optimizer=tfa.optimizers.LAMB(learning_rate=1e-4),
		  metrics='accuracy'
	)

	# earlystopper = tf.keras.callbacks.EarlyStopping(patience=4, verbose=1)

	checkpointer = tf.keras.callbacks.ModelCheckpoint(
	                                   filepath = r"/home/ptziolos/Desktop/dataset_results/" + net.name+"_"+dataset, 
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
			epochs=51,
			batch_size = 6,
			shuffle=True,
			validation_data=(val_x, val_y),
			verbose=1,
			callbacks=[checkpointer,change_lr],
			)

# Save the model

	#model.save(r"/home/ptziolos/Desktop/" + net.name+"_"+dataset,save_format='tf')

# Save history

	with open(r"/home/ptziolos/Desktop/dataset_results/" + net.name+"_"+dataset + "__History", 'wb') as the_file:
		pickle.dump(history.history, the_file)

# Evaluate the model

	#test_loss, test_acc = model.evaluate((test_x), test_y)
	#print(f"Test accuracy: {test_acc:.3f}")



for i in range(1,6):
	path = path_dictionary[f"path{i}"]
	dataset = dataset_dictionary[f"d{i}"]
	train_x,train_y,val_x,val_y,test_x,test_y = load_dataset()
	for j in range(5,6):
		net = unet_dictionary[f"n{j}"]
		train_network()



