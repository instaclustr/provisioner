import json
import sys

def clusterProvisioned(responseFile):
	try:
		with open(responseFile) as file:
			data = json.load(file)
			print(data["id"])
	except ValueError:
		print("Issue reading API response file " + responseFile)
		sys.exit(1)
	except KeyError:
		print("no 'id' in response file" + responseFile)
		sys.exit(1)

def clusterStatus(responseFile):
	try:
		with open(responseFile) as file:
			data = json.load(file)
			print(data["clusterStatus"])
	except ValueError:
		print("Issue reading API response file " + responseFile)
		sys.exit(1)
	except KeyError:
		print("no 'clusterStatus' in response file" + responseFile)
		sys.exit(1)

#def connectionInfo(responseFile):
#	try:
#		with open(responseFile) as file:
#			data = json.load(file)
#			creds = ""
#			creds = creds + "username=\"" + str(data["username"]) + "\""
#			creds = creds + " \\ \n"
#			creds = creds + "password=\"" + str(data["instaclustrUserPassword"]) + "\";"
#			print(creds)
#	except ValueError:
#		print("Issue reading API response file " + responseFile)
#		sys.exit(1)
#	except KeyError:
#		print("no 'username' or 'instaclustrUserPassword' in response file" + responseFile)
#		sys.exit(1)