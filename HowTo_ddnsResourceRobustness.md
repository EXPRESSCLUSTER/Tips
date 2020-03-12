# How to improve robustness of ddns resource
## Symptoms
- You use ddns resource.
- Cluster nodes does not have a permission to delete A Record for a target zone on DNS Server.
- Failover fails for ddns resource activation failure.
- On ddns resource Properties, "Delete the Registered IP Address" is not checked.

## Cause
When ddns resource is activated Node-A, Node-A registers A Recod with ddns virtual hostname and Node-A IP address to DNS Server target zone.  
At that time, Node-A who registered the A Record can have a permission for the A Record.  
When ddns resource is failed over and activated on Node-B, Node-B tries to remove the existing A Record then register a new A Record with ddns virtual hostname and Node-A IP address.  
However, Node-A has a permission to remove the existing A Record but Node-B does not have and removing fails.  
(If Node-B has a permisson for the target zone, it can remove.)

## Solution
By checking "Delete the Registered IP Address" on ddns resource Properties, when ddns resource is de-activated on Node-A for failover, Node-A who has a permission for the A Record delete the existing A Record.
Therefore, Node-B do not have to remove the A Record and ddns resource can be activated on Node-B successfully.

However, if failover occurs for Node-A down, ddns resource will be activated on Node-B without de-activation on Node-A.
This means that Node-B should remove the existing A Record and it will fail.
Therefore, adding to ddns resource "Delete the Registered IP Address" setting, please add an application resource which removes the existing A Record with a specified account.

### Preparation
- Enable Powershell DNSServer command  
	On both servers
	1. Start Windows Server Manager
	2. Add following Server feature:
		- Remoe Administration Tools
			- Role Administration Tools
				- DNS Server Tools

- Prepare Account  
	An account which fufilling the following conditions (hereinafter, this is called "DNS Account") is required.
	- The account has a permission to the target zone level to delete record
	- The account is enabled on all cluster nodes  
		e.g.) Domain account which has a permmision for zone

- Store scripts
	On both servers
	1. Copy the following 3 scripts to "C:\Program Files\EXPRESSCLUSTER\bin".
		- [RemoveRecord1.bat](https://github.com/EXPRESSCLUSTER/Tips/blob/master/Scripts_ddnsResourceRobustness/RemoveRecord1.bat)
		- [RemoveRecord2.bat](https://github.com/EXPRESSCLUSTER/Tips/blob/master/Scripts_ddnsResourceRobustness/RemoveRecord2.bat)
		- [RemoveRecord.ps1](https://github.com/EXPRESSCLUSTER/Tips/blob/master/Scripts_ddnsResourceRobustness/RemoveRecord.ps1)
	1. Set RemoveRecord.ps1 parameters:
		- $dnsServerIp
		- $ddnsVirtualHostname
		- $dnsZoneName  
		  e.g.)
	```bat  
	# Set the following parameters #  
	$dnsServerIp = "192.168.10.10"  
	$ddnsVirtualHostname = "ddns-test"  
	$dnsZoneName = "test.local"  
	################################  
	```
### Configuration
1. Add application resource and set as follow:
	- Info
		- Type: Application resource
	- Dependency  
		Change the group resources Dependency from Before to After:
		- Before
			1. resources 1
			1. ddns resource
			1. resources 2
		- After
			1. resources 1
			1. application resource
			1. ddns resource
			1. resources 2
	- Recovery Operation
		- Recovery Operation at Activity Failure Detection
			- Retry Count: 2 time
			- Failover Threshold: 0 time
			- Final Action: No operation (active next resource)
		- Recovery Operation at Deactivity Failure Detection
			- Final Action: No operation (deactive next resource)
	- Details
		- Resident Type: Non-Resident
		- Start Path: RemoveRecord1.bat
		- Tuning
			- Start
				- Domain: Set the target domain name (e.g. test.local)
				- Accout: Set DNS Account
				- Password: Set DNS Account password (It will be encrypted)
1. Edit ddns resource Properties
	- Dependency  
		Change the group resources Dependency from Before to After:
		- Before
			1. resources 1
			1. ddns resource
			1. resources 2
		- After
			1. resources 1
			1. application resource
			1. ddns resource
			1. resources 2
	- Details
		- Delete the Registered IP Address: Check
1. Apply the configuration

## Note
Application resource takes some time to get activated for DNS Server operation command (Powershell Get-DnsServer/Remove-DnsServer command).

## Reference
https://docs.microsoft.com/en-us/powershell/module/dnsserver/?view=win10-ps
