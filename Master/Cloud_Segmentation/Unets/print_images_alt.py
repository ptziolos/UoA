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

	test_input_dir = "/home/ptziolos/Desktop/Datasets_Nets/SWIMSEG/images"
	test_target_dir = "/home/ptziolos/Desktop/Datasets_Nets/SWIMSEG/GTmaps"
	
	test_x, test_y = get_images(test_input_dir, test_target_dir, img_size)

# Normalization of values

	test_x = test_x.astype('float32')
	test_y = test_y.astype('float32')

	test_x = test_x / 255
	test_y = test_y / 255

	return test_x,test_y


def segment_images():

# Initialize the model

	model = tf.keras.models.load_model("/home/ptziolos/Desktop/dataset_results/"+ net+"_"+dataset, compile=False)

	model.compile(
		  loss=lf.dice,
		  optimizer=o.Nadam(learning_rate=1e-4),
		  #optimizer=op.LAMB(learning_rate=1e-4),
		  metrics=['accuracy']
		  #metrics=['accuracy',m.f1_score,m.IoU,m.precision,m.recall,m.specificity]
	)

	for i in tqdm(range(1,n+1)):
		img = model.predict(test_x[i][np.newaxis, :])
		img = np.reshape(img,(300,300,1))

		"""		
		img2 = np.copy(img.reshape(img.shape[0] * img.shape[1]))
		for j in range(img2.shape[0]):
			if img2[j] < 0.5:
				img2[j] = 0
			else:
				img2[j] = 1

		img2 = img2.reshape(300 , 300)
		"""

		plt.subplot(n+2,n,k*n+i)
		plt.title(net)
		plt.axis('off')
		plt.imshow(np.squeeze(img), cmap="gray")

# main
for i in range(1,2):
	path = path_dictionary[f"path{i}"]
	dataset = dataset_dictionary[f"d{i}"]
	test_x,test_y = load_dataset()
	n=5
	plt.figure(figsize=(n,n+3), dpi=500)
	for i in tqdm(range(1,n+1)):
		plt.subplot(n+2,n,i)
		plt.title("RGB")
		plt.axis('off')
		plt.imshow(test_x[i])
	for i in tqdm(range(1,n+1)):
		plt.subplot(n+2,n,n+i)
		plt.title("GT")
		plt.axis('off')
		plt.imshow(np.squeeze(test_y[i]), cmap="gray")
	for j in range(1,6):
		net = unet_dictionary[f"n{j}"]
		k=j+1
		segment_images()
	plt.savefig("/home/ptziolos/Desktop/Unet_segmentation")



