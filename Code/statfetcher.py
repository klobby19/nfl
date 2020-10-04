import pandas as pd
import urllib.request
import bs4 as bs
from bs4 import BeautifulSoup

linebackers = {}

team_full_to_short = {}

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
                    'Cleveland-Browns',
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

def convert_ft_inches(num):
    result = 0
    height = num.split('\'')
    result += float(height[0]) * 12
    result += float(height[1].replace(' ','').replace('\"',''))
    return result

def connect_team_name():
    for index in range(len(teams_list_full)):
        team_full_to_short[teams_list_full[index]] = teams_list_espn[index]

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

def dline_stats():
    url = 'https://www.footballoutsiders.com/stats/nfl/defensive-line/2020'
    data = pd.read_html(url)[0]
    data.to_csv('dline_stats.csv',index=False)

def dline_physique():
    file = open('average_physique.csv', 'a')
    file.truncate(0)
    intro = 'team,DE height,DE weight,DT height,DT weight'
    file.write(intro + '\n')
    for team in teams_list_espn:
        url = 'https://www.espn.com/nfl/team/roster/_/name/%s/' % team
        data = pd.DataFrame(pd.read_html(url)[1])
        # dend = {}
        # dtackle = {}
        total_weight_end = []
        total_height_end = []
        total_weight_tackle = []
        total_height_tackle = []
        for row in data.iterrows():
            # stat = []
            # stat.append(row[1]['HT'])
            # stat.append(row[1]['WT'])
            if row[1]['POS'] == 'DE':
                    # dend[row[1]['Name']] = stat
                    total_weight_end.append(float(row[1]['WT'].split(' ')[0]))
                    total_height_end.append(convert_ft_inches(row[1]['HT']))
            if row[1]['POS'] == 'DT':
                    # dtackle[row[1]['Name']] = stat
                    total_weight_tackle.append(float(row[1]['WT'].split(' ')[0]))
                    total_height_tackle.append(convert_ft_inches(row[1]['HT']))
            # stat.clear
        string = str(team) + ',' + str(list_avg(total_height_end)) + ',' + str(list_avg(total_weight_end)) + ',' + str(list_avg(total_height_tackle)) + ',' + str(list_avg(total_weight_tackle))
        file.write(string + '\n')
    file.close()

def logo_fetch():
    for team in team_full_to_short:
        url = 'http://loodibee.com/wp-content/uploads/nfl-%s-team-logo-2.png' % team.lower()
        save_name = team_full_to_short.get(team) + '.png'
        try:
            urllib.request.urlretrieve(url, save_name)
        except:
            print(team + ' did not have a logo')

if __name__ == "__main__":
    # url = 'https://www.playerprofiler.com/nfl/jordyn-brooks-stats/'
    # page = urllib.request.urlopen(url)
    # soup = BeautifulSoup(page, 'html.parser')
    # div = soup.find_all('span')
    # for element in div:
    #     print(element)
    # data = pd.read_html('https://www.espn.com/nfl/team/schedule/_/name/sea')
    # print(data)

    # for team in teams_list_pfr:
    #     url = 'https://www.pro-football-reference.com/teams/%s/2020.htm' % team
    #     data = pd.read_html(url)
    #     print(data)
    # response = urllib.request.urlopen('https://www.pro-football-reference.com/teams/sea/2020.htm')
    # html = response.read()
    # soup = BeautifulSoup(html,features='lxml')

    # table = soup.find("div", {"id": "all_defense"})

    # print(pd.read_html(table))
    connect_team_name()
    logo_fetch()
