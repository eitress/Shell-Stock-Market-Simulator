#!/usr/bin/env python3


def choose_username():
	#the user inputs a username that is not taken
	valid_user_name = False
	while valid_user_name == False:
		username = input("Enter a username: ")
		username_is_taken = False
		users_file = open("users.txt", "r")
		for line in users_file:
			username_and_password = line.split()
			if len(username_and_password) != 0:
				current_username = username_and_password[0]
				if username == current_username:
					username_is_taken = True
					print("the username " + username + " is already taken! Pick another.")
		
		users_file.close()
		if username_is_taken == False:
			valid_user_name = True
	return username

def choose_password():
	#user can input any password
	password = input("Enter a password: ")
	return password

def input_email():
	#user inputs email
	email = input("Enter email so friends can share updates: ")
	return email

def main():
	username = choose_username()
	password = choose_password()
	email = input_email()
	print("creating your account!")
	new_line = "" + username + " " + password
	users_file = open("./users.txt", "a")
	users_file.write(new_line + "\n")
	users_file.close()
	contacts = open ("./contacts.txt", "a")
	contacts.write(email + "\n")
	print("your account has been created!") 

main()
