#!/usr/bin/env python3

import os

name = input("enter your name: ")
print("Hi, " + name)
answer= input("would you like to send emails? yes or no: ")
if answer == "yes":
	print("Great, we'll send emails!")
	os.system('./send-emails.sh')
else:
	print("okay, we won't send any!")
