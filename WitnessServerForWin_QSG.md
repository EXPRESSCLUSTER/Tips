# Witness Server on Windows QSG

## Overview
This QSG shows how to setup Witness Server on Windows machine.

## Reference
[EXPRESSCLUSTER X 4.1 for Windows Reference Guide](https://www.nec.com/en/global/prod/expresscluster/en/support/Windows/W41_RG_EN_01.pdf)  
"Chapter 6 Information on other settings" - "Witness server service"

## System Configuration
```bat
[Witness HeartBeat LAN]
 |
 |  [Kernel HeartBeat LAN]   
 |   |
 |   |    +---------------------------+
 |   |    |       Witness Server      |
 +--------+                           |
 |   |    | OS: Windows Server 2016   |
 |   |    | SW: clpwitnessd of        |       
 |   |    |      EXPRESSCLUSTER X 4.1 |
 |   |    |     Node.js 10.16.0       |
 |   |    +---------------------------+
 |   |
 |   |    +---------------------------+
 |   |    |      Cluster Server 1     |
 +--------+                           |
 |   |    | OS: -                     |
 |   |    | SW: EXPRESSCLUSTER X 4.1  |
 |   |    |                           |
 |   |    +---------------------------+
 |   |
 |   |    +---------------------------+
 |   |    |      Cluster Server 2     |
 +--------+                           |
 |   |    | OS: -                     |
 |   |    | SW: EXPRESSCLUSTER X 4.1  |
 |   |    |                           |
 |   |    +---------------------------+
 |   |
 :   :                 :
 :   :                 :
 |   |
 |   |    +---------------------------+
 |   |    |      Cluster Server N     |
 +--------+                           |
 |   |    | OS: -                     |
 |   |    | SW: EXPRESSCLUSTER X 4.1  |
 |   |    |                           |
 |   |    +---------------------------+
 |   |
 :   :
```

## Preparation
1. Get node.js installer and store it on Witness Server.  
	https://nodejs.org/en/
1. Check ports for Witness Server are available and opened.  
	Default: 80 for http and 443 for https
1. Store Witness Server module on Witness Server.
	e.g.) C:\Users\Administrator\clpwitness\clpwitnessd-4.1.0.tgz

## Witness Server Setup
On Witness Server
1. Login as Administrator.  
	\* Witness Server should be installed and started by Administrator.
1. Execute Node.js installer and install it.
1. Check Node.js installed properly:
	```bat
	>npm --version
	6.9.0
	```
1. Install Witness Server:
	```bat  
	>cd C:\Users\Administrator\clpwitness

	>npm install --global clpwitnessd-4.1.0.tgz
	C:\Users\Administrator\AppData\Roaming\npm\clpwitnessd -> C:\Users\Administrator\AppData\Roaming\npm\node_modules\clpwitnessd\clpwitnessd.js
	+ clpwitnessd@4.1.0
	added 1 package in 0.668s
	```
1. Check Witness Server is installed properly by displaying npm version:  
	```bat
	>npm list --global clpwitnessd
	C:\Users\Administrator\AppData\Roaming\npm
	`-- clpwitnessd@4.1.0
	```
1. Start Witness Serer:
	```bat
	>clpwitnessd
	```
	\* If clpwinessd fails to start, check error log in "%current folder%\witness.log" file.  
  		e.g.) If current folder is "C:\Users\Administrator\clpwitness", "C:\Users\Administrator\clpwitness\witness.log" file is created.  
	\* If you execute Ctrl+C or terminate the command prompt, clpwinessd is stopped because clpwitnessd runs in fore-ground.

## EXPRESSCLUSTER Witness Heart Beat Setup

1. Check Witness Server is accessible from each Cluster Servers:
	```bat
	>curl -v http://<Witness Server IP address>:<Witness Server port number>
	VERBOSE: GET http://<Witness Server IP address>/ with 0-byte payload
	VERBOSE: received 703-byte response of content type text/html

	StatusCode        : 200
	StatusDescription : OK
	```
1. Configure Witness HeartBeat with following Reference Guide:  
	[EXPRESSCLUSTER X 4.1 for Windows Reference Guide](https://www.nec.com/en/global/prod/expresscluster/en/support/Windows/W41_RG_EN_01.pdf)  
		"Chapter 1 Parameter details" - "Interconnect tab"

## Option
If you want to register clpwitnessd as a Windows Service, follow the below.
By registering as a Windows Service, it can be started automatically after reboot Witness Server.

1. If clpwitnesd is started, stop it with Ctrl+C on the command prompt.
1. Create .json file.
	e.g.) C:\Users\Administrator\clpwitness\service\package.json
1. Edit the file as the following:  
	```bat
	{
	 "name": "clpwitnessd-service",
	 "version": "1.0.0",
	 "license": "UNLICENSED",
	 "private": true,
	 "scripts": {
	  "start": "C:\\Users\\Administrator\\AppData\\Roaming\\npm\\clpwitnessd.cmd"
	 }
	}
	```
1. Create a Windows Service:
	```bat
	>cd C:\Users\Administrator\clpwitness\service\
	> winser -i -a
	Use start command "C:\Users\Administrator\AppData\Roaming\npm\clpwitnessd.cmd".
	The program "clpwitnessd-service" was installed as a service.
	The service for "clpwitnessd-service" was started.
	```
1. Confirm that "clpwitnessd-service" exists on Windows Service Manager.
