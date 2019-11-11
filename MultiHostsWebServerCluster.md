# How to create a same Web Server on multi Windows cluster nodes with IIS
This QSG shows how to create a same Website on 2 nodes which are Windows and clustered with Mirror Disk.

## Sample Cluster Configuration
- Failover group1
	- md1
		- Data Partition: E drive
		- Cluster Partition: X drive
	- cifs1
		- Execute the automatic saving of shared configuration of drive: Check
		- Target Drive: E drive
		- Shared Configuration File: E:\shared.conf
	- fip1
		- 192.168.11.101
	- service1
		- Service Name: World Wide Web Publishing Service
		- Do not assume it as an error when the service is already started: Check
- Failover group2
	- fip2
		- 192.168.11.201
	- service2
		- Service Name: World Wide Web Publishing Service
		- Do not assume it as an error when the service is already started: Check

## Setup
### Install EXPRESSCLUSTER
On both nodes
1. Create partitions for Mirror Disk.
1. Install EXPRESSCLUSTER X.
1. Register EXPRESSCULSTER licenses.

### Install IIS
On both nodes
1. Start Server Manager and Add roles and features
1. Install Web Server (IIS)

### Setup basic cluster
On Primary node
1. Create a cluster
- Failover group1
	- md1  
	- cifs1  
		- Execute the automatic saving of shared configuration of drive: Check
		- Target Drive: E: drive
		- Shared Configuration File: E:\shared.conf
	- fip1
		- 192.168.11.101
	- service1
		- Service Name: World Wide Web Publishing Service
		- Do not assume it as an error when the service is already started: Check
- Failover group2
	- fip2
		- 192.168.11.201
	- service2
		- Service Name: World Wide Web Publishing Service
		- Do not assume it as an error when the service is already started: Check
1. Apply the config

### Preparation for IIS
On Primary node
1. Create a folder for IIS  
	e.g.) E:\IIS_root
1. Share the folder for both cluster nodes user accounts

### Setup IIS
On Active Server
1. Start IIS Manager
1. Remove Default Site
1. Add 2 Websites
	- Website 1
		- Physical Path: \\192.168.11.101\IIS_root (The shared folder)
		- "Connect as" button -> "Specific user" -> Set user name and password to access the shared folder "E:\IIS_root"
		- "Test Settings" button  
			\* If IIS shows connection errors, check the shared folder is accessible or not.
		- Binding IP address: 192.168.11.101 (fip1)
	- Website 2
		- Physical Path: \\192.168.11.101\IIS_root (The shared folder)
		- "Connect as" button -> "Specific user" -> Set user name and password to access the shared folder "E:\IIS_root"
		- "Test Settings" button  
			\* If IIS shows connection errors, check the shared folder is accessible or not.
		- Binding IP address: 192.168.11.201 (fip2)

1. Move failover group
1. Do the same as step 1-3

## Memo
- 2 ノードクラスタの現用系と待機系で、IIS で同じ Web site を立ち上げる。
- IIS が参照するのは cifs 共有されてる md。
- 同じサイトを複数サーバで起動する構成。
- PP ガイドだと script リソースでやってるけど（FO 時に IIS の再起動はいる）、IIS の再起動なくても良さそうなので、サービスリソースで既に活性してる場合無視設定。（FO 時に、クライアント側でブラウザの再読み込みが必要なのを、IIS の再起動入れると解消できたりする？）
- FTP サービスは試してないけど、同じ方式で行ける気がする。
