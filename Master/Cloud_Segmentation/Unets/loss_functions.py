import tensorflow as tf
import keras.backend as K


# # Distribution losses # #

"""
# BinaryCrossEntropy
def binaryCrossEntropy(ytrue , ypred):
	ce = -(ytrue * tf.math.log(ypred) + (1 - ytrue) * tf.math.log(1 - ypred))
	return ce
	
#Focal
def focal(ytrue , ypred, alpha=0.25, gamma=2):
	fl = -(ytrue * alpha * tf.pow((1 - ypred),gamma) * tf.math.log(ypred) + (1 - ytrue) * (1 - alpha) * tf.pow(ypred,gamma) * tf.math.log(1 - ypred))
	return fl
"""

# # Region-based losses # #

# Dice

def dice(y_true, y_pred, epsilon=1e-7):
	intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
	union = K.sum(y_true,[1,2,3])+K.sum(y_pred,[1,2,3])
	f1 = K.mean((2 * intersection + epsilon) / (union + epsilon))
	return 1-f1

'''
def dice2(ytrue, ypred, epsilon=1e-7): 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	numerator = 2 * precision * recall
	denominator = precision + recall
	f1 = numerator / denominator
	return 1-f1
'''

# Fbeta
def fbeta_score(ytrue , ypred, beta=1.2, epsilon=1e-7):
	beta_squared = beta ** 2 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	fb = 1 - (1 + beta_squared) * precision * recall / (beta_squared * precision + recall + epsilon)
	return fb
	
# Jaccard
def jaccard(y_true, y_pred, epsilon=1e-7):
	intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
	union = K.sum(y_true,[1,2,3])+K.sum(y_pred,[1,2,3])-intersection
	iou = K.mean((intersection + epsilon) / (union + epsilon), axis=0)
	return 1 - iou

# Power Jaccard
def powerJaccard(y_true, y_pred, p=1.1, epsilon=1e-7):
	intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
	union = K.sum(y_true,[1,2,3])**p+K.sum(y_pred,[1,2,3])**p-intersection
	iou = K.mean((intersection + epsilon) / (union + epsilon), axis=0)
	return 1 - iou

# Tversky
def tversky(ytrue, ypred, alpha=1, gamma=1, epsilon=1e-7):
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	tvs = (1 - true_positive/(true_positive + alpha * false_negative + (1 - alpha) * false_negative + epsilon)) ** gamma
	return tvs


# # Compound losses # #

# LogCoshDice
def logCoshDice(ytrue, ypred, beta=1, epsilon=1e-7):
	beta_squared = beta ** 2 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	fb = 1 - (1 + beta_squared) * precision * recall / (beta_squared * precision + recall + epsilon)
	lcd = tf.math.log((tf.exp(fb) + tf.exp(-fb)) / 2.0)
	return lcd

# LogCoshJaccard
def logCoshJaccard(ytrue, ypred, epsilon=1e-7):
	intersection = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	union = K.sum(ytrue,[1,2,3])+K.sum(ypred,[1,2,3])-intersection
	jc = 1 - K.mean((intersection + epsilon) / (union + epsilon), axis=0)
	lcd = tf.math.log((tf.exp(jc) + tf.exp(-jc)) / 2.0)
	return lcd

# BinaryCrossEntropyDice
def binaryCrossEntropyDice(ytrue, ypred, beta=1, epsilon=1e-7):
	beta_squared = beta ** 2 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	fb = 1 - (1 + beta_squared) * precision * recall / (beta_squared * precision + recall + epsilon)
	ce = tf.losses.binary_crossentropy(ytrue, ypred)
	return ce + fb

# BinaryCrossEntropylogCoshJaccard
def binaryCrossEntropylogCoshJaccard(ytrue, ypred, epsilon=1e-7):
	intersection = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	union = K.sum(ytrue,[1,2,3])+K.sum(ypred,[1,2,3])-intersection
	jc = 1 - K.mean((intersection + epsilon) / (union + epsilon), axis=0)
	lcj = tf.math.log((tf.exp(jc) + tf.exp(-jc)) / 2.0)
	ce = tf.losses.binary_crossentropy(ytrue, ypred)
	return ce + lcj

# FbetaPowerJaccard
def fbetaPowerJaccard(ytrue , ypred, beta=0.9, p=1.1, epsilon=1e-7):
	beta_squared = beta ** 2 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	fb = 1 - (1 + beta_squared) * precision * recall / (beta_squared * precision + recall + epsilon)
	union = K.sum(ytrue,[1,2,3])**p+K.sum(ypred,[1,2,3])**p-true_positive
	jc = 1 - K.mean((true_positive + epsilon) / (union + epsilon), axis=0)
	lcj = tf.math.log((tf.exp(jc) + tf.exp(-jc)) / 2.0)
	return lcj + fb

# Tverskyfbeta
def tverskyfbeta(ytrue, ypred, beta=1.4, alpha=1, gamma=1, epsilon=1e-7):
	beta_squared = beta ** 2 
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	tvs = (1 - true_positive/(true_positive + alpha * false_negative + (1 - alpha) * false_negative + epsilon)) ** gamma
	fb = 1 - (1 + beta_squared) * precision * recall / (beta_squared * precision + recall + epsilon)
	return fb + tvs

