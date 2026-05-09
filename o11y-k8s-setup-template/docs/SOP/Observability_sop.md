# Observability Stack Setup on Kubernetes 

This guide walks you step‑by‑step through setting up a **full observability stack** on a Kubernetes cluster using **Helm**. We’ll deploy:

* **Grafana** (Dashboards & Visualization)
* **VictoriaMetrics** (Metrics backend)
* **Loki** (Logs)
* **Tempo** (Distributed Tracing)

Each section explains **what you are doing**, **why it is needed**, and **what to verify** after running commands.

---

## 1. Clone the Repository

Start by cloning the observability setup template repository:

```bash
git clone git@github.com:ot-client/o11y-k8s-setup-template.git
```

 **What this does**
This repository contains Helm charts and configuration files for Grafana, VictoriaMetrics, Loki, and Tempo and so on.

---

## 2. Configure Kubernetes Access (Kubeconfig)

Set the kubeconfig file so `kubectl` and `helm` know which cluster to talk to:

```bash
export KUBECONFIG=~/.kube/lke-config
```

 **What this does**
This command points your CLI tools to the correct Kubernetes cluster configuration.

---

## 3. Verify Cluster Context

Before installing anything, verify that you are connected to the correct cluster:

```bash
kubectl config view
```

**Verify the following**

* Correct cluster name
* Correct user
* Correct namespace context (if set)

This step helps avoid accidental deployments to the wrong cluster.

>we have to also check the namespace, pod, pvc, service, ingress and secrets

---


## 4. Grafana Setup

Grafana is used for dashboards, alerts, and visualizing metrics, logs, and traces.

### 4.1 Navigate to Grafana Directory

```bash
cd grafana/grafana-dev
```

---

### 4.2 Update Helm Dependencies

```bash
helm dep update
```

 **What this does**
Downloads all dependent charts required by the Grafana Helm chart.

---

### 4.3 Create Azure AD Secret (SSO Configuration)

Grafana uses this secret to authenticate users via Azure AD (SSO).

```bash
kubectl create secret generic grafana-azure-ad-creds \
  --from-literal=client-id="<YOUR_AZURE_AD_CLIENT_ID>" \
  --from-literal=client-secret="<YOUR_AZURE_AD_CLIENT_SECRET>" \
  --from-literal=tenant-id="<YOUR_AZURE_AD_TENANT_ID>" \
  -n monitoring
```

 **What this does**
Stores Azure AD credentials securely in Kubernetes so Grafana can use them at runtime.

---

### 4.4 Install Grafana

```bash
helm install grafana . -n monitoring -f values.yaml
```

 **What this does**
Deploys Grafana into the `monitoring` namespace using custom values from `values.yaml`.

---

### 4.5 Verify Grafana Deployment

**Check Pods**

```bash
kubectl get pod -n monitoring
```

**Check Persistent Volume Claims (PVCs)**

```bash
kubectl get pvc -n monitoring
```

**Check Azure AD Secret**

```bash
kubectl get secret grafana-azure-ad-creds -n monitoring
```

 Grafana is considered ready when pods are in `Running` state and PVCs are `Bound`.

---

## 5. Sequentialy delete the grafana 

### 5.1 check firstly how the grafana was install 

```bash
helm list -n monitoring
```

if the output is `grafana` it means it installed by the helm .

if install using helm :

### 5.2 Helm uninstall

```bash
helm uninstall grafana -n monitoring
```
this will automatically delete :
* statefulsets
* pod
* service
* configmap
* sidecar
* RBAC (if any)

### 5.3 Check pvc

```bash
kubectl get pvc -n monitoring | grep grfana
```

helm doesn't delete the pvc by default so we have to manually delete the pvc 

```bash
kubectl delete pvc <pvc-name> -n monitoring
```

### 5.4 delete Azure secret

check secret :

```bash
kubectl get secret -n monitoring | grep grafana
```
delete the secret manually :


```bash 
kubectl delete secret <grafana-secret-name> -n monitoring
```
delete the tls manually :

```bash
kubectl delete secret grafana-tls -n monitoring
```
delete the ingress :

```bash
kubectl delete ingress <ingress-name> -n monitoring
```

after delete you can verify :

```bash
kubectl get all -n monitoring | grep grafana
kubectl get pvc -n monitoring
kubectl get secret -n monitoring
kubectl get ingress -n monitoring
```


---


# Grafana Datasource Setup

Install Datasources

Navigate to the chart directory:

```bash
cd grafana/grafana_datasource
```

Run the Helm install command:

```bash
helm install grafana-datasource . -n monitoring
```
Upgrade Datasources

If the chart is already installed and you want to update the datasources:

```bash
helm upgrade grafana-datasource . -n monitoring
```
Verify ConfigMap

Check if the datasource ConfigMap is created:

```bash
kubectl get configmap -n monitoring
```


## Delete Datasources

If the Helm release is already deployed and you want to remove the datasources:

First check the Helm release name:
```bash
helm list -n monitoring
```
Delete the release:
```bash
helm uninstall grafana-datasource -n monitoring
```

Verify that resources are removed:

```bash
kubectl get configmap -n monitoring
```
## Delete Datasources (If Not Installed Using Helm)

If the datasource ConfigMap was created manually using kubectl apply instead of Helm, you need to delete the ConfigMap directly.

Step 1: Check ConfigMaps

List all ConfigMaps in the namespace:

```bash
kubectl get configmap -n monitoring
```

Identify the ConfigMap related to Grafana datasources.

Step 2: Delete the ConfigMap



Delete the datasource ConfigMap:

```bash
kubectl delete configmap <configmap-name> -n monitoring
```

Example:
```bash
kubectl delete configmap grafana-datasource -n monitoring
```
Step 3: Restart Grafana

After deleting the ConfigMap, restart the Grafana pod so the changes reflect:
```bash
kubectl rollout restart deployment grafana -n monitoring
```
Verification

Check again to confirm the ConfigMap is deleted:
```bash
kubectl get configmap -n monitoring
```





## 6. VictoriaMetrics Setup

VictoriaMetrics acts as the **metrics storage backend**.

### 6.1 Navigate to VictoriaMetrics Directory

```bash
cd victoriametrics-dev
```

---

### 6.2 Update Helm Dependencies

```bash
helm dep update
```

---

### 6.3 Install VictoriaMetrics

```bash
helm install vm . -n monitoring -f values.yaml
```

 **What this does**
Deploys VictoriaMetrics into the `monitoring` namespace.

---

### 6.4 Verify VictoriaMetrics Deployment

**Check Pods**

```bash
kubectl get pod -n monitoring
```

**Check PVCs**

```bash
kubectl get pvc -n monitoring
```

**List Helm Releases**

```bash
helm list -n monitoring
```

---

## 7. Sequentialy delete the VictoriaMetrics 

### 7.1 check firstly how the VictoriaMetrics was install 

```bash
helm list -n monitoring
```

if the output is `vm` it means it installed by the helm .

if install using helm :

### 7.2 Helm uninstall

```bash
helm uninstall vm -n monitoring
```
this will automatically delete :
* statefulsets
* pod
* service
* configmap
* sidecar
* RBAC (if any)

### 7.3 Check pvc

```bash
kubectl get pvc -n monitoring | grep vm
```

helm doesn't delete the pvc by default so we have to manually delete the pvc 

```bash
kubectl delete pvc <pvc-name> -n monitoring
```

### 7.4 delete CRD

delete the CRD manually : 

```bash
kubectl get crd | grep victoriametrics | awk '{print $1}' | xargs kubectl delete crd

```

### 7.5 Remove Webhook

```bash 
kubectl delete validatingwebhookconfiguration vm-operator-admission
```



```bash
kubectl delete mutatingwebhookconfiguration vm-operator-admission
```


Checks the ingress :

```bash
kubectl get ingress -n monitoring
```

```bash
kubectl delete ingress <ingress-name> -n monitoring
```

after delete you can verify :

```bash
kubectl get all -n monitoring | grep vm
kubectl get pvc -n monitoring
kubectl get secret -n monitoring
kubectl get ingress -n monitoring
```


---

## 6. Loki Setup (Logs)

Loki is used for collecting and querying logs.

### 6.1 Navigate to Loki Directory

```bash
cd loki
```

---

### 6.2 Update Helm Dependencies

```bash
helm dep update
```

---

### 6.3 Install Loki

```bash
helm install loki . -n logging -f values.yaml
```

---

### 6.4 Verify Loki Deployment

**Check Pods**

```bash
kubectl get pod -n logging
```

**Check PVCs**

```bash
kubectl get pvc -n logging
```

**List Helm Releases**

```bash
helm list -n logging
```

---

## 7. Sequentialy delete the Loki 

### 7.1 check firstly how the Loki was install 

```bash
helm list -n logging
```

if the output is `loki` it means it installed by the helm .

if install using helm :

### 7.2 Helm uninstall

```bash
helm uninstall loki -n logging
```
this will automatically delete :
* statefulsets
* pod
* service
* configmap
* sidecar
* RBAC (if any)

### 7.3 Check pvc 

```bash
kubectl get pvc -n logging | grep vm
```

helm doesn't delete the pvc by default so we have to manually delete the pvc 

```bash
kubectl delete pvc <pvc-name> -n logging
```

### 7.4 delete CRD

delete the CRD manually : 

```bash
kubectl get crd | grep victoriametrics | awk '{print $1}' | xargs kubectl delete crd

```

### 7.5 Remove Webhook

```bash 
kubectl delete validatingwebhookconfiguration vm-operator-admission
```



```bash
kubectl delete mutatingwebhookconfiguration vm-operator-admission
```


Checks the ingress :

```bash
kubectl get ingress -n monitoring
```

```bash
kubectl delete ingress <ingress-name> -n monitoring
```

after delete you can verify :

```bash
kubectl get all -n monitoring | grep vm
kubectl get pvc -n monitoring
kubectl get secret -n monitoring
kubectl get ingress -n monitoring
```


---


# Install REMS Postgres Exporter

Move to the chart directory:

```
cd exporters/rems-postgres-exporter
```
Download  the dependencies  

```bash
helm dep update
```

Install the Helm chart:

```
helm install rems-postgres-exporter . -n monitoring
```

---

# Upgrade REMS Postgres Exporter

If changes are made to the chart or values file:

```
helm upgrade rems-postgres-exporter . -n monitoring
```

---

# Verify Installation

Check whether the exporter resources are created:

```
kubectl get pods -n monitoring
```

Check services:

```
kubectl get svc -n monitoring
```

Check if the exporter pod is running:

```
kubectl get pods -n monitoring | grep postgres
```

---

# Delete Exporter (If Installed Using Helm)

First check Helm releases:

```
helm list -n monitoring
```

Uninstall the exporter:

```
helm uninstall rems-postgres-exporter -n monitoring
```

Verify resources are removed:

```
kubectl get pods -n monitoring
```

---

# Delete Exporter (If Not Installed Using Helm)

If the exporter was applied manually using `kubectl apply`, delete the resources directly.

Check resources:

```
kubectl get all -n monitoring | grep postgres
```

Delete deployment:

```
kubectl delete deployment rems-postgres-exporter -n monitoring
```

Delete service:

```
kubectl delete svc rems-postgres-exporter -n monitoring
```

Verify deletion:

```
kubectl get pods -n monitoring
```

---




# Install Redis Exporter

Move to the chart directory:

```
cd exporters/redis-expoter
```

Update Helm dependencies (if defined in Chart.yaml):

```
helm dep update
```

Install the Redis exporter using Helm:

```
helm install redis-exporter . -n monitoring
```

---

# Upgrade Redis Exporter

If changes are made in the chart or values file:

```
helm upgrade redis-exporter . -n monitoring
```

---

# Verify Installation

Check if the exporter pod is running:

```
kubectl get pods -n monitoring
```

Check services:

```
kubectl get svc -n monitoring
```

Check specifically for Redis exporter:

```
kubectl get pods -n monitoring | grep redis
```

---

# Delete Redis Exporter (If Installed Using Helm)

Check Helm releases:

```
helm list -n monitoring
```

Uninstall the exporter:

```
helm uninstall redis-exporter -n monitoring
```

Verify resources are removed:

```
kubectl get pods -n monitoring
```

---

# Delete Redis Exporter (If Not Installed Using Helm)

If the exporter was deployed manually using `kubectl apply`, delete the resources directly.

Check exporter resources:

```
kubectl get all -n monitoring | grep redis
```

Delete deployment:

```
kubectl delete deployment redis-exporter -n monitoring
```

Delete service:

```
kubectl delete svc redis-exporter -n monitoring
```

Verify deletion:

```
kubectl get pods -n monitoring
```

---



# Install Alertmanager

Move to the chart directory:

```
cd alertmanager/alertmanager_setup
```

Update Helm dependencies (if defined in Chart.yaml):

```
helm dep update
```

Install Alertmanager using Helm:

```
helm install alertmanager . -n monitoring
```

---

# Upgrade Alertmanager

If changes are made to `values.yaml` or chart configuration:

```
helm upgrade alertmanager . -n monitoring
```

---

# Verify Installation

Check if Alertmanager pods are running:

```
kubectl get pods -n monitoring
```

Check services:

```
kubectl get svc -n monitoring
```

Check specifically for Alertmanager:

```
kubectl get pods -n monitoring | grep alertmanager
```

---

# Delete Alertmanager (If Installed Using Helm)

First check Helm releases:

```
helm list -n monitoring
```

Uninstall Alertmanager:

```
helm uninstall alertmanager -n monitoring
```

Verify resources are removed:

```
kubectl get pods -n monitoring
```

---

# Delete Alertmanager (If Not Installed Using Helm)

If Alertmanager was deployed manually using `kubectl apply`, delete the resources directly.

Check Alertmanager resources:

```
kubectl get all -n monitoring | grep alertmanager
```

Delete deployment:

```
kubectl delete deployment alertmanager -n monitoring
```

Delete service:

```
kubectl delete svc alertmanager -n monitoring
```

Verify deletion:

```
kubectl get pods -n monitoring
```

---



# Install Alerting Rules

Move to the chart directory:

```
cd alertmanager/alerting_rules
```

Install the Helm chart:

```
helm install alert-rules . -n monitoring
```

---

# Upgrade Alerting Rules

If changes are made to alert rules:

```
helm upgrade alert-rules . -n monitoring
```

---

# Verify Alert Rules

Check whether alert rule resources are created:

```
kubectl get vmrule -n monitoring
```

or

```
kubectl get prometheusrule -n monitoring
```

Check specific rule resources:

```
kubectl get vmrule -n monitoring | grep alert
```

---

# Delete Alert Rules (If Installed Using Helm)

Check Helm releases:

```
helm list -n monitoring
```

Uninstall the Helm release:

```
helm uninstall alert-rules -n monitoring
```

Verify resources are deleted:

```
kubectl get vmrule -n monitoring
```

---

# Delete Alert Rules (If Not Installed Using Helm)

If the alert rules were applied manually using `kubectl apply`, delete the rule resources directly.

Check resources:

```
kubectl get vmrule -n monitoring
```

Delete all rule resources:

```
kubectl delete vmrule --all -n monitoring
```

or delete specific rule:

```
kubectl delete vmrule <rule-name> -n monitoring
```

Verify deletion:

```bash
kubectl get vmrule -n monitoring
```

---

# Monitoring namespace Cleanup 



# Step 1: Verify Monitoring Namespace Resources

Check all resources running in the monitoring namespace.

```
kubectl get all -n monitoring
```

You can also check pods specifically:

```
kubectl get pods -n monitoring
```

Example components that may exist:

* Grafana
* Alertmanager
* Blackbox Exporter
* Redis Exporter
* Postgres Exporter
* VictoriaMetrics components
* Node Exporter
* vmagent
* vmalert
* vminsert
* vmselect
* vmstorage

---

# Step 2: Delete the Monitoring Namespace

Delete the entire namespace to remove all namespace-scoped resources.

```
kubectl delete namespace monitoring
```

This will delete:

* Pods
* Deployments
* StatefulSets
* Services
* ConfigMaps
* Secrets
* ServiceAccounts
* Roles and RoleBindings

---

# Step 3: Verify Namespace Deletion

Check if the namespace still exists:

```
kubectl get ns
```

If the namespace is still in **Terminating** state:

```
kubectl get ns monitoring
```

Wait until the namespace is completely deleted.

---

# Step 4: Check Cluster-Level Resources

Some resources created by Helm charts or operators may exist at the **cluster level**.
These resources are not deleted automatically when the namespace is removed.

Check the following resources.

### Custom Resource Definitions (CRDs)

```
kubectl get crd | grep vm
```

Examples:

* vmagent
* vmalert
* vminsert
* vmselect
* vmstorage

Delete if required:

```
kubectl delete crd <crd-name>
```

---

### Cluster Roles

```
kubectl get clusterrole | grep vm
```

Delete if needed:

```
kubectl delete clusterrole <clusterrole-name>
```

---

### Cluster Role Bindings

```
kubectl get clusterrolebinding | grep vm
```

Delete if required:

```
kubectl delete clusterrolebinding <clusterrolebinding-name>
```

---

### Validating / Mutating Webhooks

Sometimes operators create admission webhooks.

Check them using:

```
kubectl get validatingwebhookconfigurations
```

```
kubectl get mutatingwebhookconfigurations
```

Delete if related to the monitoring stack.

```
kubectl delete validatingwebhookconfiguration <name>
kubectl delete mutatingwebhookconfiguration <name>
```

---

# Step 5: Verify Cleanup

After deletion, verify that no monitoring resources remain.

Check namespaces:

```
kubectl get ns
```

Check pods across the cluster:

```
kubectl get pods -A | grep monitoring
```

Check CRDs:

```
kubectl get crd
```

Check cluster roles:

```
kubectl get clusterrole
```

---

# Final Verification

Ensure the following:

* `monitoring` namespace does not exist
* No monitoring pods are running
* No leftover CRDs related to monitoring exist
* No cluster-level RBAC resources remain


# OpenTelemetry Operator and Collector Deployment 


# 1. Install OpenTelemetry Operator

Move to the operator chart directory:

```
cd otel/otel-operator
```

Update Helm dependencies (if defined):

```
helm dep update
```

Install the OpenTelemetry Operator:

```
helm install otel-operator . -n observability
```

---

# Verify Operator Installation

Check pods:

```
kubectl get pods -n observability
```

Check CRDs installed by the operator:

```
kubectl get crds | grep opentelemetry
```

Expected CRDs may include:

* opentelemetrycollectors.opentelemetry.io
* instrumentations.opentelemetry.io

---

# Delete OpenTelemetry Operator (If Installed Using Helm)

Check Helm releases:

```
helm list -n observability
```

Uninstall the operator:

```
helm uninstall otel-operator -n observability
```

Verify resources are removed:

```
kubectl get pods -n observability
```

---

# Delete OpenTelemetry Operator (If Not Installed Using Helm)

If the operator was deployed manually using `kubectl apply`, delete the resources directly.

Check operator resources:

```
kubectl get all -n observability | grep otel
```

Delete the deployment:

```
kubectl delete deployment otel-operator -n observability
```

Delete webhook configurations if present:

```
kubectl get validatingwebhookconfigurations | grep otel
kubectl get mutatingwebhookconfigurations | grep otel
```

Example deletion:

```
kubectl delete validatingwebhookconfiguration opentelemetry-operator
kubectl delete mutatingwebhookconfiguration opentelemetry-operator
```

Delete CRDs if required:

```
kubectl get crds | grep opentelemetry
```

Example:

```
kubectl delete crd opentelemetrycollectors.opentelemetry.io
kubectl delete crd instrumentations.opentelemetry.io
```

---

# 2. Install OpenTelemetry Collector

Move to the collector chart directory:

```
cd otel/otel-collector
```

Install the collector:

```
helm install otel-collector . -n observability
```

---

# Verify Collector Installation

Check pods:

```
kubectl get pods -n observability
```

Check OpenTelemetryCollector resource:

```
kubectl get opentelemetrycollector -A
```

Check instrumentation resources:

```
kubectl get instrumentation -A
```

---

# Delete OpenTelemetry Collector (If Installed Using Helm)

Check Helm releases:

```
helm list -n observability
```

Uninstall the collector:

```
helm uninstall otel-collector -n observability
```

Verify removal:

```
kubectl get pods -n observability
```

---

# Delete OpenTelemetry Collector (If Not Installed Using Helm)

If collector resources were applied manually:

Check collector resources:

```
kubectl get opentelemetrycollector -A
```

Delete collector resource:

```
kubectl delete opentelemetrycollector <collector-name> -n observability
```

Check instrumentation:

```
kubectl get instrumentation -A
```

Delete instrumentation if present:

```
kubectl delete instrumentation <instrumentation-name> -n <namespace>
```

Check secrets created for the collector:

```
kubectl get secrets -n observability
```

Delete if required:

```
kubectl delete secret <secret-name> -n observability
```

---

# Verification After Cleanup

Ensure all resources are removed.

Check namespaces:

```
kubectl get ns
```

Check OpenTelemetry resources:

```
kubectl get opentelemetrycollector -A
kubectl get instrumentation -A
```

Check CRDs:

```
kubectl get crds | grep opentelemetry
```

Check webhooks:

```
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
```

---




## 7. Tempo Setup (Tracing)

Tempo is used for distributed tracing.

### 7.1 Navigate to Tempo Directory

```bash
cd tempo
```

---

### 7.2 Update Helm Dependencies

```bash
helm dep update
```

---

### 7.3 Install Tempo

```bash
helm install tempo . -n observability -f values.yaml
```

---

### 7.4 Verify Tempo Deployment

**Check Pods**

```bash
kubectl get pod -n observability
```

**Check PVCs**

```bash
kubectl get pvc -n observability
```

**List Helm Releases**

```bash
helm list -n observability
```

---



# Delete Tempo (If Installed Using Helm)

### Step 1: Check Helm releases

```
helm list -n observability
```

Identify the Tempo release name (example: `tempo`).

---

### Step 2: Uninstall the Helm release

```
helm uninstall tempo -n observability
```

---

### Step 3: Verify resources are removed

```
kubectl get pods -n observability
```

Check services:

```
kubectl get svc -n observability
```

Check StatefulSets:

```
kubectl get statefulset -n observability
```

---

# Delete Tempo (If Not Installed Using Helm)

If Tempo was deployed manually using `kubectl apply`, delete the resources directly.

### Step 1: Check Tempo resources

```
kubectl get all -n observability | grep tempo
```

---

### Step 2: Delete deployments

```
kubectl delete deployment tempo-distributor -n observability
kubectl delete deployment tempo-querier -n observability
kubectl delete deployment tempo-query-frontend -n observability
kubectl delete deployment tempo-compactor -n observability
kubectl delete deployment tempo-gateway -n observability
kubectl delete deployment tempo-metrics-generator -n observability
```

---

### Step 3: Delete StatefulSets

```
kubectl delete statefulset tempo-ingester -n observability
kubectl delete statefulset tempo-memcached -n observability
```

---

### Step 4: Delete services

```
kubectl delete svc tempo-distributor -n observability
kubectl delete svc tempo-query-frontend -n observability
kubectl delete svc tempo-gateway -n observability
```

---

### Step 5: Delete PVCs (if created)

Tempo may create persistent volumes.

Check PVCs:

```
kubectl get pvc -n observability
```

Delete PVCs if required:

```
kubectl delete pvc --all -n observability
```

---

# Verification After Cleanup

Confirm that no Tempo resources remain.

Check pods:

```
kubectl get pods -n observability
```

Check services:

```
kubectl get svc -n observability
```

Check StatefulSets:

```
kubectl get statefulset -n observability
```

Check PVCs:

```
kubectl get pvc -n observability
```

---



# Install Faro Collector

Move to the Faro chart directory:

```
cd otel/faro
```

Update Helm dependencies (if defined in `Chart.yaml`):

```
helm dep update
```

Install Faro Collector:

```
helm install faro-collector . -n observability
```

---

# Verify Faro Installation

Check pods:

```
kubectl get pods -n observability | grep faro
```

Check services:

```
kubectl get svc -n observability
```

---

# Delete Faro Collector (If Installed Using Helm)

Check Helm releases:

```
helm list -n observability
```

Uninstall Faro Collector:

```
helm uninstall faro-collector -n observability
```

Verify deletion:

```
kubectl get pods -n observability
```

---

# Delete Faro Collector (If Not Installed Using Helm)

Check resources:

```
kubectl get all -n observability | grep faro
```

Delete deployment:

```
kubectl delete deployment faro-collector -n observability
```

Delete service:

```
kubectl delete svc faro-collector -n observability
```

Verify deletion:

```
kubectl get pods -n observability
```

---

# Install Kube Events Collector

Move to the chart directory:

```
cd otel/kube-events
```

Update Helm dependencies:

```
helm dep update
```

Install Kube Events Collector:

```
helm install kube-event-otel-collector . -n observability
```

---

# Verify Kube Events Collector

Check pods:

```
kubectl get pods -n observability | grep kube-event
```

Check services:

```
kubectl get svc -n observability
```

---

# Delete Kube Events Collector (If Installed Using Helm)

Check Helm releases:

```
helm list -n observability
```

Uninstall the release:

```
helm uninstall kube-event-otel-collector -n observability
```

Verify deletion:

```
kubectl get pods -n observability
```

---

# Delete Kube Events Collector (If Not Installed Using Helm)

Check resources:

```
kubectl get all -n observability | grep kube-event
```

Delete deployment:

```
kubectl delete deployment kube-event-otel-collector -n observability
```

Delete service:

```
kubectl delete svc kube-event-otel-collector -n observability
```

Verify deletion:

```
kubectl get pods -n observability
```

---




# Observability namespace Cleanup 


# Step 1: Check Existing Resources

Before deleting anything, check what is currently running in the namespace.

```
kubectl get pods -n observability
```

Check all resources:

```
kubectl get all -n observability
```

---

# Step 2: Delete the Observability Namespace

The easiest way to remove all namespace-scoped resources is to delete the namespace.

```
kubectl delete namespace observability
```

This will remove:

* Deployments
* StatefulSets
* Services
* ConfigMaps
* Secrets
* Pods
* Jobs
* PersistentVolumeClaims (PVCs)

---

# Step 3: Verify Namespace Deletion

Check whether the namespace has been deleted successfully.

```
kubectl get ns
```

If the namespace is stuck in **Terminating** state, check its status:

```
kubectl get ns observability -o yaml
```

---

# Step 4: Verify Remaining Cluster-Level Resources

Some observability components create **cluster-scoped resources** which are **not deleted automatically** when the namespace is removed.

These must be checked and removed manually.

---

# Step 5: Check OpenTelemetry Resources

Check OpenTelemetry related resources:

```
kubectl get opentelemetrycollector -A
kubectl get instrumentation -A
```

Delete them if they exist:

```
kubectl delete opentelemetrycollector --all -A
kubectl delete instrumentation --all -A
```

---

# Step 6: Check Webhook Configurations

OpenTelemetry operator and other components may create webhooks.

```
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
```

Delete related webhook configurations if they exist:

```
kubectl delete validatingwebhookconfiguration opentelemetry-operator
kubectl delete mutatingwebhookconfiguration opentelemetry-operator
```

---

# Step 7: Check CRDs (Custom Resource Definitions)

Some components install CRDs such as:

* OpenTelemetry
* Tempo
* VictoriaMetrics
* Alert rules

Check CRDs:

```
kubectl get crds | grep telemetry
kubectl get crds | grep tempo
kubectl get crds | grep victoria
kubectl get crds | grep alert
```

Delete unnecessary CRDs if they exist:

```
kubectl delete crd <crd-name>
```

Example:

```
kubectl delete crd opentelemetrycollectors.opentelemetry.io
kubectl delete crd instrumentations.opentelemetry.io
```

---

# Step 8: Check Cluster Roles

Some components create cluster roles.

```
kubectl get clusterrole | grep otel
kubectl get clusterrolebinding | grep otel
```

Delete if present:

```
kubectl delete clusterrole <role-name>
kubectl delete clusterrolebinding <binding-name>
```

---

# Step 9: Verify Cleanup

After deletion, verify that no observability components remain.

Check namespaces:

```
kubectl get ns
```

Check pods:

```
kubectl get pods -A
```

Check CRDs:

```
kubectl get crds
```

Check webhooks:

```
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
```

---

# Notes

* Deleting the namespace removes all **namespace-scoped resources automatically**.
* **Cluster-scoped resources must be removed manually**.
* Always verify CRDs, webhooks, and instrumentation resources before redeploying the observability stack.
* This ensures a **clean environment for fresh deployment**.



# Install Loki

Move to the Loki chart directory:

```
cd loki
```

Update Helm dependencies (if defined in `Chart.yaml`):

```
helm dep update
```

Install Loki using Helm:

```
helm install loki . -n logging
```

---

# Verify Loki Installation

Check pods:

```
kubectl get pods -n logging
```

Typical Loki components:

* loki-distributor
* loki-ingester
* loki-querier
* loki-query-frontend
* loki-index-gateway
* loki-compactor
* loki-results-cache
* loki-gateway

Check services:

```
kubectl get svc -n logging
```

---

# Upgrade Loki

If configuration changes are made in `values.yaml`:

```
helm upgrade loki . -n logging
```

---

# Delete Loki (If Installed Using Helm)

Check Helm releases:

```
helm list -n logging
```

Uninstall Loki:

```
helm uninstall loki -n logging
```

Verify deletion:

```
kubectl get pods -n logging
kubectl get svc -n logging
kubectl get statefulset -n logging
```

---

# Delete Loki (If Not Installed Using Helm)

If Loki was deployed manually using `kubectl apply`, delete the resources directly.

Check Loki resources:

```
kubectl get all -n logging | grep loki
```

Delete deployments:

```
kubectl delete deployment loki-distributor -n logging
kubectl delete deployment loki-querier -n logging
kubectl delete deployment loki-query-frontend -n logging
kubectl delete deployment loki-query-scheduler -n logging
```

Delete StatefulSets:

```
kubectl delete statefulset loki-ingester -n logging
kubectl delete statefulset loki-index-gateway -n logging
kubectl delete statefulset loki-compactor -n logging
kubectl delete statefulset loki-results-cache -n logging
```

Delete services:

```
kubectl delete svc loki-distributor -n logging
kubectl delete svc loki-query-frontend -n logging
kubectl delete svc loki-gateway -n logging
```

---

# Delete Persistent Storage

Loki may create persistent volumes.

Check PVCs:

```
kubectl get pvc -n logging
```

Delete PVCs if required:

```
kubectl delete pvc --all -n logging
```

---

# Verification After Cleanup

Confirm that no Loki resources remain.

Check pods:

```
kubectl get pods -n logging
```

Check services:

```
kubectl get svc -n logging
```

Check StatefulSets:

```
kubectl get statefulset -n logging
```

Check PVCs:

```
kubectl get pvc -n logging
```

---




# Logging namespace Cleanup 


 components in this namespace include:

* Loki
* FluentBit
* Loki Gateway
* Loki Distributor
* Loki Ingester
* Loki Querier
* Loki Query Frontend
* Loki Index Gateway
* Loki Results Cache
* Loki Compactor

---

# Step 1: Check Existing Resources

Before deleting anything, verify what resources are running in the logging namespace.

Check pods:

```
kubectl get pods -n logging
```

Check all resources:

```
kubectl get all -n logging
```

Check Helm releases (if deployed using Helm):

```
helm list -n logging
```

---

# Step 2: Delete the Logging Namespace

The simplest way to remove all namespace-scoped resources is to delete the namespace.

```
kubectl delete namespace logging
```

This command deletes:

* Pods
* Deployments
* StatefulSets
* Services
* ConfigMaps
* Secrets
* DaemonSets (FluentBit)
* PersistentVolumeClaims

---

# Step 3: Verify Namespace Deletion

Check if the namespace has been removed:

```
kubectl get ns
```

If the namespace remains in **Terminating** state, inspect it:

```
kubectl get ns logging -o yaml
```

---

# Step 4: Check Remaining Cluster-Level Resources

Deleting a namespace does **not remove cluster-scoped resources**. These must be verified manually.

---

# Step 5: Check CRDs

Some logging stacks create CRDs.

Check CRDs related to Loki:

```
kubectl get crds | grep loki
```

Delete CRDs if necessary:

```
kubectl delete crd <crd-name>
```

---

# Step 6: Check Cluster Roles

Logging stacks may create cluster roles and role bindings.

Check:

```
kubectl get clusterrole | grep loki
kubectl get clusterrolebinding | grep loki
```

Delete them if present:

```
kubectl delete clusterrole <role-name>
kubectl delete clusterrolebinding <binding-name>
```

---

# Step 7: Check Storage Resources

Loki often uses persistent volumes.

Check remaining PVCs:

```
kubectl get pvc -A
```

Check persistent volumes:

```
kubectl get pv
```

Delete leftover PVCs if required:

```
kubectl delete pvc --all -n logging
```

---

# Step 8: Verify Complete Cleanup

After deletion, confirm that no logging components remain.

Check namespaces:

```
kubectl get ns
```

Check pods across the cluster:

```
kubectl get pods -A
```

Check CRDs:

```
kubectl get crds
```

Check cluster roles:

```
kubectl get clusterrole
```

---

# Notes

* Deleting the namespace removes all **namespace-scoped resources automatically**.
* **Cluster-scoped resources must be removed manually**.
* Always verify CRDs, cluster roles, and persistent storage resources before redeploying the logging stack.
* This process ensures a **clean environment for a fresh logging setup**.
