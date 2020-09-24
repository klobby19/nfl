import pandas as pd
import matplotlib.pyplot as plt
import numpy
from matplotlib.pyplot import figure
from matplotlib.offsetbox import OffsetImage, AnnotationBbox

plt.style.use('seaborn-deep')

def remove_spaces(list):
    result = []
    for item in list:
        if item != '':
            result.append(item)
    return result

def average_age_visualize(save):
    data = pd.read_csv('average_age.csv')
    df = pd.DataFrame(data)

    fig,ax = plt.subplots(figsize=(20,15))
    ax.title.set_text('Average age of each NFL team')

    for index in df.index:
        row = str(df.iloc[index]).split(' ')
        row = remove_spaces(row)
        team = row[1].replace('age', '').replace(' ','')
        age = row[2].replace('Name:', '')
        team = team.replace('\r\n', '\n').replace('\n','')
        image = team + '.png'
        ax.scatter(team, float(age), c='w')
        ab = AnnotationBbox(OffsetImage(plt.imread(image,0)), (team, float(age)),frameon=False)
        ax.add_artist(ab)
    if save:
        plt.savefig('avgage.png')
    else:
        plt.show()

def dline_visual(save):
    data = pd.read_csv('dline_stats.csv')
    fig = plt.subplot()
    figure(num=0, figsize=(20,15)) 
    plt.scatter(data['Team'], data['Power  Success'], c=numpy.random.rand(3,))
    if save:
        plt.savefig('dlinepower.png')
    else:
        plt.show()

if __name__ == "__main__":
    average_age_visualize(True)