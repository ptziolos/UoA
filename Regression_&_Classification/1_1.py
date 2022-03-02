import numpy as np
import random as r
import matplotlib.pyplot

# (1.1) Least Square Method
def main():
    n_train_data = 20
    n_test_data = 1000
    mean = 0
    sigma = np.sqrt(0.1)
    theta_given = np.array([[0.2], [-1], [0.9], [0.7], [-0.2]])

    print("\ntheta real is : "+str(theta_given.transpose()))

    # Equidistance at (0,2) space
    x_train_data = np.linspace(0, 2, n_train_data).reshape((n_train_data, 1))

    # Calculate the y data with the given theta
    y_train_data = calculate_y(n_train_data, 1, x_train_data, theta_given)
	
    # Add the noise
    y_train_data_noisy = np.zeros((n_train_data, 1))
    for i in range(n_train_data):
        y_train_data_noisy[i, 0] = y_train_data[i, 0] + r.gauss(mean, sigma)


    # Calculate phi Array  in order to be able to use different methods for the
    # aclculation of theta 
    phi = construct_phi(n_train_data, x_train_data)

    #Calculate theta with the Least Square Method
    theta_predicted = calculate_theta_least_squared_method(phi, y_train_data_noisy)
    
    print("theta predicted is : " + str(theta_predicted.transpose())) 

    # Calculate the y with the new theta
    y_predicted = calculate_y(n_train_data, 1, x_train_data, theta_predicted)

    mse_train_data = calculate_mse(y_train_data_noisy, y_predicted)

    print("MSE of trained data: " + str(mse_train_data))

    # Starting the processing of Test Data
    x_test_data = np.zeros((n_test_data, 1))
    # Make the test data
    for i in range(n_test_data):
        x_test_data[i, 0] = np.random.uniform(0, 2)

    # Sort the Test Data
    x_test_data = np.sort(x_test_data.transpose()[0])

    # Transpose again to get them right
    x_test_data = np.array([x_test_data]).transpose()


    y_test_data = calculate_y(n_test_data, 1, x_test_data, theta_given)

    y_test_data_noisy = np.zeros((n_test_data, 1))
    for i in range(n_test_data):
        y_test_data_noisy[i, 0] = y_test_data[i, 0] + r.gauss(mean, sigma)

    y_predicted_test = calculate_y(n_test_data, 1, x_test_data, theta_predicted)

    mse_test_data = calculate_mse(y_test_data_noisy, y_predicted_test)

    print("MSE of test data:  " + str(mse_test_data))
    
    # y_test_data_error = np.zeros((n_test_data, 1))
    # for i in range(n_test_data):
    #     y_test_data_error[i, 0] = mse_test_data

    create_graph(x_test_data, y_test_data, y_test_data_noisy, y_predicted_test, mse_train_data, mse_test_data)


def create_graph(x, y, y_noisy, y_pred, mse_train, mse_test):
    fig, p = matplotlib.pyplot.subplots()
    fig.suptitle('Comparison of the curves : N = 1000')
    p.plot(x, y, 'C2-', label='True Curve')
    p.plot(x, y_noisy, 'C9x', label='Test Data', markersize=1)
    p.plot(x, y_pred, label='Prediction with LS', ls='--', c='orange')
    legend = p.legend(loc='best', shadow=False, fontsize='medium')
    legend.get_frame().set_facecolor('1')
    # p.set_xlabel('x')
    p.set_ylabel('Test Data')
    p.set_xlabel(['MSE Train:', str(mse_train), '  MSE Test:', str(mse_test)])
    matplotlib.pyplot.show()


def calculate_mse(y, y_new):
    if np.not_equal(np.size(y),np.size(y_new)):
        print("The calculation of MSE has error ")
    mse = 0
    for i in range(np.size(y)):
        mse += (y_new[i, 0] - y[i, 0]) ** 2 
    mse = mse/np.size(y)
    return mse    

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


def calculate_theta_least_squared_method(phi, y):
    # theta = (phi_transposed x phi)_inverted x phi_transposed x y
    b = np.matmul(phi.transpose(), phi)
    c = np.linalg.inv(b)
    d = np.matmul(c, phi.transpose())
    u = np.matmul(d, y)
    return u

if __name__ == "__main__":
    main()
