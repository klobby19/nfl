import pandas as pd
import matplotlib.pyplot as plt
import numpy
plt.style.use('seaborn-deep')

def remove_spaces(list):
    result = []
    for item in list:
        if item != '':
            result.append(item)
    return result

def average_age_visualize():
    data = pd.read_csv('average_age.txt')
    df = pd.DataFrame(data)

    fig = plt.figure(figsize=(20,15))
    plt.title('Average age of each NFL team')
    for index in df.index:
        row = str(df.iloc[index]).split(' ')
        row = remove_spaces(row)
        team = row[1].replace('age', '').replace(' ','')
        age = row[2].replace('Name:', '')
        plt.scatter(team, float(age), c=numpy.random.rand(3,))

    plt.show()


