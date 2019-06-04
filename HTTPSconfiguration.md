

## Overview
Here is the sample procedure to enable HTTPS connection for EXPRESSCLUSTER X WebManager or Cluster WebUI in test environment.

## Note
The procedure depends on your environment (such as OS version) and mey different.

## For Windows
1. Download OpenSSL, Win64 OpenSSL v1.0.  
	http://slproweb.com/products/Win32OpenSSL.html  
	Win64 OpenSSL v1.0.2n Light  
	http://slproweb.com/download/Win64OpenSSL_Light-1_0_2n.exe
1. Install OpenSSL
	- Install folder: C:\OpenSSL-Win64(default)
	- OpenSSL DLL installation: The OpenSSL binaries (/bin) directory
1. Create .crt and .key files
	- Execute the following commands:  
	```bat
	  >mkdir C:\tmp\ssl
	  >cd C:\tmp\ssl
	  >path=%path%;C:\OpenSSL-Win64\bin
	  >openssl genrsa -out server.key
	  >openssl req -new -key server.key -subj "/C=JP/ST=Hiroshima/L=Hiroshima/O=ore/OU=ore/CN=ore" -config c:\OpenSSL-Win64\bin\openssl.cfg > server.csr
	  >openssl x509 -req -in server.csr -signkey server.key -out server.crt -days 7300 -extensions server
	```
1. Configure HTTPS connection on Cluster configuration>
	- Change Cluster Properties
		- WebManager tab
			- Encryption Settings button 
				- HTTPS: Check
				- Certification File: C:\tmp\ssl\server.crt
				- Private Key File: C:\tmp\ssl\server.key
				- SSL Library: C:\OpenSSL-Win64\bin\ssleay32.dll
				- Crypto Library: C:\OpenSSL-Win64\bin\libeay32.dll
	- Apply the configuration and restart Browser which connects to Webanager or WebUI.


## For Linux
### Assumption
OpenSSL which is included in OS iso media is installed.

1. Create .crt and .key
	- Execute the following commands:  
	```bat
	  #mkdir /tmp/ssl
	  #cd /tmp/ssl
	  #openssl genrsa 2048 > server.key
	  #openssl req -new -key server.key >server.csr
	  #openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt
	```
1. Configure HTTPS connection on Cluster configuration
	- Change Cluster Properties
		-WebManager tab
			- Encryption Settings button 
				- HTTPS: Check
				- Certification File: /tmp/ssl/server.crt
				- Private Key File: /tmp/ssl/server.key
				- SSL Library: /usr/lib64/libssl.so.10
				- Crypto Library: /usr/lib64/libcrypto.so.10
	- Apply the configuration and restart Browser which connects to Webanager or WebUI.
