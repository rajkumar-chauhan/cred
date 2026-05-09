

# Monitoring MSSQL on Windows Server  
### A Guide to Maximizing Database Performance  


---

## 🎯 **Objective**

The objective of this document is to **monitor MSSQL performance metrics** on a Windows Server using **Prometheus** and **Grafana**.  
It includes complete setup instructions for:
- Configuring SQL Server Agent If not Enabled 
- Installing and running Windows Exporter  
- Visualizing MSSQL metrics in Grafana dashboards  

---

##  **Requirements**

Before starting, ensure the following prerequisites are met:

| Component | Description |
|------------|-------------|
|  **Windows Server** | Host machine where MSSQL Server is installed |
|  **MSSQL Server 2022 Developer Edition** | Database engine to monitor |
|  **SQL Server Management Studio (SSMS)** | For database administration |
|  **Prometheus** | Metrics collection tool (installed on Ubuntu) |
|  **Grafana** | Visualization tool (installed on Ubuntu) |
|  **Windows Exporter** | Exposes system and MSSQL metrics |
|  **Open Ports** | `9182` (Windows Exporter), `9090` (Prometheus), `3000` (Grafana) |

---


##  **Enable SQL Server Agent in SSMS**
Follow the below link if Sql Server Agent is not Enable

[Click here for MSSQL Server Agent documentation](https://github.com/ot-client/o11y-k8s-setup-template/blob/108-mssql-poc-documentation/docs/mssql/server_agent/readme.md)

---

##  **Install Prometheus Windows Exporter**

Prometheus Windows Exporter helps expose system and MSSQL metrics for monitoring.

### **Steps:**

1. **Download Windows Exporter**  
   Visit the [official releases page](https://github.com/prometheus-community/windows_exporter/releases) to download the latest version of **Windows Exporter**.
   
   **Note:If Windows Exporter is not installed under C:\Program Files\windows_exporter, it may not run as a Windows service reliably.**

2. **Download the Binary File**  
   Select and download the binary file:

   
3. **Open Command Prompt as Administrator**  
- Press **Start → Search “cmd” → Right-click → Run as Administrator**.

4. **Run the Exporter Manually**  
Execute the following command to start the Windows Exporter and fetch SQL Server statistics:

```bash
"C:\Program Files\windows_exporter\windows_exporter-0.31.3-amd64.exe" --collectors.enabled="cpu,logical_disk,net,os,service,system,textfile,mssql"
```

5.**Verify the Metrics Endpoint**
 - Press Open your browser and navigate to:
[http://`<PrivateIp>`:9182/metrics](http://`<PrivateIp>`:9182/metrics)

---

##  Run Windows Exporter Automatically After System Restart
 To ensure the Windows Exporter service starts automatically after a system reboot, follow these steps:

**Open Registry Editor**

- Press Press Start → Search “regedit” → Open Registry Editor

2. Navigate to the Following Path:
**HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\windows_exporter**
Modify the ImagePath Value,Double-click on ImagePath.

3. Replace the existing value with the following (adjust if your installation path differs):
```bash
"C:\Program Files\windows_exporter\windows_exporter-0.31.3-amd64.exe" --collectors.enabled="cpu,logical_disk,net,os,service,system,textfile,mssql"
```
<img width="1366" height="768" alt="Screenshot (13)" src="https://github.com/user-attachments/assets/8726918c-d1fb-48eb-9659-baa839d93c0e" />

4. Press **`Windows + R`** to open the Run dialog.  
5. Type **`services.msc`** and press **Enter** to open the **Services** window.

6.Double-click the **window exporter** service to open its **Properties** window.

7.In the **Startup type** dropdown menu, select **Automatic**, 
 You can also choose **Automatic (Delayed Start)** if you want other services to start first. 

<img width="1366" height="768" alt="Screenshot (19)" src="https://github.com/user-attachments/assets/7f07fe79-c919-4113-b113-34ccb40f2b06" />


---

##  MSSQL Monitoring Metrics 

| **Category**                     | **Metric Description**                                                                                                                | **Purpose / Insight**                                                                                           |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Networking**                | **Network Traffic & Hourly Usage**                                                                                                    | Tracks incoming and outgoing traffic to monitor network throughput and identify congestion or latency.          |
| **Storage**                   | **Used Space & Available Space**                                                                                                      | Monitors disk utilization and available storage capacity to prevent database outages due to full disks.         |
| **Lock Statistics**           | **Lock Wait Time & Lock Timeout**                                                                                                     | Indicates database contention; high lock waits may point to performance bottlenecks in queries or transactions. |
| **Database Log Used**         | **Transaction Log Usage**                                                                                                             | Tracks how much of the SQL transaction log file is currently used to avoid log file overflow.                   |
| **Database Logs**             | **Log Pool Activities & Log Bytes**                                                                                                   | Measures the rate of log generation and log buffer utilization, useful for understanding transaction volume.    |
| **Database Latency**          | **Fetch / DLC Latency & Peak DLC Latency**                                                                                            | Reflects how long database operations take to fetch or commit data; helps identify performance degradation.     |
| **Database Size Trend**       | **Database Row Size & Log Size**                                                                                                      | Displays growth trends of data and log files over time to assist in capacity planning.                          |
| **Performance Counters**      | **SQL Server Activity, Database Activity, Buffer Cache, Disk I/O, Memory Manager, Lock Requests, Ratios**                             | Provides deep insight into database engine performance, memory utilization, and buffer cache efficiency.        |
| **Memory**              | **Overall Memory Usage (Committed & Free)**                                                                                           | Monitors SQL Server memory allocation and helps identify memory pressure or leaks.                              |
| **CPU**                | **CPU Usage & CPU Load per Process**                                                                                                  | Evaluates CPU consumption by SQL Server and related services to identify overutilization or idle patterns.      |
| **General Statistics** | **Database Health, Deadlocks, Network, Storage, Logins/Logouts, Connection Reset, Lock Waits, TempDB Free Space, Active Temp Tables** | Offers a high-level operational view of server performance and stability, covering all major resource areas.    |

##  MSSQL Observability Dashboard

You can download the MSSQL Grafana Dashboard JSON from the link below:

[Download MSSQL Grafana Dashboard JSON](https://github.com/ot-client/o11y-k8s-setup-template/blob/108-mssql-poc-documentation/grafana/grafana_dashboard/Opstree/Database/mssql.json)

---
<img width="1342" height="570" alt="Screenshot 2025-11-14 145715" src="https://github.com/user-attachments/assets/8bdc5f26-4971-416d-9ba8-a419530bb570" />

