import pandas as pd

data = pd.read_html('https://fantasydata.com/nfl/point-spreads-and-odds?teamkey=ARI&season=2020&seasontype=1&scope=1&subscope=1&week=1&oddsstate=NJ')
print(data)