import pandas as pd

df = pd.read_excel(r"C:\Users\Student\Documents\DATA ANALYSIS\Python\Pandas\Customer Call List.xlsx")
pd.set_option('display.max.columns', 17)

# drop duplicates and columns that are not useful in this analysis
df = df.drop_duplicates()
df = df.drop(columns="Not_Useful_Column")

# clean the Lastname and remove trailing spaces and special characters
df["Last_Name"] = df["Last_Name"].str.strip("/.")

# reformat the phone Number column so that the format is uniform in all rows
df["Phone_Number"] = df["Phone_Number"].str.replace('[^a-zA-Z0-9]','',regex=True)
df["Phone_Number"] = df["Phone_Number"].apply(lambda x: str(x))
df["Phone_Number"] = df["Phone_Number"].apply(lambda x: x[0:3] + '-' + x[3:6] + '-' + x[6:10])
df["Phone_Number"] = df["Phone_Number"].replace('nan--','')
df["Phone_Number"] = df["Phone_Number"].replace('Na--','')

# split the address column to show the street, state and zipcode seperately
df[["Street_Address", "State", "Zipcode"]] = df["Address"].str.split(',', expand=True)

# drop the full address column
df = df.drop(columns="Address")

# Reformat the paying customer and Do_Not_Contact columns to make them uniform
df["Paying Customer"]= df["Paying Customer"].str.replace('Yes', 'Y')
df["Paying Customer"]= df["Paying Customer"].str.replace('No', 'N')
df["Do_Not_Contact"]= df["Do_Not_Contact"].str.replace('Yes', 'Y')
df["Do_Not_Contact"]= df["Do_Not_Contact"].str.replace('No', 'N')

# remove all the n/a and NaN from the entire dataframe
df = df.replace('N/a','')
df = df.fillna('')

# remove customers who do not want to be contacted
for x in df.index:
    if df.loc[x,"Do_Not_Contact"] == 'Y':
        df.drop(x, inplace= True)

#remove customers who do not have phone numbers

for x in df.index:
    if df.loc[x,"Phone_Number"] == '':
        df.drop(x, inplace= True)


# reset the index of the dataframe
df = df.reset_index(drop=True)

print(df)


