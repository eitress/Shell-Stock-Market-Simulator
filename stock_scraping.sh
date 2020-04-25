#!/usr/bin/env python3

import bs4
import requests
import argparse
from bs4 import BeautifulSoup
from IPython.core.display import HTML

def parse_args():
    parser = argparse.ArgumentParser(description='Parsing command line for this HW')
    parser.add_argument('stocks', nargs='+')
    args = parser.parse_args()
    if (len(args.stocks) > 1):
        raise NameError("Can only put in one stock")

    return args.stocks[0]

def get_symbol(stock):
    url = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="+stock+"&region=1&lang=en"
    result = requests.get(url).json()

    for curr in result['ResultSet']['Result']:
        if curr['symbol'] == stock:
            return curr['name']

    return "NO COMPANY"

def scrape_site(stock):
    url = "https://finance.yahoo.com/quote/"+stock
    print(url)
    source_code = requests.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, "html.parser")
    price = soup.find_all('div', {'class':'My(6px) Pos(r) smartphone_Mt(6px)'})[0].find('span').text
    fprice = float(price)
    return fprice

if __name__ == '__main__':

    symbol = parse_args()
    company = get_symbol(symbol)
    if company != "NO COMPANY":
        price = scrape_site(symbol)
        print(price)
