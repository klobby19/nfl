import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.pyplot import figure
from matplotlib.offsetbox import OffsetImage, AnnotationBbox

plt.style.use('seaborn-deep')

def avg_list(list):
    sum = 0
    for num in list:
        sum += num
    return sum / len(list)

def remove_spaces(list):
    result = []
    for item in list:
        if item != '':
            result.append(item)
    return result

def average_age_visualize(save):
    data = pd.read_csv('Data/average_age.csv')
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
    ax.axhline(y=avg_list(df['age']), color='black')
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
    data = pd.read_csv('Data/dl_average_physique.csv')
    fig, (ax1,ax2) = plt.subplots(2,figsize=(20,15))
    fig.suptitle('Average Height and Weight of each NFL team')
    ax12 = ax1.twinx()
    ax1.plot(data['team'],data['DE height'],'--',color='lightsteelblue',label='Height')
    ax12.plot(data['team'],data['DE weight'],color='darksalmon',label='Weight')
    ax1.set_title('DE physique')
    ax22 = ax2.twinx()
    ax2.plot(data['team'],data['DT height'],'--',color='lightsteelblue',label='Height')
    ax22.plot(data['team'],data['DT weight'],color='darksalmon',label='Weight')
    ax2.set_title('DT physique')
    ax1.legend(loc=2)
    ax12.legend(loc=0)
    ax2.legend(loc=2)
    ax22.legend(loc=0)
    if save:
        plt.savefig('dlinephys.png')
    else:
        plt.show()

def dline_physique_by_team_sack_rate():
    df = pd.read_csv('dl_average_physique.csv')
    data = pd.read_html('https://www.footballoutsiders.com/stats/nfl/defensive-line/2020')[0]
    pass_prot_data = data['PASS PROTECTION']
    teams = pass_prot_data['Team']
    adj_sack_rate = pass_prot_data['Adjusted  Sack Rate']
    ordered_list = []
    teams_rate = {}
    for num in range(len(teams)):
        teams_rate[teams[num]] = adj_sack_rate[num]
    for team in df['team']:
        if team.upper() == 'WSH':
            ordered_list.append(float(teams_rate['WAS'].replace('%','')))
        else:
            ordered_list.append(float(teams_rate[team.upper()].replace('%','')))
    df['Sack Rate'] = ordered_list
    df = df.sort_values(by=['Sack Rate'])

def visualize_punts_vs_tds():
    df = pd.read_csv('punting_vs_td.csv')
    m, b = np.polyfit(df['punts'], df['td'], 1)
    plt.figure(figsize=(20,15))
    plt.scatter(df['punts'], df['td'],color='dodgerblue')
    plt.plot(df['punts'], m*df['punts'] + b, color='tomato')
    plt.xlim([0,50])
    plt.ylim([5,28])
    plt.ylabel('Total TDs')
    plt.xlabel('Number of punts')
    plt.savefig('puntingvstds.png')

if __name__ == "__main__":
    visualize_punts_vs_tds()