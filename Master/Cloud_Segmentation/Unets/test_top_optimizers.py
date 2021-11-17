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


unet_dictionary = {
	"n1": "Unet",
        "n2": "A_Unet",
	"n3": "D_Unet",
        "n4": "W_Unet",
	"n5": "R_Unet",
	}


dataset_dictionary = {
        "d1": "clouds_60_20_20",
        }


path_dictionary = {
        "path1": "/home/ptziolos/Desktop/Datasets_Nets/clouds_60_20_20",
}

optimizers_codename_dictionary = {
	"c1": "Adam",
	"c2": "Adamax",
	"c3": "Nadam",
	"c4": "RMSprop",
	"c5": "AdamW",
	"c6": "LAMB",
	"c7": "LazyAdam",
	"c8": "RectifiedAdam",
	"c9": "Yogi",
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

	#test_input_dir = "/home/ptziolos/Desktop/Datasets_Nets/SWIMSEG/images"
	#test_target_dir = "/home/ptziolos/Desktop/Datasets_Nets/SWIMSEG/GTmaps"

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


def test_network():

# Initialize the model

	model = tf.keras.models.load_model("/home/ptziolos/Desktop/top_optimizer_results/"+ net+"_"+codename+"_"+dataset, compile=False)

	model.compile(
		  loss=lf.dice,
		  optimizer=o.Nadam(learning_rate=1e-4),
		  #optimizer=tfa.optimizers.LAMB(learning_rate=1e-4),
		  metrics=[m.IoU]
		  #metrics=['accuracy',m.f1_score,m.IoU,m.precision,m.recall,m.specificity]
	)

# Evaluate the model
	train_loss, train_acc = model.evaluate(train_x, train_y)

	val_loss, val_acc = model.evaluate(val_x, val_y)

	test_loss, test_acc = model.evaluate(test_x, test_y)
	print(codename+": ",f"Train accuracy: {train_acc:.3f}",f"Val accuracy: {val_acc:.3f}",f"Test accuracy: {test_acc:.3f}")


#main
path = path_dictionary[f"path{1}"]
dataset = dataset_dictionary[f"d{1}"]
train_x,train_y,val_x,val_y,test_x,test_y = load_dataset()
for i in range(1,10):
	codename = optimizers_codename_dictionary[f"c{i}"]
	for j in range(2,3):
		net = unet_dictionary[f"n{j}"]
		test_network()
