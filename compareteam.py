import pandas as pd

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
print(df)