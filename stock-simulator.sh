#!/usr/bin/env python3

import os

#returns the current users username, will be userd to all user info
def login():
	#TODO: get an input username and password
	#find the line in users.txt that matches input otherwise
	#ask again
	print("This will be a login prompt!")
	return "default_user"

print("WELCOME TO THE BEST TRADING SIMULTOR")
print("")

USER=""

#choose login action
chose_correct_action = False
while chose_correct_action == False:

	print("1: log in")
	print("2: create new account")
	login_action = input("choose an action: ")

	if login_action == "1":
		print("you want to log in!")
		USER = login()
		chose_correct_action = True
	elif login_action == "2":
		print("you want to create an account!")
		os.system('./create-account.sh')
		USER = login()
		
		chose_correct_action = True
		
	else:
		print("you fucked up!")

answer= input("would you like to send emails? yes or no: ")
if answer == "yes":
	print("Great, we'll send emails!")
	os.system('./send-emails.sh')
else:
	print("okay, we won't send any!")
