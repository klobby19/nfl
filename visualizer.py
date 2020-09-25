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

def dline_physique_visual(save):
    data = pd.read_csv('dl_average_physique.csv')
    fig, (ax1,ax2) = plt.subplots(2,figsize=(20,15))
    fig.suptitle('Average Height and Weight of each NFL team')
    ax12 = ax1.twinx()
    ax1.plot(data['team'],data['DE height'],'--',color='lightsteelblue',label='Height')
    ax12.plot(data['team'],data['DE weight'],color='darksalmon',label='Weight')
    ax22 = ax2.twinx()
    ax2.plot(data['team'],data['DT height'],'--',color='lightsteelblue',label='Height')
    ax22.plot(data['team'],data['DT weight'],color='darksalmon',label='Weight')
    ax1.legend(loc=2)
    ax12.legend(loc=0)
    ax2.legend(loc=2)
    ax22.legend(loc=0)
    if save:
        plt.savefig('dlinephys.png')
    else:
        plt.show()

if __name__ == "__main__":
    dline_physique_visual(True)