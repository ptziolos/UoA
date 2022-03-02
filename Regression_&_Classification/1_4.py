import numpy as np
import random as r
import matplotlib.pyplot

# (1.4) Bayesian Inference 
def main():
    n_train = 500
    n_test = 20
    sigma_noise_1 = np.sqrt(0.05)
    sigma_noise_2 = np.sqrt(0.15)
    sigma_theta = np.sqrt(0.1)
    theta = np.array([[0.2], [-1], [0.9], [0.7], [-0.2]])

    # Real Curve
    q = np.linspace(0, 2, 200).reshape((200, 1))
    y_real = calculate_y(200, 1, q, theta)


    # Training Set
    x_train = create_x(n_train)

    # Testing Set
    x_test = create_x(n_test)
    
    # Finding y from given theta and training set
    y = calculate_y(n_train, 1, x_train, theta)

    # Adding noise using different sigmas 
    y_noisy_1 = np.zeros((n_train, 1))
    y_noisy_2 = np.zeros((n_train, 1))
    
    for i in range(n_train):
        y_noisy_1[i, 0] = y[i, 0] + noise(sigma_noise_1)
        y_noisy_2[i, 0] = y[i, 0] + noise(sigma_noise_2)


    # Fhi Matrix
    phi = construct_phi(n_train, x_train)

    # Bayesian Inference s_n = 0.05
    mean_1, variance_1 = bayesian_inference(x_test, theta, sigma_theta, sigma_noise_1, y_noisy_1, n_test, phi)  
    
    # Bayesian Inference s_n = 0.15
    mean_2, variance_2 = bayesian_inference(x_test, theta, sigma_theta, sigma_noise_2, y_noisy_2, n_test, phi)
    
    print("variance 1: " + str(variance_1))
    print("\n variance 2: " + str(variance_2))
    
    # Plotting
    create_graph(q, y_real, x_test, mean_1, mean_2, variance_1, variance_2)

def bayesian_inference(x_test, theta, sigma_theta, sigma_noise, y_noisy, n_test, phi):
    mean = np.zeros((n_test, 1))
    variance = np.zeros((n_test, 1))
   
    for i in range(n_test):
        mean[i, 0] = calculate_mean_of_y(x_test[i, 0], theta, sigma_noise, sigma_theta, phi, y_noisy)

    for i in range(n_test):
        variance[i, 0] = calculate_variance_of_y(x_test[i, 0], sigma_noise, sigma_theta, phi)

    return mean, variance

def noise(sigma_noise):
    return r.gauss(0, np.power(sigma_noise, 2))


def create_x(n):
    x = np.zeros((n, 1))
    for i in range(n):
        x[i, 0] = r.uniform(0, 2)
    x = np.sort(x.transpose()[0])
    x = np.array([x]).transpose()
    return x

def create_graph(q, y_real, x_test, mean_1, mean_2, variance_1, variance_2):
    fig, (p1, p2) = matplotlib.pyplot.subplots(2, 1)

    fig.suptitle('Compare different sigmas of the noise')
    p1.set_ylabel(' σ = 0.05 ')
    p1.plot(q, y_real, 'C0:', label='Real Curve')
    p1.plot(x_test, mean_1, 'b*', markersize=2, label="Y Predicted")
    p1.errorbar(x_test, mean_1, np.concatenate(np.sqrt(variance_1)), label='Error', ls='', c='orange')

    
    p1.set_xlim([0, 2])
    p1.set_ylim([-0.2, 2])

    legend = p1.legend(loc='best', shadow=False, fontsize='medium')
    legend.get_frame().set_facecolor('1')

    p2.set_ylabel(' σ = 0.15 ')
    p2.plot(q, y_real, 'C0:', label='Real Curve')
    p2.plot(x_test, mean_2, 'b*', markersize=2, label="Y Predicted")
    p2.errorbar(x_test, mean_2, np.concatenate(np.sqrt(variance_2)), label='Error', ls='', c='orange')

    legend = p2.legend(loc='best', shadow=False, fontsize='medium')
    legend.get_frame().set_facecolor('1')

    p2.set_xlim([0, 2])
    p2.set_ylim([-0.2, 2])

    matplotlib.pyplot.show()




def calculate_variance_of_y(x, sigma_noise, sigma_theta, phi):
    small_phi = construct_small_phi(x)
    a = np.power(sigma_noise, 2) * np.power(sigma_theta, 2) * small_phi.transpose()
    b = np.power(sigma_noise, 2) * np.eye(5, 5)
    c = np.power(sigma_theta, 2) * np.matmul(phi.transpose(), phi)
    d = np.linalg.inv(b + c)
    e = np.matmul(a, d)
    variance = np.matmul(e, small_phi)
    variance += np.power(sigma_noise, 2)
    return variance


def calculate_mean_of_y(x, theta, sigma_noise, sigma_theta, phi, y):
    small_phi = construct_small_phi(x)
    conditional_mean = calculate_conditional_mean(theta, sigma_noise, sigma_theta, phi, y)
    mean = np.matmul(small_phi.transpose(), conditional_mean)
    return mean


def calculate_conditional_mean(theta, sigma_noise, sigma_theta, phi, y):
    a = (1/np.power(sigma_theta, 2)) * np.eye(5, 5)
    b = (1/np.power(sigma_noise, 2)) * np.matmul(phi.transpose(), phi)
    c = (1/np.power(sigma_noise, 2)) * np.linalg.inv(a + b)
    d = np.matmul(c, phi.transpose())
    e = y - np.matmul(phi, theta)
    conditional_mean = np.matmul(d, e)
    conditional_mean += theta
    return conditional_mean


def construct_small_phi(x):
    small_phi = np.ones((5, 1))
    small_phi[1, :] = x.transpose()
    small_phi[2, :] = x.transpose() ** 2
    small_phi[3, :] = x.transpose() ** 3
    small_phi[4, :] = x.transpose() ** 5
    return small_phi


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