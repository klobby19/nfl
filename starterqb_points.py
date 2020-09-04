import pandas as pd

df = pd.read_html('https://www.ourlads.com/nfldepthcharts/depthchartpos/QB')
print(df)