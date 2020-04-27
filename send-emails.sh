#!/usr/bin/env python3
from string import Template
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from getpass import getpass
import argparse

def read_template(filename):
	with open(filename, 'r', encoding='utf-8') as template_file:
		template_file_content = template_file.read()
	return Template(template_file_content)

def get_contacts(filename):
	emails = []
	with open(filename, mode='r', encoding='utf-8') as contacts_file:
		for a_email in contacts_file:
			emails.append(a_email.split()[0])
	return emails

def main():
	#get the username
	parser = argparse.ArgumentParser()
	parser.add_argument('username')
	args = parser.parse_args()
	current_user = args.username
	port_value = 0
	#get the total value of the portfolio
	portfolio = open('./portfolio.txt', 'r')
	portfolio_lines = portfolio.readlines()
	for line in portfolio_lines:
		split_line = line.split(':')
		if current_user == split_line[0]:
			port_value = split_line[1]
			print("the port value is " + port_value)
	portfolio.close()	
	#set up SMTP server
	# default email provider
	host = "smtp.gmail.com"
	port = 587
	selection = "Gmail"
	provider_complete = False

	# select email provider 
	while provider_complete == False:
		print("what email service provider will you be using?")
		print("1: Gmail")
		print("2: Outlook.com")
		print("3: Yahoo Mail")
		print("4: AOL Mail")
		provider=input("Enter the number corresponding to your email service provider: ")
		if provider == "1":
			print("make sure you allow less secure apps in your google settings")
			selection="Gmail"
			host="smtp.gmail.com"
			port="587"
		elif provider == "2":
			selection="Outlook.com"
			host="smtp-mail.outlook.com"
			port=587
		elif provider == "3":
			selection="Yahoo Mail"
			host="smtp.mail.yahoo.com"
			port=587
		elif provider == "4":
			selection="AOL Mail"
			host="smtp.aol.com"
			port=587
		print("you chose " + selection + ". Is that correct?")
		provider_answer = input("yes or no? ")
		if provider_answer == "yes":
			provider_complete = True

	
	s = smtplib.SMTP(host=host, port=port)
	s.starttls()
	# supply username and password
	username = input("Enter your email adddress: ")
	password = getpass("Enter your email password: ")		
	
	# login
	s.login(username, password)
	emails = get_contacts('./contacts.txt') 
	print("successfully retrieved contacts")
	message_template = read_template('./email-content.txt')
	message = message_template.substitute(VALUE="$" + port_value)
	print("successfully retrieved message")
	
	# email each contact
	for email in emails:
		msg = MIMEMultipart()
		msg['From']=username
		msg['To']=email
		msg['Subject']="Test email"
		msg.attach(MIMEText(message, 'plain'))
		s.send_message(msg)
		print("you are sending a message to " + email)
		del msg

	print("you're emails have been sent!")

main()
