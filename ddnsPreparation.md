# Sample setting on DNS Server to allow Dynamic update for dddns resource

## Enable Dynamic Update
1. Log on to DNS server.
1. Start DNS Manager.
1. Open "Forward Lookup Zones" in the left pane.
1. Right click the target domain under "Forward Lookup Zones" and select "Properties".
1. Select [General] tab  
	- Select "Secure only" (\*) or "Nonsecure and secure" in Dynamic updates.
	- [OK]
- **\* Note**
	- If you select "Secure only", you need to follow next section to give a permission to cluster servers.

## Give permission to cluster servers
If you selected "Nonsecure and secure" when enabling Dynamic Update, you can ignore this section.
### Prerequisite
- All cluster servers join Domain.
### Procedure
1. Select the target domain under "Forward Lookup Zones" in the left pane.
1. Right click primary and secondary servers and select "Properties".
1. Select [Security] tab  
	- [Advanced]
1. Select [Add]  
	- [Select a principal]
	- Add cluster servers as computer objects (*)
	- [OK]  
		\* If the servers already exists please edit their permissions as the next 10. 
1. Select [This object and all descendant objects] in "Applies to:" box  
	- Check [Write all properties] and [Delete subtree]
	- [OK]
