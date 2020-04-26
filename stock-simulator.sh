#!/usr/bin/env python3

import os
from getpass import getpass

#returns the current users username, will be userd to all user info
def login():
	#TODO: get an input username and password
	#find the line in users.txt that matches input otherwise
	#try again
	has_logged_in = False
	username = ""
	expected_password = ""
	#enter a username
	while has_logged_in == False:
		username = input("Enter username: ")
		username_exists = False
		users_file = open("users.txt", "r")
		users_file_lines = users_file.readlines()
		#check if user exists and then check if input password matches 
		for line in users_file_lines:
			username_password = line.split()
			potential_username = username_password[0]
			#if the usernames match then grab the expected password
			if potential_username == username:
				expected_password = username_password[1]
				password = getpass("Enter password: ")
				if password == expected_password:
					return username
		print("This username and password combination was not found. Try again please.")

print("WELCOME TO THE BEST TRADING SIMULTOR")
print("")

USER=""
#choose login action
chose_possible_action = False
while chose_possible_action == False:
	print("")
	print("1: log in")
	print("2: create new account")
	login_action = input("choose an action: ")

	if login_action == "1":
		print("you want to log in!")
		USER = login()
		chose_possible_action = True
	elif login_action == "2":
		print("you want to create an account!")
		os.system('./create-account.sh')
		print("Now log into your new account!")
		USER = login()
		chose_possible_action = True
	else:
		print("Choose one of the two actions presented!")

print("")
print("Hello, " + USER + "! It's nice to see you again.")
print("")

answer= input("would you like to send emails? yes or no: ")
if answer == "yes":
	print("Great, we'll send emails!")
	os.system('./send-emails.sh')
else:
	print("okay, we won't send any!")
