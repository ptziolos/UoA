import os
import numpy
import matplotlib
import matplotlib.pyplot
import time


def main(file):
    start_time = time.time()
    print("\nIn this problem we use 5-fold cross validation")
    misclassifications = []
    for k in range(1, 112, 2):
        s = 0
        for i in range(5):
            data = read(file)
            sets = create_cross_validation_sets(data, i)
            classes = differentiate_classes(sets[0][0])
            mean_value_0 = calculate_mean_value(classes[0])
            mean_value_1 = calculate_mean_value(classes[1])
            covariance_matrix_0 = calculate_covariance_matrix(classes[0], mean_value_0)
            covariance_matrix_1 = calculate_covariance_matrix(classes[1], mean_value_1)
            types_collection = use_knn_method(sets, k, covariance_matrix_0, covariance_matrix_1)
            for index in range(len(types_collection[0][0])):
                if types_collection[0][0][index] != types_collection[0][1][index]:
                    s += 1
        misclassifications.append([k, s])
    print(misclassifications)
    minimum = 1000
    min_collection = []
    k_values = []
    er_values = []
    accuracy_percentage = []
    for i in misclassifications:
        if minimum > i[1]:
            min_collection.clear()
            minimum = i[1]
            min_collection.append(i[0])
        elif minimum == i[1]:
            min_collection.append(i[0])
        k_values.append(i[0])
        er_values.append(i[1])
        accuracy_percentage.append(100 - i[1]/5/1.53)
    percentage = 100 - minimum/5/1.53
    print("\nThe minimum number of total errors for this dataset is "+str(minimum))
    print("The values of k which have the minimum number of errors are "+str(min_collection))
    print("The percentage of success is "+str(percentage)+"%")
    print("--- %s seconds ---" % (time.time() - start_time))
    create_graph(k_values, accuracy_percentage)


def create_graph(k_values, er_values):
    fig, p = matplotlib.pyplot.subplots()
    p.plot(k_values, er_values, 'C0-*', label='errors', markersize=7)
    p.legend(loc='best', shadow=False, fontsize='medium')
    matplotlib.pyplot.grid(False)
    matplotlib.pyplot.xlabel('k')
    matplotlib.pyplot.ylabel('accuracy %')
    matplotlib.pyplot.title('Comparison of the accuracy for each value of k')
    matplotlib.pyplot.show()


def use_knn_method(sets, k, covariance_matrix_0, covariance_matrix_1):
    distances = []
    classified_type = []
    true_type = []
    for query_example in sets[0][1]:
        names = []
        true_type.append(query_example[len(sets[0][1][0])-1])
        for example in sets[0][0]:
            # Euclidean Distance
            d = calculate_euclidean_distance(query_example, example)

            # Mahalanobis Distance
            # d0 = calculate_mahalanobis_distance(query_example, example, covariance_matrix_0)
            # d1 = calculate_mahalanobis_distance(query_example, example, covariance_matrix_1)
            # if d0 < d1:
            #     d = d0
            # else:
            #     d = d1

            distances.append([d, example[len(sets[0][0][0])-1]])
        distances = sorted(distances, key=lambda l: l[0])
        for i in range(k):
            names.append(distances[i][1])
        classified_type.append(max(set(names), key=names.count))
        names.clear()
        distances.clear()
    return [(classified_type, true_type)]


def calculate_euclidean_distance(y0, y1):
    # Euclidean Distance
    x0 = numpy.zeros(len(y0)-1)
    x1 = numpy.zeros(len(y0)-1)
    for index in range(len(y0) - 1):
        x0[index] = y0[index]
        x1[index] = y1[index]
    d = numpy.linalg.norm(x0-x1)
    return d


def calculate_mahalanobis_distance(y0, y1, covariance_matrix):
    # Mahalanobis Distance
    covariance_matrix_inv = numpy.linalg.inv(covariance_matrix)
    x0 = numpy.zeros(len(y0)-1)
    x1 = numpy.zeros(len(y0)-1)
    for index in range(len(y0) - 1):
        x0[index] = y0[index]
        x1[index] = y1[index]
    arg = numpy.array(x0 - x1)
    d = numpy.sqrt(numpy.matmul(numpy.matmul(arg.transpose(), covariance_matrix_inv), arg))
    return d


def calculate_covariance_matrix(data, mean_value):
    a = numpy.zeros((len(data), len(data[0])-1))
    for i, example in enumerate(data):
        for j, feature in enumerate(example):
            if j != len(example)-1:
                a[i][j] = float(feature) - mean_value[j]
    covariance_matrix = numpy.matmul(a.transpose(), a)/len(data)
    return covariance_matrix


def calculate_mean_value(data):
    mean_value = numpy.zeros(len(data[0])-1)
    for example in data:
        for index, feature in enumerate(example):
            if index != len(example)-1:
                mean_value[index] += float(feature)
    mean_value = mean_value/len(data)
    return mean_value


def differentiate_classes(data):
    c1 = []
    c2 = []
    for example in data:
        if example[len(data[0])-1] == '0':
            c1.append(example)
        else:
            c2.append(example)
    return [c1, c2]


def create_cross_validation_sets(data, i):
    training_set = []
    testing_set = []
    ptr = 1
    interval = 153
    for example in data:
        if interval * i < ptr <= interval * (i+1):
            testing_set.append(example)
        else:
            training_set.append(example)
        ptr += 1
    return [(training_set, testing_set)]


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
