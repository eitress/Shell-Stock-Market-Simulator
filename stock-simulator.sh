#!/usr/bin/env python3

import os

print("WELCOME TO THE BEST TRADING SIMULTOR")
print("")

#choose login action
chose_correct_action = False
while chose_correct_action == False:

	print("1: log in")
	print("2: create new account")
	login_action = input("choose an action: ")

	if login_action == "1":
		print("you want to log in!")
		chose_correct_action = True
	elif login_action == "2":
		print("you want to create an account!")
		os.system('./create-account.sh')
		chose_correct_action = True
	else:
		print("you fucked up!")

name = input("enter your name: ")
print("Hi, " + name)
answer= input("would you like to send emails? yes or no: ")
if answer == "yes":
	print("Great, we'll send emails!")
	os.system('./send-emails.sh')
else:
	print("okay, we won't send any!")
