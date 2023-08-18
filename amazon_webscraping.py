#import libraries
from bs4 import BeautifulSoup
import pandas as pd
import requests
import time
import datetime
import csv
import smtplib

# connect to the website
URL = "https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8-3&customId=B0752XJYNL&th=1"
headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.203"
}

page = requests.get(URL, headers= headers)
soup1 = BeautifulSoup(page.content,'html.parser')
soup2 = BeautifulSoup(soup1.prettify(),'html.parser')

# get the price and the product name
title = soup2.find(id='productTitle').get_text()
price = soup2.find(id='priceblock_ourprice').get_text()
price = price.strip()[1:]
title = title.strip()
today = datetime.date.today()

#create headers and data
header = ['Title', 'Price', 'Date']
data = [title,price, today]


#create a csv file, inserting the headers and data then inserting the csv
with open("AmazonWebScraper.csv", 'w', newline='',encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# append data to the csv file we created
with open("AmazonWebScraper.csv", 'a+', newline='',encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)

#Create a function so we could call it every 24 hours to update our data

def check_price():
    # connect to the website
    URL = "https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8-3&customId=B0752XJYNL&th=1"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.203"
        }

    page = requests.get(URL, headers=headers)
    soup1 = BeautifulSoup(page.content, 'html.parser')
    soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

    # get the price and the product name
    title = soup2.find(id='productTitle').get_text()
    price = soup2.find(id='priceblock_ourprice').get_text()
    price = price.strip()[1:]
    title = title.strip()
    today = datetime.date.today()

    # create headers and data
    header = ['Title', 'Price', 'Date']
    data = [title, price, today]

    # create a csv file, inserting the headers and data then inserting the csv
    with open("AmazonWebScraper.csv", 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)
# We check the price every day 86400 seconds = 24 hours
while (True):
    check_price()
    time.sleep(864000)








