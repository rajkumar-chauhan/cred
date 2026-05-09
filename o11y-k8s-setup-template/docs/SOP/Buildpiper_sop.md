# SOP: Service Onboarding in BuildPiper

## Objective

This document explains the Step -by-Step  process to onboard a new service in BuildPiper from scratch, including repository integration, environment setup, deployment configuration, and Helm template configuration.

## Step  1 : Integrate Repository in BuildPiper

 ### Step  1.1: Connect Git Repository

First, integrate your Git repository in BuildPiper.

Navigate to Integration and click on `add repo` and select the `VCS (Github, Bitbucket and Gitlab)` And configure all the details.


<img width="1366" height="693" alt="image" src="https://github.com/user-attachments/assets/4e3469be-ccf6-467a-8d33-17a18e4c6706" />



<img width="1366" height="693" alt="image" src="https://github.com/user-attachments/assets/a9e5c613-e75d-4b01-9ff1-3b60bd3057b5" />

### Step  1.2: Configure Secrets

After repository integration:

choose the `secret` if you have existing secrets otherwise create a new serets

click on new `secret`

Add required credentials (repo name, tokens, etc.)

Click `Save`


<img width="1366" height="693" alt="image" src="https://github.com/user-attachments/assets/5af1a53b-fade-4e8a-8506-11b021bb1e49" />

and complete the repo integration part Step s 1.1 and than save the configuration

 ## Step  2: setup the application for service

### Step  2.1: Select application

Select your existing `application` or create a new one 
<img width="1366" height="698" alt="image" src="https://github.com/user-attachments/assets/0f1b8f94-964e-405c-b463-c695c8e5254d" />

Step  2.2: Add New `Service`

Click Add `Service`

Enter the service name
<img width="1366" height="698" alt="image" src="https://github.com/user-attachments/assets/c19f515e-edcf-494c-912e-03d19d1e56da" />

give the name of the service 
<img width="1366" height="698" alt="image" src="https://github.com/user-attachments/assets/20d130b0-1979-49db-9eb3-b9edb275d361" />

### Step  2.1: Select enviroment

select the existing `enviroment if any otherwise create it manually inside your application

 navigate to enviroment overview and click add enviroments
 and create an enviroment

## Step  3: Configure Environments & Job Template

After clicking **Save and Continue**, complete the following configuration:

### Select Environment and Job Template
- Select the required **Environment**
- Select the appropriate **Job Template**
- Click **Save and Continue**

### Important Configuration


When selecting environments:

- Select correct **Container Registry**

Set Image Name:

```bash
demo-grafana/dev/dev-monitoring
```

Enable Manual Trigger for all stages

Disable Push Data for Insights

Click Save and Continue
<img width="1366" height="639" alt="image" src="https://github.com/user-attachments/assets/243b63e1-c245-42e5-91a2-97135b1291cf" />
## Step  4: Configure Deployment 

Navigate to Env Deploy Details

Select Custom Manifest File / GitOps
<img width="1366" height="639" alt="image" src="https://github.com/user-attachments/assets/c08a4319-7e59-4d0f-b8dd-ae3436b115ac" />
after completeing above Step s you will be showing like this
<img width="1366" height="639" alt="image" src="https://github.com/user-attachments/assets/f8afc63c-688d-450f-a2d2-c532aa795a63" />
## Step  4.1 : Deployment Configuration Settings



Configure the following settings:

- **Image Pull Policy** → `Always`
- **Resource Kind** → Not Mandatory
- **Define Raw Key Value Pairs** → Disabled
- **Validate Deployment Rollout** → Enabled

#### For CRD Deployment
- Enable **Server Side Apply**
Otherwise → Keep it Disabled
<img width="1097" height="453" alt="image" src="https://github.com/user-attachments/assets/697fbfae-1ad5-43f1-9b1e-c3526368d8ed" />

## Step 5: Configure Helm Template Deployment


Configure the source details as follows:

- Select **Git URL**
- Click **Load Branch**
- Select the desired **Branch**
- Enter the **File/Folder Path**
- Enter the **Release Name**
<img width="1097" height="453" alt="image" src="https://github.com/user-attachments/assets/ae273731-bbd5-4c3f-8146-9f886ebdd9ea" />

## Step  6 : Configure Values File

Under Values File Section:

Select → Via Git Repository

Load Branch

Enter values.yaml file path (including file name)
<img width="1130" height="340" alt="image" src="https://github.com/user-attachments/assets/01a3b1e3-559a-4225-b79b-1e101fcd8c7e" />

## Final Settings

Disable Pre Hook & Post Hook

<img width="1122" height="198" alt="image" src="https://github.com/user-attachments/assets/b54c4e30-75e5-4d74-b3b2-6c8e24efa57f" />
and than save and continue 
After completing all above Steps:

Service will be successfully onboarded in BuildPiper

CI/CD pipeline will be configured

Deployment will be ready via Helm template

Environment and registry will be properly configured





