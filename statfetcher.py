import pandas as pd
import urllib.request
import bs4 as bs
from bs4 import BeautifulSoup

linebackers = {}

def list_avg(list):
    sum = 0
    for num in list:
        sum += num
    return sum / len(list)

def average_age_csv():
    file = open('average_age.csv', 'a')
    file.truncate(0)
    intro = 'team,age'
    file.write(intro + '\n')
    for team in teams_list_espn:
        url = 'https://www.espn.com/nfl/team/roster/_/name/%s' % team
        data = pd.read_html(url)
        avg_age = 0
        for sub_team in data:
            age = pd.DataFrame(sub_team)['Age']
            avg_age += list_avg(age)

        avg_age = avg_age / len(data)
        string = str(team) + ',' + str(avg_age)

        file.write(string + '\n')
    file.close()

def average_speed_pos():
    url = 'https://en.wikipedia.org/wiki/40-yard_dash'
    df = pd.read_html(url)[1]
    df.to_csv('posstats.csv',index=False)

def average_speed_lb_team():
    for team in teams_list_espn:    
        url = 'https://www.espn.com/nfl/team/roster/_/name/%s/' % team
        df = pd.DataFrame(pd.read_html(url)[1])
        lb = []
        for row in df.iterrows():
            if row[1]['POS'] == 'LB':
                lb.append(row[1]['Name'])
        linebackers[team] = lb

teams_list_pfr = ['crd','atl','rav','buf','car','chi','cin','cle','dal','den','det','gnb','htx','clt','jax','kan','sdg',
            'ram','mia','min','nwe','nor','nyg','nyj','rai','phi','pit','sfo','sea','tam','oti','was']

teams_list_espn = ['ari','atl','bal','buf','car','chi','cin','cle','dal','den','det','gb','hou','ind','jax','kc','lac',
            'lar','mia','min','ne','no','nyg','nyj','lv','phi','pit','sf','sea','tb','ten','wsh']

teams_list_full = ['Arizona-Cardinals',
                    'Atlanta-Falcons',
                    'Baltimore-Ravens',
                    'Buffalo-Bills',
                    'Carolina-Panthers',
                    'Chicago-Bears',
                    'Cincinnati-Bengals',
                    'Dallas-Cowboys',
                    'Denver-Broncos',
                    'Detroit-Lions',
                    'Green-Bay-Packers',
                    'Houston-Texans',
                    'Indianapolis-Colts',
                    'Jacksonville-Jaguars',
                    'Kansas-City-Chiefs',
                    'Los-Angeles-Chargers',
                    'Los-Angeles-Rams',
                    'Miami-Dolphins',
                    'Minnesota-Vikings',
                    'New-England-Patriots',
                    'New-Orleans-Saints',
                    'New-York-Giants',
                    'New-York-Jets',
                    'Oakland-Raiders',
                    'Philadelphia-Eagles',
                    'Pittsburgh-Steelers',
                    'San-Francisco-49ers',
                    'Seattle-Seahawks',
                    'Tampa-Bay-Buccaneers',
                    'Tennessee-Titans',
                    'Washington-Redskins']

url = 'https://www.playerprofiler.com/nfl/jordyn-brooks-stats/'
page = urllib.request.urlopen(url)
soup = BeautifulSoup(page, 'html.parser')
div = soup.find_all('span')
for element in div:
    print(element)