##  **Enable SQL Server Agent in SSMS**

To allow external collectors (e.g., Prometheus) to query the SQL Server engine, you need to **enable the SQL Server Agent**.

### **Steps:**

1. Open **SQL Server Management Studio (SSMS)**  
2. In the **Object Explorer**, locate **SQL Server Agent**  **Right click** and Start the Agent. 
<img width="1366" height="768" alt="Screenshot (12)" src="https://github.com/user-attachments/assets/db511a01-c630-4294-981f-b58821a813ee" />


###  Enabling Automatic Start for SQL Server Agent

####  Using Windows Services Manager

Follow the steps below to configure the **SQL Server Agent** service to start automatically when Windows boots:

1. Press **`Windows + R`** to open the Run dialog.  
2. Type **`services.msc`** and press **Enter** to open the **Services** window.  
3. Locate the service named **SQL Server Agent (<InstanceName>)**, where `<InstanceName>` is the name of your SQL Server instance.  
4. Double-click the **SQL Server Agent** service to open its **Properties** window.  
5. In the **Startup type** dropdown menu, select **Automatic**.  
   - You can also choose **Automatic (Delayed Start)** if you want other services to start first.  
   <img width="1366" height="768" alt="Screenshot (10)" src="https://github.com/user-attachments/assets/c13b2527-8396-4bb6-b7e4-e4c696439df2" />

6. Click **Apply**, and then **OK** to save the changes.To verify it check startup type changes to automatic. 
<img width="1366" height="768" alt="Screenshot (11)" src="https://github.com/user-attachments/assets/2e8d58c9-d36e-46f5-b162-4cc57d99d54e" />
