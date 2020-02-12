# How to create a shared disk cluster on vSphere ESXi

## Overview
This guide shows how to create a shared disk cluster on vSphere ESXi.

## System Configuration
```bat
   +-------+                   +-------+
   |       |                   |       |
   |  VM1  | <-- Clustered --> |  VM2  |
   |  ECX  |                   |  ECX  |
   +-----+-+                   +-+-----+
         |                       |
       +-+-----------------------+-+
       |     Virtual hard disk     |
       |          (Shared)         |
       +---------------------------+
```
## Setup Shared Disk
1. Create 2 VMs with a virtual hard disk (vHDD) which is stored on each local datastores and used for system disk (e.g. C: drive).
1. Install OS on the 2 VMs.
1. Create a virtual hard disk (vHDD) which is stored on shared datastore and used for cluster shared disk.
	1. Log on to ESXi host with a SSH client such as TeraTerm.
	1. Create a directory to store the vHDD file (.vmdk):  
		```bat
		# mkdir /vmfs/volumes/shared_datastore/shared
		```
	1. Create the vHDD file (.vmdk):  
		```bat
		# vmkfstools -c <file size> -d eagerzeroedthick /vmfs/volumes/shared_datastore/shared/shared.vmdk
		```  
    **Note:**  
      \* The virtual hard disk should be created as "Thick Provisioning (Eager Zeroed)".  
	  \* The virtual hard disk should be created on VMFS. (NFS does not allow Thick Provisioning)  
	  \* You should create the shared vHDD with the command above or vCenter Server (GUI) because you cannot specify .vmdk file name and location with vSphere Host Client.  
	  \* When you expand the shared vHDD after you create it, please surey convert it to Thick Provisioning (Eager Zeroed). Because when expanding Thick Provisioning vHDD, it will be converted to "Thin Provisioning" automaticaly.  

1. Attach the vHDD for the both 2 VMs
	1. Stop the VM
	1. On vSphere Client, Edit the VM's settings
		1. Add a new  SCSI controller (e.g. SCSI controller 1)
			- Controller type: "VMware Paravirtual"
			- SCSI Bus Sharing: "None"  
    **Memo:**  
    \* It may be also OK: Controller type is "LSI Logical SAS" and SCSI Bus Sharing is "Physical".
		1. Add Existing hard disk and select the vHDD:  
			"/vmfs/volumes/shared_datastore/shared/shared.vmdk"
		1. Chenge the added vHDD settings:
			- Type: Thick Provisioning (Eager Zeroed)  
      **Memo:**  
      \* On Host Client window (not vCenter Server), sometimes the type is grayed out and you cannot change the settings.  
      \* In such a situation, click OK for Edit settings without changing any settings. Then right click the VM, select "Edit settings" and try to change the settings again.
			- Controller location: SCSI controller 1, SCSI (1:x)  
      **Memo:**  
       \* It may be better to set different number for "x" both VMs.
			- Disk mode: Independent - persistent
			- Sharing: Multi-writer sharing

## Checking Shared disk
### For Windows Cluster
1. Start only VM1. (Keep VM2 shutdown)  
	**Note:**  
  \* If VMs fail to start, settings for the shared vHDD are not enough.

1. On VM1, format the shared disk.
	- Start Windows Computer Management.
	- Make the shared disk Online.
	- Initialize it with GPT. (Not MBR)
	- Create the following partitions:
	\<In the case of Shared Disk\>
		- Partition1 for Disk NP  
			- Size: 20MB  
			- Drive Letter: As you like (sample "Z:")  
			- File System: RAW (Don't format)
		- Partition2 for Data Partition  
			- Size: As you like (sample: 500GB)  
			- Drive Letter: As you like (sample: "E:")  
			- File System: Ntfs  
	\<In the case of Hybrid Disk\>
		- Partition1 for Disk NP  
			- Size: 20MB  
			- Drive Letter: As you like (sample "Z:")  
			- File System: RAW (Don't format)
		- Partition2 for Cluster Partition  
			- Size: 1GB  
			- Drive Letter: As you like (sample "X:")  
			- File System: RAW (Don't format)
		- Partition3 for Data Partition
			- Size: As you like (sample: 500GB)  
			- Drive Letter: As you like (sample: "E:")  
			- File System: Ntfs
1. On VM1, confirm that you can see the shared disk (E:) on Explorer and create test file on it.
1. On VM1, make the shared disk Offline.
	- Start Windows Computer Management.
	- Make the shared disk Offline.
1. Shutdown VM1.

1. Start only VM2. (Keep VM1 shutdown)  
	**Note:**  
  \* If VMs fail to start, settings for the shared vHDD are not enough.

1. On VM2, format the shared disk.
	- Start Windows Computer Management.
	- Make the shared disk Online.
	- Confirm that you can see 3 prtitions which were created on VM1.
1. On VM2, confirm that you can see the shared disk (E:) on Explorer and the test file which was created on VM1.
1. On VM2, make the shared disk Offline.
	- Start Windows Computer Management.
	- Make the shared disk Offline.
