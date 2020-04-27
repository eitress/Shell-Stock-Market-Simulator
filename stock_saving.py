import stock_scraping as scrp
import os

overall = {}

# Reads the stockhistory file, create the dictionary overall from it
# The dictionary overall is saved such that tickers are keys, and dictionaries are the values
# These sub-dictionaries have keys 1-7 corresponding to the 1st most recent price, 2nd most, etc.
def parse_history():
    global overall
    with open('stockhistory.txt', 'r') as f:
        line = f.readline()
        while(line):
            # print(line.rstrip('\n'))
            curr = line.split(':')
            stock = curr[0] #Ticker
            tempDict = {}
            first = float(curr[1]) #First price
            tempDict[1] = first
            second = float(curr[2]) #Second price
            tempDict[2] = second
            third = float(curr[3]) #Third price
            tempDict[3] = third
            fourth = float(curr[4]) #Fourth price
            tempDict[4] = fourth
            fifth = float(curr[5]) #Fifth price
            tempDict[5] = fifth
            sixth = float(curr[6]) #Sixth price
            tempDict[6] = sixth
            seventh = float(curr[7].rstrip('\n')) #Seventh price
            tempDict[7] = seventh
            overall[stock] = tempDict
            line = f.readline()
        # print(overall)
    return

# Should be called every time a user buys a stock, will add stock to the file/dictionary if not already there
# Note that when a history does not exist for a stock, the value will be saved as -1
def initial_save(ticker):
    global overall
    if ticker in overall:
        return
    else:
        temp = {1: -1, 2: -1, 3: -1, 4: -1, 5:-1, 6:-1, 7:-1}
        tempString = ticker + ":-1:-1:-1:-1:-1:-1:-1" + "\n"
        with open("stockhistory.txt", "a") as file:
            file.write(tempString)
        overall[ticker] = temp
        # print(overall[ticker])
    return

def general_save(ticker, value):
    with open("overallstock.txt", "r") as file:
        data = file.readlines()

    not_enclosed = True

    for i in range(len(data)):
        temp = data[i].split(":")
        if temp[0] == ticker:
            not_enclosed = False
            temp_value = int(temp[1].rstrip('\n'))
            mod_value = temp_value + value
            data[i] = ticker + ":" + str(mod_value) + "\n"
            break

    with open("overallstock.txt", "w") as file:
        file.writelines(data)

    if not_enclosed:
        tempString = ticker + ":" + str(value)
        with open("overallstock.txt", "a") as file:
            file.write(tempString)

# Updates the dictonary and file with the current price of a stock as the most recent
# Will likely only be called by the crontab
def update_all():
    global overall
    open('stockhistory.txt', 'w').close()
    for stock in overall:
        overall[stock][7] = overall[stock][6]
        overall[stock][6] = overall[stock][5]
        overall[stock][5] = overall[stock][4]
        overall[stock][4] = overall[stock][3]
        overall[stock][3] = overall[stock][2]
        overall[stock][2] = overall[stock][1]
        overall[stock][1] = scrp.scrape_site(stock)
        tempString = stock
        for i in range(1,8):
            tempString = tempString + ":" + str(overall[stock][i])
        tempString = tempString + "\n"
        with open("stockhistory.txt", "a") as file:
            file.write(tempString)

        # Ignore this
        # AAPL:1:2:3:4:5:6:7
        # GM:23:23:23:23:23:23:23
        # MSFT:-1:-1:-1:-1:-1:-1:-1

# Will likely need to be called to create pyplots
# Returns the current dictionary
def obtain_current():
    global overall
    parse_history()
    return overall

if __name__ == '__main__':
    update_all()
