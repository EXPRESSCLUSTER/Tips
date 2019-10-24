# How to create a shared disk cluster on vSphere ESXi

## Overview
This guide shows how to create a shared disk cluster on vSphere ESXi.

## System Configuration
```bat
   +-------+                   +-------+
   |       |                   |       |
   |  VM1  | <-- Clustered --> |  VM2  |
   |       |                   |       |
   +-----+-+                   +-+-----+
         |                       |
       +-+-----------------------+-+
       |     Virtual hard disk     |
       |          (Shared)         |
       +---------------------------+
```
## Procedure
1. Create 2 VMs
1. Install OS on the VMs
1. Create a virtual hard disk (vHDD) which is used for cluster shared disk.
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
	  \* If you create the virtual disk with vSphere Web Client (GUI), you cannot specify .vmdk file name and path.  
	  \* If you expand the virtual disk after you create it as "Thick Provisioning (Eager Zeroed)", it will be converted to "Thin Provisioning" automaticaly.  

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
1. Start both VMs and set them up as shared disk cluster.  
	**Note:**  
  \* If VMs fail to start, settings for the shared vHDD are not enough.
