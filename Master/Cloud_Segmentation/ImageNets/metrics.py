import tensorflow as tf
import keras.backend as K

# F1_score
def f1_score(y_true, y_pred, epsilon=1e-7):
	intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
	union = K.sum(y_true,[1,2,3])+K.sum(y_pred,[1,2,3])
	f1 = K.mean((2 * intersection + epsilon) / (union + epsilon))
	return f1

# IoU
def IoU(y_true, y_pred, epsilon=1e-7):
	intersection = K.sum(K.abs(y_true * y_pred), axis=[1,2,3])
	union = K.sum(y_true,[1,2,3])+K.sum(y_pred,[1,2,3])-intersection
	iou = K.mean((intersection + epsilon) / (union + epsilon), axis=0)
	return iou

# Precision
def precision(ytrue , ypred, epsilon=1e-7):
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	precision = K.mean(true_positive/(true_positive+false_positive+epsilon), axis=0)
	return precision

# Recall
def recall(ytrue , ypred, epsilon=1e-7):
	true_positive = K.sum(K.abs(ytrue * ypred), axis=[1,2,3])
	false_negative = K.sum(K.abs(ytrue * (1 - ypred)), axis=[1,2,3])
	recall = K.mean(true_positive/(true_positive+false_negative+epsilon), axis=0)
	return recall

# Specificity
def specificity(ytrue , ypred, epsilon=1e-7):
	false_positive = K.sum(K.abs((1 - ytrue) * ypred), axis=[1,2,3])
	true_negative = K.sum(K.abs((1 - ytrue) * (1 - ypred)), axis=[1,2,3])
	specificity = K.mean(true_negative/(true_negative+false_positive+epsilon), axis=0)
	return specificity

