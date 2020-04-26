import os

overall = {}

# Reads the stockhistory file, create the dictionary overall from it
# The dictionary overall is saved such that tickers are keys, and dictionaries are the values
# These sub-dictionaries have keys 1-7 corresponding to the 1st most recent price, 2nd most, etc.
def parse_history():
    with open('portfoliohistory.txt', 'r') as f:
        line = f.readline()
        while(line):
            # print(line.rstrip('\n'))
            curr = line.split(':')
            user = curr[0] #user
            tempDict = {}
            first = curr[1] #First portfolio
            tempDict[1] = first
            second = curr[2] #Second portfolio
            tempDict[2] = second
            third = curr[3] #Third portfolio
            tempDict[3] = third
            fourth = curr[4] #Fourth portfolio
            tempDict[4] = fourth
            fifth = curr[5] #Fifth portfolio
            tempDict[5] = fifth
            sixth = curr[6] #Sixth portfolio
            tempDict[6] = sixth
            seventh = curr[7].rstrip('\n') #Seventh portfolio
            tempDict[7] = seventh
            overall[user] = tempDict
            line = f.readline()
        # print(overall)
    return

# Should be called every time a user buys a stock, will add stock to the file/dictionary if not already there
# Note that when a history does not exist for a stock, the value will be saved as -1
def initial_save(username):
    if username in overall:
        print(overall[username])
    else:
        temp = {1: '', 2: '', 3: '', 4: '', 5: '', 6: '', 7:''}
        tempString = username + ":::::::" + "\n"
        with open("portfoliohistory.txt", "a") as file:
            file.write(tempString)
        overall[username] = temp
        print(overall[username])
    return

# Updates the dictonary and file with the current price of a stock as the most recent
# Will likely only be called by the crontab
def update_all():
    open('portfoliohistory.txt', 'w').close()
    for user in overall:
        overall[user][7] = overall[user][6]
        overall[user][6] = overall[user][5]
        overall[user][5] = overall[user][4]
        overall[user][4] = overall[user][3]
        overall[user][3] = overall[user][2]
        overall[user][2] = overall[user][1]

        stocks = ""
        with open('portfolio.txt', 'r') as f:
            line_num = 0

            for line in f:
                account = line.split(":")
                if account[0] == user:
                    break
                line_num += 1
            stocks = account[2][:-1]

        overall[user][1] = stocks
        tempString = user
        for i in range(1,8):
            tempString = tempString + ":" + str(overall[user][i])
        tempString = tempString + "\n"
        with open("portfoliohistory.txt", "a") as file:
            file.write(tempString)


# Will likely need to be called to create pyplots
# Returns the current dictionary
def obtain_current():
    parse_history()
    return overall

parse_history()

if __name__ == '__main__':
    # initial_save('aismaiel')
    # update_all()
    print(obtain_current())
