import bs4
import requests
from bs4 import BeautifulSoup
from urllib.request import urlopen

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
    print(url)
    source_code = requests.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, "html.parser")
    price = soup.find_all('div', {'class':'My(6px) Pos(r) smartphone_Mt(6px)'})[0].find('span').text
    fprice = float(price)
    return fprice

# Given any query and integer amount i, gives the first i news articles on query
# For our use, will look up corporation names or "Finance" by default and return articles to user
def get_articles(query="Finance", i=5):

    # Prints Google news articles based on query
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
    print(scrape_site('AAPL'))
    get_articles()
    '''
