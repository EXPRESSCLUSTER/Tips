# How to create a same Web Server on multi Windows cluster nodes with IIS
This QSG shows how to create a same Website on 2 nodes which are Windows and clustered with Mirror Disk.

## Sample Cluster Configuration
- Failover group1
	- md1
		- Data Partition: E: drive
		- Cluster Partition: X: drive
	- cifs1
		- Execute the automatic saving of shared configuration of drive: Check
		- Target Drive: E: drive
		- Shared Configuration File: E:\shared.conf
	- fip1
		- 192.168.11.101
	- script1
- Failover group2
	- fip2
		- 192.168.11.201
	- script2

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
On both nodes
1. Start IIS Manager
1. Remove Default Site
1. Add Website
	- Physical Path: \\192.168.11.101\IIS_root (The shared folder)
	- "Connect as" button -> "Specific user" -> Set user name and password to access the shared folder "E:\IIS_root"
	- "Test Settings" button  
		\* If IIS shows connection errors, check the shared folder is accessible or not.
	- Binding IP address: 192.168.11.101 (fip1)

## Memo
- 2 ノードクラスタの現用系と待機系で、IIS で同じ Web site を立ち上げる。
- IIS が参照するのは cifs 共有されてる md。
- 同じサイトを複数サーバで起動する構成なので、PP ガイドにある script リソース（FO 時に IIS の再起動いる）じゃなくてサービスリソースで、既に活性してる場合無視設定。
- FTP サービスは試してないけど、同じ方式で行ける気がする。
