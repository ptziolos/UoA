import tensorflow as tf
import tensorflow_addons as tfa
from tensorflow.keras import optimizers as o
from tensorflow_addons import optimizers as op
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications.vgg16 import preprocess_input
import matplotlib.pyplot as plt
from tqdm import tqdm
import numpy as np
import pickle
import shutil
import os
import loss_functions as lf
import metrics as m
import pandas as pd


unet_dictionary = {
	"n1": "VGG16",
	"n2": "VGG16_linked",
	"n3": "VGG19",
	"n4": "VGG19_linked",
	"n5": "ResNet50",
	"n6": "ResNet50_linked",
	"n7": "ResNet101",
	"n8": "ResNet101_linked",
	"n9": "ResNet152",
	"n10": "ResNet152_linked",
	"n11": "ResNet50V2",
	"n12": "ResNet50V2_linked",
	"n13": "ResNet101V2",
	"n14": "ResNet101V2_linked",
	"n15": "ResNet152V2",
	"n16": "ResNet152V2_linked",
	"n17": "InceptionV3",
	"n18": "InceptionV3_linked",
	"n19": "InceptionResNetV2",
	"n20": "InceptionResNetV2_linked",
	"n21": "Xception",
	"n22": "Xception_linked",
	"n23": "MobileNet",
	"n24": "MobileNet_linked",
	"n25": "MobileNetV2",
	"n26": "MobileNetV2_linked",
	"n27": "DenseNet121",
	"n28": "DenseNet121_linked",
	"n29": "DenseNet169",
	"n30": "DenseNet169_linked",
	"n31": "DenseNet201",
	"n32": "DenseNet201_linked",
	"n33": "NASNetMobile",
	"n34": "NASNetMobile_linked",
	"n35": "EfficientNetB0",
	"n36": "EfficientNetB0_linked",
	"n37": "EfficientNetB1",
	"n38": "EfficientNetB1_linked",
	"n39": "EfficientNetB2",
	"n40": "EfficientNetB2_linked",
	"n41": "EfficientNetB3",
	"n42": "EfficientNetB3_linked",
	"n43": "EfficientNetB4",
	"n44": "EfficientNetB4_linked",
	"n45": "EfficientNetB5",
	"n46": "EfficientNetB5_linked",
	"n47": "EfficientNetB6",
	"n48": "EfficientNetB6_linked",
	"n49": "EfficientNetB7",
	"n50": "EfficientNetB7_linked",
	"n51": "NASNetLarge",
	"n52": "NASNetLarge_linked",
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

	model = tf.keras.models.load_model("/home/ptziolos/Desktop/inet_untrained_results/"+ net+"_"+dataset, compile=False)

	model.compile(
		  loss=lf.logCoshDice,
		  optimizer=op.LAMB(learning_rate=1e-4),
		  metrics=['accuracy']
		  #metrics=['accuracy',m.f1_score,m.IoU,m.precision,m.recall,m.specificity]
	)

# Evaluate the model
	train_loss, train_acc = model.evaluate(train_x, train_y)

	val_loss, val_acc = model.evaluate(val_x, val_y)

	test_loss, test_acc = model.evaluate(test_x, test_y)
	print(net+": ",f"Train accuracy: {train_acc:.3f}",f"Val accuracy: {val_acc:.3f}",f"Test accuracy: {test_acc:.3f}")
	
	metric_values.append(train_acc)
	metric_values.append(val_acc)
	metric_values.append(test_acc)


# main
metric_values = []
for i in range(1,2):
	path = path_dictionary[f"path{i}"]
	dataset = dataset_dictionary[f"d{i}"]
	img_size = (224, 224)
	train_x,train_y,val_x,val_y,test_x,test_y = load_dataset()
	for j in range(1,46):
		net = unet_dictionary[f"n{j}"]
		test_network()
df = pd.DataFrame(metric_values)
df.to_excel("/home/ptziolos/Desktop/metric_values.xlsx")


