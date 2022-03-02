import os
import matplotlib
import matplotlib.pyplot
import numpy
import time


def main(file):
    start_time = time.time()
    print("\nIn this problem we use 5-fold cross validation")
    prob_a_accuracy = 0
    prob_b_accuracy = 0
    prob_c_accuracy = 0
    prob_d_accuracy = 0
    for i in range(5):
        data = read(file)
        sets = create_cross_validation_sets(data, i)
        classes = differentiate_classes(sets[0][0])

        # --<-__________________________________________\\ Class0 //__________________________________________->--
        mean_value_0 = calculate_mean_value(classes[0])

        # ________Σ=Iσ2________
        sigma_estimator_0 = calculate_sigma_estimator(classes[0], mean_value_0)

        # ________Σ!=Iσ2________
        covariance_matrix_0 = calculate_covariance_matrix(classes[0], mean_value_0)

        # ________σ2________
        variance_0 = calculate_variance(classes[0], mean_value_0)

        # --<-__________________________________________\\ Class1 //__________________________________________->--
        mean_value_1 = calculate_mean_value(classes[1])

        # ________Σ=Iσ2________
        sigma_estimator_1 = calculate_sigma_estimator(classes[1], mean_value_1)

        # ________Σ!=Iσ2________
        covariance_matrix_1 = calculate_covariance_matrix(classes[1], mean_value_1)

        # ________σ2________
        variance_1 = calculate_variance(classes[1], mean_value_1)

        # --<-__________________________________________\\ Class2 //__________________________________________->--
        mean_value_2 = calculate_mean_value(classes[2])

        # ________Σ=Iσ2________
        sigma_estimator_2 = calculate_sigma_estimator(classes[2], mean_value_2)

        # ________Σ!=Iσ2________
        covariance_matrix_2 = calculate_covariance_matrix(classes[2], mean_value_2)

        # ________σ2________
        variance_2 = calculate_variance(classes[2], mean_value_2)

        # ____________________________________________________________________________
        prob_a_accuracy += calculate_prob_a(mean_value_0, mean_value_1, mean_value_2, sets[0][1])
        prob_b_accuracy += calculate_prob_b(mean_value_0, covariance_matrix_0, mean_value_1, covariance_matrix_1,
                                            mean_value_2, covariance_matrix_2, sets[0][1])
        prob_c_accuracy += calculate_prob_c(mean_value_0, variance_0, mean_value_1, variance_1,
                                            mean_value_2, variance_2, sets[0][1])
        prob_d_accuracy += calculate_prob_d(variance_0, variance_1, variance_2, len(data),
                                            classes[0], classes[1], classes[2], sets[0][1])

    print()
    prob_a_accuracy = prob_a_accuracy / 5
    print("The accuracy of problem's a method is "+str(prob_a_accuracy))
    prob_b_accuracy = prob_b_accuracy / 5
    print("The accuracy of problem's b method is "+str(prob_b_accuracy))
    prob_c_accuracy = prob_c_accuracy / 5
    print("The accuracy of problem's c method is " + str(prob_c_accuracy))
    prob_d_accuracy = prob_d_accuracy / 5
    print("The accuracy of problem's d method is " + str(prob_d_accuracy))
    print("--- %s seconds ---" % (time.time() - start_time))


def calculate_prob_a(mean_value_0, mean_value_1, mean_value_2, test_set):
    # Euclidean Distance
    misclassifications = 0
    for query_example in test_set:
        x = numpy.zeros(len(mean_value_0))
        for index in range(len(query_example) - 1):
            x[index] = query_example[index]
        d0 = numpy.linalg.norm(x-mean_value_0)
        d1 = numpy.linalg.norm(x-mean_value_1)
        d2 = numpy.linalg.norm(x-mean_value_2)
        if d0 < d1 and d0 < d2:
            if query_example[len(query_example) - 1] != "Iris-setosa":
                misclassifications += 1
        elif d1 < d0 and d1 < d2:
            if query_example[len(query_example) - 1] != "Iris-versicolor":
                misclassifications += 1
        elif d2 < d0 and d2 < d1:
            if query_example[len(query_example) - 1] != "Iris-virginica":
                misclassifications += 1
    return 100-(misclassifications/len(test_set))*100


def calculate_prob_b(mean_value_0, covariance_matrix_0, mean_value_1, covariance_matrix_1,
                                                        mean_value_2, covariance_matrix_2, test_set):
    # Mahalanobis Distance
    covariance_matrix_inv_0 = numpy.linalg.inv(covariance_matrix_0)
    covariance_matrix_inv_1 = numpy.linalg.inv(covariance_matrix_1)
    misclassifications = 0
    for query_example in test_set:
        x = numpy.zeros(len(mean_value_0))
        for index in range(len(query_example) - 1):
            x[index] = query_example[index]
        arg0 = numpy.array(x - mean_value_0)
        d0 = numpy.sqrt(numpy.matmul(numpy.matmul(arg0.transpose(), covariance_matrix_inv_0), arg0))
        arg1 = numpy.array(x - mean_value_1)
        d1 = numpy.sqrt(numpy.matmul(numpy.matmul(arg1.transpose(), covariance_matrix_inv_1), arg1))
        arg2 = numpy.array(x - mean_value_2)
        d2 = numpy.sqrt(numpy.matmul(numpy.matmul(arg2.transpose(), covariance_matrix_inv_1), arg2))
        if d0 < d1 and d0 < d2:
            if query_example[len(query_example) - 1] != "Iris-setosa":
                misclassifications += 1
        elif d1 < d0 and d1 < d2:
            if query_example[len(query_example) - 1] != "Iris-versicolor":
                misclassifications += 1
        elif d2 < d0 and d2 < d1:
            if query_example[len(query_example) - 1] != "Iris-virginica":
                misclassifications += 1
    return 100 - (misclassifications / len(test_set)) * 100


def gaussian(mean, sigma2, x):
    g = (1/numpy.sqrt(2*numpy.pi*sigma2))*numpy.exp((-1)*(numpy.power(x-mean, 2)/(2*sigma2)))
    return g


def calculate_prob_c(mean_value_0, variance_0, mean_value_1, variance_1, mean_value_2, variance_2, test_set):
    # Naive Bayes for Gaussian PDF
    misclassifications = 0
    for query_example in test_set:
        p0 = 1
        p1 = 1
        p2 = 1
        for index in range(len(query_example) - 1):
            p0 = p0 * gaussian(mean_value_0[index], variance_0[index], float(query_example[index]))
            p1 = p1 * gaussian(mean_value_1[index], variance_1[index], float(query_example[index]))
            p2 = p2 * gaussian(mean_value_2[index], variance_2[index], float(query_example[index]))
        if p0 > p1 and p0 > p2:
            if query_example[len(query_example) - 1] != "Iris-setosa":
                misclassifications += 1
        elif p1 > p0 and p1 > p2:
            if query_example[len(query_example) - 1] != "Iris-versicolor":
                misclassifications += 1
        elif p2 > p1 and p2 > p0:
            if query_example[len(query_example) - 1] != "Iris-virginica":
                misclassifications += 1
    return 100 - (misclassifications / len(test_set)) * 100


def parzen_kernel(h2, x, xi):
    k = (1/numpy.power(2*numpy.pi*h2, 1/2)) * numpy.exp((-1)*(numpy.power(x-xi, 2)/(2*h2)))
    return k


def calculate_prob_d(variance_0, variance_1, variance_2, n, class_0, class_1, class_2, test_set):
    # Naive Bayes for Parzen windows with Gaussian kernels
    # for the optimal h = (1.06 * n^(-1/5) * sigma) we get worse results
    misclassifications = 0
    for query_example in test_set:
        p0 = 1
        p1 = 1
        p2 = 1
        k0 = 0
        k1 = 0
        k2 = 0
        for index in range(len(query_example) - 1):
            h0 = 1.06 * numpy.power(n, -1/5) * numpy.sqrt(variance_0[index])
            h1 = 1.06 * numpy.power(n, -1/5) * numpy.sqrt(variance_1[index])
            h2 = 1.06 * numpy.power(n, -1/5) * numpy.sqrt(variance_2[index])
            h0square = numpy.power(h0, 2)
            h1square = numpy.power(h1, 2)
            h2square = numpy.power(h2, 2)
            for example in class_0:
                k0 += parzen_kernel(n, float(query_example[index]), float(example[index]))
            p0 = p0 * k0 * numpy.power(n, 3/2)
            for example in class_1:
                k1 += parzen_kernel(n, float(query_example[index]), float(example[index]))
            p1 = p1 * k1 * numpy.power(n, 3/2)
            for example in class_2:
                k2 += parzen_kernel(n, float(query_example[index]), float(example[index]))
            p2 = p2 * k2 * numpy.power(n, 3/2)

        if p0 > p1 and p0 > p2:
            if query_example[len(query_example) - 1] != "Iris-setosa":
                misclassifications += 1
        elif p1 > p0 and p1 > p2:
            if query_example[len(query_example) - 1] != "Iris-versicolor":
                misclassifications += 1
        elif p2 > p1 and p2 > p0:
            if query_example[len(query_example) - 1] != "Iris-virginica":
                misclassifications += 1
    return 100 - (misclassifications / len(test_set)) * 100


def create_cross_validation_sets(data, i):
    training_set = []
    testing_set = []
    ptr = 1
    interval = 10
    for example in data:
        if interval * i < ptr <= interval * (i+1):
            testing_set.append(example)
        else:
            training_set.append(example)
        if ptr == 50:
            ptr = 1
        else:
            ptr += 1
    return [(training_set, testing_set)]


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
    c3 = []
    for example in data:
        if example[len(data[0])-1] == 'Iris-setosa':
            c1.append(example)
        elif example[len(data[0])-1] == 'Iris-versicolor':
            c2.append(example)
        elif example[len(data[0])-1] == 'Iris-virginica':
            c3.append(example)
    return [c1, c2, c3]


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
    file_path = os.path.join(local_dir, 'iris.data')
    main(file_path)
