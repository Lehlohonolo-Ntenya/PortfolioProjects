import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
df = pd.read_csv(r"C:\Users\Student\Documents\DATA ANALYSIS\Python\archive\movies.csv")

# Take a look at the data
df.head()
pd.set_option('display.max.columns',15)
# =pd.set_option('display.max.rows', None)

# check for missing data
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    #print('{} * {}%'.format(col,pct_missing))

#check data types for columns

df.dtypes


# reformat data types of columns to preferred data types
df = df.fillna(0)
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')

#split the release column into the released date and country of release

df[['release','country_release']] = df['released'].str.split('\(', n=1, expand = True)
df['country_release'] = df['country_release'].str.replace(')', '')

# create correct year column
df['Year_correct'] = df['release'].astype(str).str[-5:]

#drop duplicates

df = df.drop_duplicates().sort_values(by='gross', ascending=False)

# scatter plot with budget and gross revenue
plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget VS Gross Revenue')
plt.xlabel('Budget')
plt.ylabel('Gross Revenue')

#plot budget vs gross using seaborn
sns.regplot(x= 'budget', y= 'gross', data= df, scatter_kws={"color": "red"}, line_kws={"color": "blue"})

plt.show()

# We look at the correlation
correlation_matrix =df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot= True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie features')
plt.ylabel('Movie features')

plt.show()

#Look at company
df_numerical = df
for col_name in df_numerical.columns:
    if( df_numerical[col_name].dtypes == 'object'):
        df_numerical[col_name]=df_numerical[col_name].astype('category')
        df_numerical[col_name]=df_numerical[col_name].cat.codes

correlation_matrix =df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot= True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie features')
plt.ylabel('Movie features')

plt.show()

# Exploring correlation
correlation_mat = df_numerical.corr()
corr_pairs = correlation_mat.unstack()
sorted_pairs = corr_pairs.sort_values()
high_correlation = sorted_pairs[(sorted_pairs)>0.5]
print(high_correlation)

# Conclusion is that votes and budget have the highest correlation with gross revenue. Company has low correlation with gross revenue


