import bs4
import requests
import argparse
from bs4 import BeautifulSoup
#from googlesearch import search
from urllib.request import urlopen

# Potential argument parsing function, probably won't be here in main code
def parse_args():
    parser = argparse.ArgumentParser(description='Parsing command line for this HW')
    parser.add_argument('-stocks', nargs='+')
    parser.add_argument('-search', nargs=0)
    args = parser.parse_args()
    if (len(args.stocks) > 1):
        raise NameError("Can only put in one stock")

    return args

# Given ticker symbol, determines the name of the respective company, "NO COMPANY" if DNE
def get_symbol(stock):
    url = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="+stock+"&region=1&lang=en"
    result = requests.get(url).json()

    for curr in result['ResultSet']['Result']:
        if curr['symbol'] == stock:
            return curr['name']

    return "NO COMPANY"

# Given valid ticker symbol, gives float value of current stock price
def scrape_site(stock):
    url = "https://finance.yahoo.com/quote/"+stock
    #print(url)
    source_code = requests.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, "html.parser")
    price = soup.find_all('div', {'class':'My(6px) Pos(r) smartphone_Mt(6px)'})[0].find('span').text
    fprice = float(price)
    return fprice

# Given any query and integer amount i, gives the first i news articles on query
# For our use, will likely look up corporation names or "Finance" and return articles to user
def get_articles(query, i):
    '''
    FIRST ATTEMPT: Prints google search overall
    print(query)
    for j in search(query, tld="com", num=10, stop=10, pause=2):
        print(j)
    '''

    # SECOND ATTEMPT: Prints Google news articles based on query
    news_url="https://news.google.com/rss/search?q=" + query + "&hl=en-US&gl=US&ceid=US:en"
    Client=urlopen(news_url)
    xml_page=Client.read()
    Client.close()

    soup_page = BeautifulSoup(xml_page,"xml")
    news_list=soup_page.findAll("item")
    print()
    # Print news title, url and publish date
    j = 0
    for news in news_list:
        print(news.title.text)
        print(news.link.text)
        print(news.pubDate.text)
        print("-"*60)
        j = j + 1
        # Sets the number of articles you want to print
        if i == j:
            return


if __name__ == '__main__':
    '''
    symbol = parse_args()
    company = get_symbol(symbol)
    if company != "NO COMPANY":
        price = scrape_site(symbol)
        print(price)
    get_articles("Finance")
    '''
    get_articles("Finance", 2)
