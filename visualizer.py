import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('average_age.txt')
df = pd.DataFrame(data)

plt.scatter(df['team'],df['age'])
plt.show()