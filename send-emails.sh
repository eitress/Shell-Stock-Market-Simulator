#!/usr/bin/env python3
from string import Template
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from getpass import getpass


def read_template(filename):
	with open(filename, 'r', encoding='utf-8') as template_file:
		template_file_content = template_file.read()
	return template_file_content


def get_contacts(filename):
	emails = []
	with open(filename, mode='r', encoding='utf-8') as contacts_file:
		for a_email in contacts_file:
			emails.append(a_email.split()[0])
	return emails

def main():	
	#set up SMTP server

	# default email provider
	host = "smtp.gmail.com"
	port = 587
	selection = "Gmail"
	print("about to enter the while loop")
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
	message = read_template('./email-content.txt')
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
