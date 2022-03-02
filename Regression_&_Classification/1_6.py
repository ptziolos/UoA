import numpy as np
import random as r
import matplotlib.pyplot


# EM algorithm

# 1. Assume initil values for parameter a, b
# 2. Calculate the expectation value of loglikelihood with respect to a, b
# 	E = integral(P(theta;a;b)exp[theta - mi/ 2sugma] dtheta)
# 3. dE/da = 0, dE/db = 0 => new values for a,b. 
#  Iterate until a(k+1) close to a(k) and b(k+1) close to b(k)

# GOAL: to recover the true variance of the noise using EM method

def main():
	N = 500
	K = 5
	N_test = 20	


	sigma_noise = 0.05
	st_dev = np.sqrt(sigma_noise)
	mean = np.zeros((5, 1))
	variance = np.zeros((N_test, 1))

	# Given theta
	theta = np.array([[0.2], [-1], [0.9], [0.7], [-0.2]])

	# Training set
	x_train = np.zeros((N, 1))
	for i in range(N):
		x_train[i, 0] = r.uniform(0., 2.)

	# Sort & Transpose
	x_train = np.sort(x_train.transpose()[0])
	x_train = np.array([x_train]).transpose()

	# Test set
	x_test = np.zeros((N_test, 1))
	for i in range(N_test):
		x_test[i, 0] = r.uniform(0, 2)
    
    # Sort & Transpose
	x_test = np.sort(x_test.transpose()[0])
	x_test = np.array([x_test]).transpose()

    # Finding y using given theta and the training test
	y = calculate_y(N, 1, x_train, theta)
    
    # Insert noise
	y_with_noise = np.zeros((N, 1))
	for i in range(N):
		y_with_noise[i,0] = y[i, 0] + r.gauss(0, st_dev)
    
    # Finding phi matrix from the training set
	phi = construct_phi(N, x_train)

	# We want to find a = 1/sigma_theta and b = 1/sigma_noise 

	# Initialize
	a = 1
	b = 1
	a_next = 0
	b_next = 0
	epsilon = 0.0001

	# Loop the algorithm until a_next, b_next extremely close to a, b 
	# while | a_next - a| > epsilon and | b_next - b | > epsilon
	# E_step()
	# M_step()

	while np.abs(a_next - a) > epsilon and np.abs(b_next - b) > epsilon:
		a_next = a
		b_next = b
		A_, B_, mean = E_step(a, b, K, N, phi, y_with_noise)
		print(mean)
		a, b = M_step(A_, B_, K, N)
		print("\n a = " + str(a))
		print("\n b = " + str(b))
		print("\n 1/a = " + str(1/a))
		print("\n 1/b = " + str(1/b))

	# Make a prediction about y using Test set and mean theta
	y_predicted = np.array(mean[0, 0] + \
					mean[1, 0] * x_test.transpose() + mean[2, 0] * x_test.transpose() ** 2 + \
					mean[3, 0] * x_test.transpose() ** 3 + mean[4, 0] * x_test.transpose() ** 5)
	print(y_predicted)


	# Calculating the variance (sigma_theta_square)
	sigma_square = 1/a
	for i in range(N_test):
		variance[i, 0] = sigma_square

	print("\n VARIANCE \n" + str(variance))

	# Creating Real Curve from a 5th degree polynomial
	q = np.linspace(0, 2, 200).reshape((200, 1))
	y_real = calculate_y(200, 1, q, theta)

	# Plotting the results
	create_graph(q, y_real, x_test, y_predicted, variance)

def create_graph(q, y_real, x_test, y_predicted, variance):
	fig, p = matplotlib.pyplot.subplots()
	p.plot(q, y_real, 'C0:', label='y', markersize=3)

	p.errorbar(x_test, y_predicted.transpose(), np.concatenate(np.sqrt(variance)), label='y_predicted', marker='x', ls=' ', c='orange', markersize=3)

	legend = p.legend(loc='best', shadow=False, fontsize='medium')
	legend.get_frame().set_facecolor('1')

	matplotlib.pyplot.grid(False)
	matplotlib.pyplot.xlabel('x values')
	matplotlib.pyplot.ylabel('y values')
	matplotlib.pyplot.title('Comparison of the curves')
	
	matplotlib.pyplot.show()

def E_step(a_next, b_next, K, N, phi, y):
	S = cov_matrix(a_next, b_next, phi)
	mean = calculate_mean(S, b_next, phi, y)
	phi_S = np.matmul(phi, S)

	A_ = np.power(np.linalg.norm(mean), 2) + np.trace(S)
	B_ = np.power(np.linalg.norm( y - np.matmul(phi, mean)), 2) + np.trace(np.matmul(phi_S, phi.transpose()))

	return A_, B_, mean

def M_step(A, B, K, N):
	a_next = K / A
	b_next = N / B

	return a_next, b_next

def cov_matrix(a, b, phi):
    S = np.linalg.inv(a * np.eye(5, 5) + b * np.matmul(phi.transpose(), phi))
    return np.array(S)


def calculate_mean(S, b, phi, y):
    temp = np.matmul(S, phi.transpose())
    mean = b * np.matmul(temp, y)
    return np.array(mean)


def construct_phi(n, x):
    phi = np.ones((n, 5))
    phi[:, 1] = x.transpose()
    phi[:, 2] = x.transpose() ** 2
    phi[:, 3] = x.transpose() ** 3
    phi[:, 4] = x.transpose() ** 5
    return phi


def calculate_y(rows, columns, x, theta):
    y = np.ones((rows, columns))
    y[:, 0] = theta[0, 0] + \
              theta[1, 0] * x.transpose() + theta[2, 0] * x.transpose() ** 2 + \
              theta[3, 0] * x.transpose() ** 3 + theta[4, 0] * x.transpose() ** 5
    return y


if __name__ == "__main__":
    main()