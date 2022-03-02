import numpy as np 
import random

# (1.3) Ridge Regression Method 
def main():
    n_train_data = 20
    n_test_data = 1000
    mean = 0
    sigma = np.sqrt(0.1)
    theta_given = np.array([[0.2], [-1], [0.9], [0.7], [-0.2]])
    
    print("theta real = " + str(theta_given.transpose()))
	
	# Equidistance at (0,2) space
    x_train_data = np.linspace(0, 2, n_train_data).reshape((n_train_data, 1))
    
	# Calculate the y data with the given theta
    y_train_data = calculate_y(n_train_data, 1, x_train_data, theta_given)

    #Add the noise
    y_train_data_noisy = add_noise(y_train_data,mean,sigma)


    # Calculate phi Array  in order to be able to use different methods for the
    # calculation of theta 
    phi = construct_phi(n_train_data, x_train_data)

    # Calculate theta with Ridge Regression starting with lamda = 0 (Like LSM)
    theta_predicted = calculate_theta_ridge_regression(phi, y_train_data_noisy, 0)
    
    print("theta predicted is : " + str(theta_predicted.transpose())) 

    # Calculate the y with the new theta
    y_predicted = calculate_y(n_train_data, 1, x_train_data, theta_predicted)

    # Calculate MSE for the train data

    mse_train_data = calculate_mse(y_train_data_noisy, y_predicted)

    print("MSE of trained data is: " + str(mse_train_data))

 	# Starting the processing of Test Data   
    # Make the test data
    x_test_data = np.array([random.uniform(0, 2) for i in range(n_test_data)]).reshape((n_test_data, 1))

    y_test_data = calculate_y(n_test_data, 1, x_test_data, theta_given)

    y_test_data_noisy = add_noise(y_test_data,mean,sigma)

    y_predicted_test = calculate_y(n_test_data, 1, x_test_data, theta_predicted)

    mse_test_data = calculate_mse( y_test_data_noisy, y_predicted_test)

    print("MSE of test data is:  " + str(mse_test_data))

	# Finding lambdas    
    mse_lambda = []
    lambda_ = 0 
    while lambda_ < 5:

        # Calculate the y data with the given theta
        y_train_data = calculate_y(n_train_data, 1, x_train_data, theta_given)

        #Add the noise
        y_train_data_noisy = add_noise(y_train_data,mean,sigma)

        # Estimate lambda calculating theta
        theta_rr = calculate_theta_ridge_regression(phi, y_train_data_noisy, lambda_)
        
        # Estimate y
        y_trained_rr = calculate_y(n_train_data, 1, x_train_data, theta_rr)
        
        # Find new mse to see if minimized
        mse_trained_rr = calculate_mse(y_train_data_noisy, y_trained_rr)

        # Same for test data

        y_test_data = calculate_y(n_test_data, 1, x_test_data, theta_given)

        y_test_data_noisy = add_noise(y_test_data,mean,sigma)

        y_tested_rr = calculate_y(n_test_data, 1, x_test_data, theta_rr)
        
        mse_tested_rr = calculate_mse(y_test_data_noisy, y_tested_rr)

        mse_lambda.append((lambda_, mse_trained_rr, mse_tested_rr, theta_rr))
        lambda_ += 0.01


    # print("List of lambdas:")
    # print(mse_lambda)
    
    minMSE = np.inf;
    minMSE2 = np.inf;
    min_tested_tuple = ();
    min_trained_tuple = ();
    # print("Number of tupples: \n" + str(len(mse_lambda)))

    for i in range(len(mse_lambda)):
        if minMSE > mse_lambda[i][2]:
            minMSE = mse_lambda[i][2]
            min_tested_tuple = mse_lambda[i]

        if minMSE2 > mse_lambda[i][1]:
            minMSE2 = mse_lambda[i][1]
            min_trained_tuple = mse_lambda[i]

    print("Min tested is")
    print(min_tested_tuple[0])
    print(min_tested_tuple[1])
    print(min_tested_tuple[2])
    print("\n " + str(min_tested_tuple[3]))

    print("Min trained is")
    print(min_trained_tuple)
    print("\n " + str(min_trained_tuple[3]))



    # if len(lamda_train) > 0:
    #     print("The lamdas which minimize the trained MSE are ")
    #     for i in lamda_train:
    #         print(i)
    # if len(lamda_test) > 0:
    #     print("The lamdas which minimize the tested MSE are ")
    #     for i in lamda_test:
    #         print(i)
    # if len(lamda_train) == 0 and len(lamda_test) == 0:
    #     print("There is no lamda which minimizes the MSE, so lamda sould be zero")


def calculate_mse(y, y_new):
    mse = 0
    for i in range(len(y)):
        mse += (y[i, 0] - y_new[i, 0]) ** 2 
    mse = mse/len(y)
    return mse

def add_noise(y,mean,sigma):
    y_noise = y
    for i in range(len(y)):
        #y_noise[i,0] = y_noise[i,0] + np.random.normal(mean,sigma,1)
        y_noise[i,0] = y_noise[i,0] + random.gauss(mean,sigma)
    return y_noise
    
def construct_phi(rows, x):
    phi = np.ones((rows, 5))
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


def calculate_theta_ridge_regression(phi, y, lamda):
    # theta = (phi_transposed x phi + lamdaI)_inverted x phi_transposed x y
    I = np.eye(5, 5) # returns matrix I
    LI = I * lamda
    a = np.matmul(phi.transpose(), phi)
    # TODO: Edw mhpws thelei + 
    # b = a - LI
    b = a + LI 
    c = np.linalg.inv(b)
    d = np.matmul(c, phi.transpose())
    u = np.matmul(d, y)
    return u


if __name__ == "__main__":
	main()
