import os
import matplotlib
import matplotlib.pyplot
import numpy
import time


def main(file):
    start_time = time.time()

    data = read(file)
    classes = differentiate_classes(data)

    # --<-__________\\Class0//__________->--
    mean_value_0 = calculate_mean_value(classes[0])

    # ________Σ=Iσ2________
    sigma_estimator_0 = calculate_sigma_estimator(classes[0], mean_value_0)

    # ________Σ!=Iσ2________
    covariance_matrix_0 = calculate_covariance_matrix(classes[0], mean_value_0)

    # ________σ2________
    variance_0 = calculate_variance(classes[0], mean_value_0)

    print("\n________Class0__________")
    print("\nmean = " + str(mean_value_0))
    print("\nsigma estimator = " + str(sigma_estimator_0))
    print("\nCovariance Matrix:")
    print(covariance_matrix_0)
    print("\nVariance:")
    print(variance_0)

    # --<-__________\\Class1//__________->--
    mean_value_1 = calculate_mean_value(classes[1])

    # ________Σ=Iσ2________
    sigma_estimator_1 = calculate_sigma_estimator(classes[1], mean_value_1)

    # ________Σ!=Iσ2________
    covariance_matrix_1 = calculate_covariance_matrix(classes[1], mean_value_1)

    # ________σ2________
    variance_1 = calculate_variance(classes[1], mean_value_1)

    print("\n________Class1__________")
    print("\nmean = " + str(mean_value_1))
    print("\nsigma estimator = " + str(sigma_estimator_1))
    print("\nCovariance Matrix:")
    print(covariance_matrix_1)
    print("\nVariance:")
    print(variance_1)

    # --<-__________________________________________\\ Class0 //__________________________________________->--

    print("\n________Class0__________")

    n_a_0 = len(classes[0])
    k_a_0 = 9
    aic_a_0 = -2 * calculate_log_likelihood_a(sigma_estimator_0, mean_value_0, classes[0]) \
              + 2 * k_a_0 + (2 * k_a_0 + 1) / (n_a_0 - k_a_0 - 1)
    bic_a_0 = -2 * calculate_log_likelihood_a(sigma_estimator_0, mean_value_0, classes[0]) \
              + k_a_0 * numpy.log(n_a_0)
    print("\nThe AIC for prob_a is : " + str(aic_a_0))
    print("The BIC for prob_a is : " + str(bic_a_0))

    n_b_0 = len(classes[0])
    k_b_0 = 44
    aic_b_0 = -2 * calculate_log_likelihood_b(covariance_matrix_0, mean_value_0, classes[0]) \
              + 2 * k_b_0 + (2 * k_b_0 + 1) / (n_b_0 - k_b_0 - 1)
    bic_b_0 = -2 * calculate_log_likelihood_b(covariance_matrix_0, mean_value_0, classes[0]) \
              + k_b_0 * numpy.log(n_b_0)
    print("\nThe AIC for prob_b is : " + str(aic_b_0))
    print("The BIC for prob_b is : " + str(bic_b_0))

    n_c_0 = len(classes[0])
    k_c_0 = 16
    aic_c_0 = -2 * calculate_log_likelihood_c(variance_0, mean_value_0, classes[0]) \
              + 2 * k_c_0 + (2 * k_c_0 + 1) / (n_c_0 - k_c_0 - 1)
    bic_c_0 = -2 * calculate_log_likelihood_c(variance_0, mean_value_0, classes[0]) \
              + k_c_0 * numpy.log(n_c_0)
    print("\nThe AIC for prob_c is : " + str(aic_c_0))
    print("The BIC for prob_c is : " + str(bic_c_0))

    h_0 = len(classes[0])
    n_d_0 = len(classes[0])
    k_d_0 = 1
    aic_d_0 = -2 * calculate_log_likelihood_d(h_0, classes[0]) \
              + 2 * k_d_0 + (2 * k_d_0 + 1) / (n_d_0 - k_d_0 - 1)
    bic_d_0 = -2 * calculate_log_likelihood_d(h_0, classes[0]) \
              + k_d_0 * numpy.log(n_d_0)
    print("\nThe AIC for prob_d is : " + str(aic_d_0))
    print("The BIC for prob_d is : " + str(bic_d_0))

    # --<-__________________________________________\\ Class1 //__________________________________________->--
    print("\n________Class1__________")
    n_a_1 = len(classes[1])
    k_a_1 = 9
    aic_a_1 = -2 * calculate_log_likelihood_a(sigma_estimator_1, mean_value_1, classes[1]) \
              + 2 * k_a_1 + (2 * k_a_1 + 1) / (n_a_1 - k_a_1 - 1)
    bic_a_1 = -2 * calculate_log_likelihood_a(sigma_estimator_1, mean_value_1, classes[1]) \
              + k_a_1 * numpy.log(n_a_1)
    print("\nThe AIC for prob_a is : " + str(aic_a_1))
    print("The BIC for prob_a is : " + str(bic_a_1))

    n_b_1 = len(classes[1])
    k_b_1 = 44
    aic_b_1 = -2 * calculate_log_likelihood_b(covariance_matrix_1, mean_value_1, classes[1]) \
              + 2 * k_b_1 + (2 * k_b_1 + 1) / (n_b_1 - k_b_1 - 1)
    bic_b_1 = -2 * calculate_log_likelihood_b(covariance_matrix_1, mean_value_1, classes[1]) \
              + k_b_1 * numpy.log(n_b_1)
    print("\nThe AIC for prob_b is : " + str(aic_b_1))
    print("The BIC for prob_b is : " + str(bic_b_1))

    n_c_1 = len(classes[1])
    k_c_1 = 16
    aic_c_1 = -2 * calculate_log_likelihood_c(variance_1, mean_value_1, classes[1]) \
              + 2 * k_c_1 + (2 * k_c_1 + 1) / (n_c_1 - k_c_1 - 1)
    bic_c_1 = -2 * calculate_log_likelihood_c(variance_1, mean_value_1, classes[1]) \
              + k_c_1 * numpy.log(n_c_1)
    print("\nThe AIC for prob_c is : " + str(aic_c_1))
    print("The BIC for prob_c is : " + str(bic_c_1))

    h_1 = len(classes[1])
    n_d_1 = len(classes[1])
    k_d_1 = 1
    aic_d_1 = -2 * calculate_log_likelihood_d(h_1, classes[1]) \
              + 2 * k_d_1 + (2 * k_d_1 + 1) / (n_d_1 - k_d_1 - 1)
    bic_d_1 = -2 * calculate_log_likelihood_d(h_1, classes[1]) \
              + k_d_1 * numpy.log(n_d_1)
    print("\nThe AIC for prob_d is : " + str(aic_d_1))
    print("The BIC for prob_d is : " + str(bic_d_1))

    # ____________________________________________________________________________
    print("\n--- %s seconds ---" % (time.time() - start_time))


def calculate_log_likelihood_a(sigma2, mean, data):
    ll = 0
    x = numpy.zeros(len(mean))
    for example in data:
        for index in range(len(example) - 1):
            x[index] = example[index]
        ll += (-(len(example)-1)/2) * numpy.log(2*numpy.pi*sigma2) \
              - numpy.power(numpy.linalg.norm(x-mean), 2)/(2*sigma2)
    return ll


def calculate_log_likelihood_b(covariance_matrix, mean, data):
    covariance_matrix_inv = numpy.linalg.inv(covariance_matrix)
    ll = 0
    x = numpy.zeros(len(mean))
    for example in data:
        for index in range(len(example) - 1):
            x[index] = example[index]
        arg = numpy.array(x - mean)
        ll += (-(len(example)-1)/2) * numpy.log(2*numpy.pi) - (1/2) * numpy.log(numpy.linalg.det(covariance_matrix)) \
            - numpy.sqrt(numpy.matmul(numpy.matmul(arg.transpose(), covariance_matrix_inv), arg))
    return ll


def calculate_log_likelihood_c(variance, mean, data):
    ll = 0
    for example in data:
        for index in range(len(example) - 1):
            ll += (-1/2) * numpy.log(2*numpy.pi*variance[index]) \
                  - numpy.power(float(example[index])-mean[index], 2)/(2*variance[index])
    return ll


def calculate_log_likelihood_d(h2, data):
    ll = 0
    for example in data:
        for i in range(len(example)-1):
            k = 0
            for j in range(len(data)):
                k += (1/numpy.sqrt(2*numpy.pi*h2)) \
                     * numpy.exp((-1)*(numpy.power(float(example[i])-float(data[j][i]), 2)/(2*h2)))
            ll += -numpy.log(len(data)*h2) + numpy.log(k)
    return ll


def calculate_mean_value(data):
    mean_value = numpy.zeros(len(data[0])-1)
    for example in data:
        for index, feature in enumerate(example):
            if index != len(example)-1:
                mean_value[index] += float(feature)
    mean_value = mean_value/len(data)
    return mean_value


def calculate_sigma_estimator(data, mean_value):
    sigma_estimator = 0
    for example in data:
        for index, feature in enumerate(example):
            if index != len(example) - 1:
                sigma_estimator += numpy.power(float(feature) - mean_value[index], 2)
    sigma_estimator = sigma_estimator/len(data)
    return sigma_estimator


def calculate_covariance_matrix(data, mean_value):
    a = numpy.zeros((len(data), len(data[0])-1))
    for i, example in enumerate(data):
        for j, feature in enumerate(example):
            if j != len(example)-1:
                a[i][j] = float(feature) - mean_value[j]
    covariance_matrix = numpy.matmul(a.transpose(), a)/len(data)
    return covariance_matrix


def calculate_variance(data, mean_value):
    variance = numpy.zeros(len(data[0])-1)
    for example in data:
        for index, feature in enumerate(example):
            if index != len(example)-1:
                variance[index] += numpy.power(float(feature) - mean_value[index], 2)
    variance = variance/len(data)
    return variance


def differentiate_classes(data):
    c1 = []
    c2 = []
    for example in data:
        if example[len(data[0])-1] == '0':
            c1.append(example)
        else:
            c2.append(example)
    return [c1, c2]


def read(file):
    data = []
    with open(file, 'r') as data_set:
        for index, line in enumerate(data_set):
            for example in line.split():
                if example != "":
                    data.append([])
                    for feature in example.split(","):
                        data[index].append(feature)
    return data


if __name__ == '__main__':
    local_dir = os.path.dirname(__file__)
    file_path = os.path.join(local_dir, 'pima-indians-diabetes.data')
    main(file_path)
