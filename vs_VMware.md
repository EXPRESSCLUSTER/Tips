# Benefits to use EXPRESSCLUSTER X (ECX) Guest OS cluster comparing with VMware vSphere

```bat
           Active VM                               Standby VM
   +------------------------+              +------------------------+
   |  Application (Active) <----------------> Application (Active)  |
   |   EXPRESSCLUSTER X     |  Clustered   |   EXPRESSCLUSTER X     |
   |                        |              |                        |
   | Guest OS (Win/Lin/Sol) |              | Guest OS (Win/Lin/Sol) |
   +------------------------+              +------------------------+
+------------------------------+        +------------------------------+
|                              |        |                              |
|          VMware ESXi         |        |          VMware ESXi         |
|                              |        |                              |
+------------------------------+        +------------------------------+
```

## VS vSphere HA
- ECX can monitor applications running on Guest OS.  
	So, it can detect application errors on Guest OS.
- ECX can monitor Guest OS I/O delay.
	So, it can detect Guest OS hang or Disk I/O delay.
- ECX can monitor Standby VM.  
	So, it can detect errors on Standby VM.
- In the case of Shared Disk, Sync Mirror or Sync Hybrid-Disk cluster, RPO is 0.  
- In the case of Active VM down, RTO is shorter.  
	Because vSphere HA needs VM boot time on Seconday host, however, ECX needs only application start time.
- ECX Guest OS cluster can be configures with vSphere Essential Kit Edition License.
- Shared storage is not mandatory for Mirror od Diskless cluster.
	* By using vSAN, vSphere HA can also be configured without Shared Storage.  
		However, vSAN requirs more than 3 servers and additional license fee.  
		ECX can be configured with 2 servers.
- Since Shared Storage is not mandatory, ECX enable DR cluster.
- In the case of using Dynamic DNS, ECX enable seamless access to Active Server before and after failover with ddns resource.
- In the case of clustering multi applications, ECX can control start/stop order.
- ECX can monitor NW path.  
	So, it can detect troubles on NW between Active VM and client.

## VS vSphere FT
- ECX can monitor applications running on Guest OS.  
	So, it can detect application errors on Guest OS.
- ECX can monitor Guest OS I/O delay.
	So, it can detect Guest OS hang or Disk I/O delay.
- ECX can monitor Standby VM.  
	So, it can detect errors on Standby VM.
- ECX Guest OS cluster can be configures with vSphere Essential Kit Edition License.
- In the case of using Dynamic DNS, ECX enable seamless access to Active Server before and after failover with ddns resource.
- In the case of clustering multi applications, ECX can control start/stop order.
- ECX can monitor NW path.  
	So, it can detect troubles on NW between Active VM and client.
- In the case of Mirror or Hybrid-Disk cluster, since ECX replicate only write I/O on specified partition, NW traffice between Active and Standby VM may be reduced.

## VS vSphere Replication
- Since ECX is High Availability SW, it has monitoring and failover features.
- In the case of Shared Disk, Sync Mirror or Sync Hybrid-Disk cluster, RPO is 0.  

## Tips
If the customer requires Host OS cluster and prefer vSphere features, you can propose EXPRESSCLUSTER SingleServerSafe with vSphere features.
