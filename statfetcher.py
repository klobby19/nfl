import pandas as pd

teams_list = ['crd','atl','rav','buf','car','chi','cin','cle','dal','den','det','gnb','htx','clt','jax','kan','sdg',
            'ram','mia','min','nwe','nor','nyg','nyj','rai','phi','pit','sfo','sea','tam','oti','was']

#print(len(teams_list))

df = pd.read_csv('season_passing.csv')
print(df)