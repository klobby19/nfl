import pandas as pd
import os, ssl

if (not os.environ.get('PYTHONHTTPSVERIFY', '') and getattr(ssl, '_create_unverified_context', None)): 
    ssl._create_default_https_context = ssl._create_unverified_context

data = pd.read_html("https://www.wunderdog.com/public-consensus/nfl.html?date=09%2F13%2F2020")
print(data[1].columns)

