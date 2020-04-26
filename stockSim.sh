#!/usr/local/bin/python3

from datetime import datetime
import os
import stock_scraping as scrp

portfolio = {}
history = []

# Get username from login/register once completed
username = "user02"

def write_portfolio(line_num):

    global username
    new_line = username

    cash = portfolio["cash"]
    stocks = portfolio["stocks"]

    new_line += ":{}:".format(cash)

    for tck,stock in stocks.items():
        avgBuy = stock["avgBuy"]
        quant = stock["quant"]

        new_line += "{}|{}|{};".format(tck, avgBuy, quant)

    new_line += "\n"

    with open('portfolio.txt', 'r') as f:
        data = f.readlines()

        data[line_num] = new_line

    with open('portfolio.txt', 'w') as f:
        f.writelines(data)

def parse_portfolio():

    global username
    global portfolio

    with open('portfolio.txt', 'r') as f:
        line_num = 0

        for line in f:
            account = line.split(":")
            if account[0] == username:
                break
            line_num += 1

    portfolio["cash"] = float(account[1])
    portfolio["stocks"] = {}

    stocks = account[2][:-1].split(";")

    if not stocks[0] == '':
        for stock in stocks:
            if not stock == '':
                data = stock.split("|")

            portfolio["stocks"][data[0]] = {"avgBuy": float(data[1]), "quant": int(data[2])}

    return line_num

def show_portfolio():

    print("\nPORTFOLIO\n")

    cash = portfolio["cash"]
    stocks = portfolio["stocks"]

    if len(stocks) == 0:
        print("You currently don't have any stocks.\n")
    else:
        print("Fecthing Values. Please Wait...\n")
        total = 0
        curr_prices = {}
        for tck in stocks:
            curr_prices[tck] = scrp.scrape_site(tck)

        print("{:>6} {:>8} {:>12} {:>14} {:>12} {:>12}\n".format("Symbol","Quantity","Buy Price","Current Price","Total Value","Change"))

        for tck, stock in stocks.items():

            quant = stock["quant"]
            avgBuy = stock["avgBuy"]
            cur_prc = curr_prices[tck]
            total_stck = avgBuy * quant
            change = 100*(cur_prc - avgBuy) / avgBuy

            if change > 0:
                chg_str = "+{}%".format(round(change,2))
            else:
                chg_str = "{}%".format(round(change,2))

            total += total_stck

            print("{:>6} {:>8} {:>12} {:>14} {:>12} {:>12}\n".format(tck, quant, round(avgBuy,2), round(cur_prc,2), round(total_stck,2), chg_str))

        print("\nInvestment Value: {}".format(round(total,2)))

    print("Cash: {}".format(round(cash,2)))

def buy_stock():

    print("BUY STOCKS\n")

    global history

    cash = portfolio["cash"]
    stocks = portfolio["stocks"]

    while True:

        print("Enter a valid ticker, or '.' to return.")
        tck = input("Ticker: ").upper()

        if tck == '.':
            return
        else:
            comp_name = scrp.get_symbol(tck)
            if comp_name == "NO COMPANY":
                print("\nCompany Not Found.\n")
            else:
                price = scrp.scrape_site(tck)

                max_quant = cash / price

                print("\nName: "+comp_name)
                print("Ticker: "+tck)
                print("Price: {}\n".format(price))
                print("Cash: {:.2f}".format(cash))
                print("Max Quantity: {:.0f}".format(max_quant))

                try:
                    ans = int(input("How many shares to BUY? "))
                except:
                    print("Invalid Quantity. Transaction Aborted.\n")

                if ans > 0 and ans <= max_quant:
                    cash-= price * ans
                    if tck in stocks:
                        avgBuy = stocks[tck]["avgBuy"]
                        quant = stocks[tck]["quant"]

                        stocks[tck]["avgBuy"] = (avgBuy * quant + price * ans) / (quant + ans)
                        stocks[tck]["quant"] = quant + ans

                    else:
                        stocks[tck] = {"avgBuy": price, "quant": ans}

                    print("\nTransaction Successful:")
                    print("Bought {} shares of {} at {:.2f} each for a total of {:.2f}".format(ans, tck, price, ans*price))
                    print("Cash: {:.2f}\n".format(cash))
                    portfolio["cash"] = cash

                    history.append([datetime.now(),"BUY",tck,price,ans,ans*price,cash])

                else:
                    print("Invalid Quantity. Transaction Aborted.\n")

def sell_stock():

    print("SELL STOCKS\n")

    global history

    cash = portfolio["cash"]
    stocks = portfolio["stocks"]

    while True:

        print("Enter a valid ticker, or '.' to return.")
        tck = input("Ticker: ").upper()

        if tck == '.':
            return
        elif tck not in stocks:
            print("\nYou don't own any {} stocks.\n".format(tck))
        else:
            comp_name = scrp.get_symbol(tck)
            if comp_name == "NO COMPANY":
                print("\nCompany Not Found.\n")
            else:
                price = scrp.scrape_site(tck)

                avgBuy = stocks[tck]["avgBuy"]
                quant = stocks[tck]["quant"]

                print("\nName: "+comp_name)
                print("Ticker: "+tck)
                print("Price: {}".format(price))
                print("Shares Owned: {}\n".format(quant))
                print("Cash: {:.2f}".format(cash))

                try:
                    ans = int(input("How many shares to SELL? "))
                except:
                    print("Invalid Quantity. Transaction Aborted.\n")

                if ans > 0 and ans <= quant:
                    cash += price * ans
                    if ans == quant:
                        del stocks[tck]
                    else:
                        stocks[tck]["quant"] = quant - ans

                    print("\nTransaction Successful:")
                    print("Sold {} shares of {} at {:.2f} each for a total of {:.2f}.".format(ans, tck, price, ans*price))
                    print("Cash: {:.2f}\n".format(cash))
                    portfolio["cash"] = cash

                    history.append([datetime.now(),"SELL",tck,price,ans,ans*price,cash])

                else:
                    print("Invalid Quantity. Transaction Aborted.\n")

def get_price():

    print("\nCHECK PRICE\n")

    while True:

        print("Enter a valid ticker, or '.' to return.")
        tck = input("Ticker: ").upper()

        if tck == '.':
            return
        else:
            comp_name = scrp.get_symbol(tck)
            if comp_name == "NO COMPANY":
                print("\nCompany Not Found.\n")
            else:
                price = scrp.scrape_site(tck)

                print("\nName: "+comp_name)
                print("Ticker: "+tck)
                print("Price: {}\n".format(price))

def write_history():
    global history
    global username

    filename = "history/{}.txt".format(username)

    if os.path.exists(filename):
        append_write = "a"
    else:
        append_write = "w"

    with open(filename, append_write) as f:
        for data in history:

            dateT = datetime.strftime(data[0],"%d-%b-%Y")
            oprt = data[1]
            tck = data[2]
            price = round(data[3],2)
            quant = data[4]
            total = round(data[5],2)
            cash = round(data[6],2)

            line = "{};{};{};{};{};{};{}\n".format(date,oprt,tck,price,quant,total,cash)

            f.write(line)

def show_history():

    global username
    global history

    filename = "history/{}.txt".format(username)

    print("{:>12} {:>10} {:>6} {:>8} {:>10} {:>15} {:>15}\n".format("Date", "Operation", "Stock", "Price", "Quantity", "Total", "Cash"))

    if os.path.exists(filename):
        with open(filename, 'r') as f:
            for line in f:
                data = line[:-1].split(";")

                date = data[0]
                oprt = data[1]
                tck = data[2]
                price = data[3]
                quant = data[4]
                total = data[5]
                cash = data[6]

                print("{:>12} {:>10} {:>6} {:>8} {:>10} {:>15} {:>15}".format(date,oprt,tck,price,quant,total,cash))

    if len(history) == 0:
        print("No Transactions Completed Yet.")
        return

    for data in history:
        dateT = datetime.strftime(data[0],"%d-%b-%Y")
        oprt = data[1]
        tck = data[2]
        price = round(data[3],2)
        quant = data[4]
        total = round(data[5],2)
        cash = round(data[6],2)

        print("{:>12} {:>10} {:>6} {:>8} {:>10} {:>15} {:>15}".format(dateT,oprt,tck,price,quant,total,cash))

def main():

    global portfolio
    line_num = parse_portfolio()
    print(portfolio)

    while True:
        print("\nMAIN MENU\n")
        print("Options:")
        print("1. Portfolio")
        print("2. Buy Stocks")
        print("3. Sell Stocks")
        print("4. Check Price")
        print("5. Transaction History")
        print("6. Quit")

        try:
            ans = int(input("\nChoose an option: "))
        except:
            print("\nPLEASE PICK A VALID OPTION.")
            continue

        print("")

        if (ans == 1):
            show_portfolio()
        elif (ans == 2):
            buy_stock()
        elif (ans == 3):
            sell_stock()
        elif (ans == 4):
            get_price()
        elif (ans == 5):
            show_history()
        elif (ans == 6):
            write_portfolio(line_num)
            write_history()

            print("Application Closed.")
            return
        else:
            print("PLEASE PICK A VALID OPTION.\n")


if __name__ == '__main__':

    main()
