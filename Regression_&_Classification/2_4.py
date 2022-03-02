import os
import math
import matplotlib
import matplotlib.pyplot
import numpy


def main(file):
    epsilon = 1
    w = [0, 0, 0, 0, 0]
    epochs = 100000
    data = read(file)

# _________Iris-setosa_________ #
    setosa_training_set = []
    for i in data:
        if i[4] == 'Iris-setosa':
            setosa_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], 1])
        else:
            setosa_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], -1])

# _________Iris-versicolor_________ #
    versicolor_training_set = []
    for i in data:
        if i[4] == 'Iris-versicolor':
            versicolor_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], 1])
        else:
            versicolor_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], -1])

# _________Iris-virginica_________ #
    virginica_training_set = []
    for i in data:
        if i[4] == 'Iris-virginica':
            virginica_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], 1])
        else:
            virginica_training_set.append([-1, float(i[0]), float(i[1]), float(i[2]), float(i[3]), i[4], -1])

    print("\n_____Setosa_________")
    use_perceprton(epsilon, w, setosa_training_set, epochs)
    print("\n_____Versicolor_____")
    use_perceprton(epsilon, w, versicolor_training_set, epochs)
    print("\n_____Virginica______")
    use_perceprton(epsilon, w, virginica_training_set, epochs)


def use_perceprton(epsilon, w, training_set, epochs):
    errors = 1
    iteration = 0

    while errors > 0 and iteration < epochs:
        iteration += 1
        errors = 0
        for i in training_set:
            y = w[0] * i[0] + w[1] * i[1] + w[2] * i[2] + w[3] * i[3] + w[4] * i[4]
            if numpy.sign(y) != numpy.sign(i[6]):
                errors += 1
                for j in range(5):
                    w[j] = w[j] + epsilon * i[6] * i[j]
    print("Iteration : " + str(iteration))
    print("W = " + str(w))
    print("The number of errors is " + str(errors))
    print("The accuracy is " + str(100 - errors/len(training_set)) + "%")


def read(file):
    data = []
    with open(file, 'r') as data_set:
        for index, line in enumerate(data_set):
            for example in line.split():
                if example != "":
                    data.append([])
                    for feature in example.split(","):
                        data[index].append(feature)
    # print(data)
    # print(len(data))
    return data


if __name__ == '__main__':
    local_dir = os.path.dirname(__file__)
    file_path = os.path.join(local_dir, 'iris.data')
    main(file_path)
