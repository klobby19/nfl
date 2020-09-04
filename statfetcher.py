import pandas as pd

teams_list_pfr = ['crd','atl','rav','buf','car','chi','cin','cle','dal','den','det','gnb','htx','clt','jax','kan','sdg',
            'ram','mia','min','nwe','nor','nyg','nyj','rai','phi','pit','sfo','sea','tam','oti','was']

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

#print(len(teams_list))

teams_roster = {}

for team in teams_list_full:
    url = 'https://www.lineups.com/nfl/roster/%s' % team.lower()
    teams_roster[team] = pd.read_html(url)

