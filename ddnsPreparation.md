# Sample setting on DNS Server to allow Dynamic update for dddns resource

## Enable Dynamic Update
1. Log on to DNS server.
1. Start DNS Manager.
1. Open "Forward Lookup Zones" in the left pane.
1. Right click the target domain under "Forward Lookup Zones" and select "Properties".
1. Select [General] tab  
	- Select "Secure only" in Dynamic updates.
	- [OK]

## Give permission to primary/secondary server
1. Select the target domain under "Forward Lookup Zones" in the left pane.
1. Right click primary and secondary servers and select "Properties".
1. Select [Security] tab  
	- [Advanced]
1. Select [Add]  
	- [Select a principal]
	- Add primary and secondary servers as computer objects (*)
	- [OK]  
		\* If the server already exists, please edit their permissions as the step 10. 
1. Select [This object and all descendant objects] in "Applies to:" box  
	- Check [Write all properties] and [Delete subtree]
	- [OK]
