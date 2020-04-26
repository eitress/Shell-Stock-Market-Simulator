import os

overall = {}

# Reads the stockhistory file, create the dictionary overall from it
# The dictionary overall is saved such that users are keys, and dictionaries are the values
# These sub-dictionaries have keys 1-7 corresponding to the 1st most recent portfolio, 2nd most, etc.
def parse_history():
    global overall
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

# Should be called every time a user is created, will add user to the file/dictionary if not already there
# Note that when a portfolio does not exist for a user, the value will be saved as ''
def initial_save(username):
    global overall
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

# Should be called when a user account is reset
def reset_user(username):
    global overall
    if username in overall:
        temp = {1: '', 2: '', 3: '', 4: '', 5: '', 6: '', 7:''}
        tempString = username + ":::::::" + "\n"
        # overall[username] = temp
        with open("portfoliohistory.txt", "r") as file:
            data = file.readlines()


        for i in range(len(data)):
            temp = data[i].split(":")
            if temp[0] == username:
                data[i] = tempString
                break

        with open("portfoliohistory.txt", "w") as file:
            file.writelines(data)

    return

# Updates the dictonary and file with the current portfolio as the most recent
# Will likely only be called by the crontab
def update_all():
    global overall
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
    global overall
    parse_history()
    return overall

#parse_history()

if __name__ == '__main__':
    # initial_save('aismaiel')
    update_all()
    # reset_user("aismaiel")
