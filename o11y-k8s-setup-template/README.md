# 📡 Observability Stack

This repository manages the complete Observability (O11y) setup for Kubernetes, combining metrics, logging, and tracing into a cohesive system for effective monitoring and troubleshooting.

---

## 📖 Introduction to Observability (O11y)

Observability is the ability to infer the internal state of a system by examining its external outputs—primarily **metrics**, **logs**, and **traces**. 

- **Metrics (Monitoring)**: Numeric representation of data measured over intervals of time.
  <!-- > _Tells us **what** is happening._ -->

- **Logs (Logging)**: Textual records of events at a point in time.
  <!-- > _Explains **why** it is happening._ -->

- **Traces (Tracing)**: Show the full journey of a request across services.
  <!-- > _Illustrates **how** it is happening._ -->

---

## 🧩 Tools Used

| Component        | Purpose                          | Chart Repo                                 		    | Version   |
|------------------|----------------------------------|-------------------------------------------------------------|-----------|
| VictoriaMetrics   | Metrics backend                  | https://github.com/VictoriaMetrics/helm-charts/tree/master 	           |   0.44.0  |
| Loki              | Log aggregation & querying       | https://github.com/grafana/loki/tree/helm-loki-6.30.0/production/helm/loki | 6.28.0    |
| Tempo             | Distributed tracing              | https://github.com/grafana/helm-charts/tree/tempo-distributed-1.41.0/charts/tempo-distributed      	            | 1.41.0    |
| Fluent Bit        | Log forwarder                    | https://github.com/fluent/helm-charts/tree/fluent-bit-0.48.0/charts/fluent-bit       		    | 0.48.0   |
| OpenTelemetry     | Standardized telemetry pipeline  | https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main | 1.0.0  |
| Grafana           | Unified observability dashboard  | https://github.com/grafana/helm-chartshelm-charts      		    |  8.15.0   |

---

## 🧠 Architecture Overview

```plaintext
[ App ] 
  ├─ Logs ──────▶ fluentbit ──────▶ Loki ─────▶ Grafana
  ├─ Metrics ───▶ Node Exporter ──────▶ VictoriaMetrics ─▶ Grafana
  │                        |                   |─▶alertmanager ─▶ Notification_Channel 
  |                        │                     
  ├─ Traces ────▶ OTEL Collector ─▶ Tempo ─▶ Grafana
                             └──▶ VictoriaMetrics ─▶ Grafana
                            └──▶ loki ─▶ Grafana
```

---



## VictoriaMetrics
To resolve the dependency

```sh
cd victoriametrics
helm dep update
```

To install a release

```sh
cd victoriametrics
helm install vm . -n monitoring -f values.yaml
```

To list the current releases
```sh
Helm list -n monitoring
```

To Upgrade/Modify victoraimetics cluster 
```
helm diff upgrade --install vm . -n monitoring -f values.yaml
helm upgrade --install vm . -n monitoring -f values.yaml
```
_Check Reference link to install helm diff plugin_ `helm diff` _will help to analyse the new changes_

To Delete Existing Helm
```bash
helm uninstall vm -n monitoring
```



## Grafana
### grafana-setup
To resolve the dependency

```sh
cd grafana/grafana_setup
helm dep update
```

To install a release

```sh
cd grafana/grafana_setup
helm install grafana . -n monitoring -f values.yaml
```

To list the current releases
```sh
Helm list -n monitoring
```

To Upgrade/Modify 
```
helm diff upgrade --install grafana . -n monitoring -f values.yaml
helm upgrade --install grafana . -n monitoring -f values.yaml
```

To Delete Existing Helm
```bash
helm uninstall grafana -n monitoring
```

### Datasource
To install a release

```sh
cd grafana/grafana_datasource
helm install datasource . -n monitoring -f values.yaml
```

To list the current releases
```sh
Helm list -n monitoring
```

To Upgrade/Modify  
```
helm diff upgrade --install datasource . -n monitoring -f values.yaml
helm upgrade --install datasource . -n monitoring -f values.yaml
```

To Delete Existing Helm
```bash
helm uninstall datasource -n monitoring
```
### Dashboard

To install a release

```sh
cd grafana/grafana_dashboard
helm install dashboard . -n monitoring -f values.yaml
```

To list the current releases
```sh
helm list -n monitoring
```

To Upgrade/Modify  
```
helm diff upgrade --install dashboard . -n monitoring -f values.yaml
helm upgrade --install dashboard . -n monitoring -f values.yaml
```

To Delete Existing Helm
```bash
helm uninstall dashboard  -n monitoring
```
## Opentelemetry Collector Operator

To resolve the dependency:

```sh
cd otel/operator
helm dep update
```

To install a release:

```sh
cd otel/operator
helm install otel-operator . -n observability -f values.yaml
```

To list the current releases:

```sh
helm list -n observability
```

To upgrade/modify OpenTelemetry Collector Operator:

```sh
helm diff upgrade --install otel-operator . -n observability -f values.yaml
helm upgrade --install otel-operator . -n observability -f values.yaml
```

To delete the existing Helm release:

```sh
helm uninstall otel-operator -n observability
```




## Opentelemetry collector 

To resolve the dependency:

```sh
cd otel/collectors
helm dep update
```

To install a release:

```sh
cd otel/collectors
helm install otel-collector . -n observability -f otel-exporter.yaml
```

To list the current releases:

```sh
helm list -n observability
```

To upgrade/modify OpenTelemetry Collector :

```sh
helm diff upgrade --install otel-collector . -n observability -f otel-exporter.yaml
helm upgrade --install otel-collector . -n observability -f otel-exporter.yaml
```

To delete the existing Helm release:

```sh
helm uninstall otel-collectorr -n observability
```


### 🪵 Loki

To resolve the dependency:

```sh
cd logging
helm dep update
```

To install a release:

```sh
cd logging
helm install loki . -n logging -f values.yaml
```

To list the current releases:

```sh
helm list -n logging
```

To upgrade/modify Loki:

```sh
helm diff upgrade --install loki . -n logging -f values.yaml
helm upgrade --install loki . -n logging -f values.yaml
```

To delete the existing Helm release:

```sh
helm uninstall loki -n logging
```

- Aggregates logs via `promtail`
- Adds metadata like namespace, pod, container name
- Loki runs in standalone mode and supports querying via Grafana
- Includes:
  - Chunks Cache: speeds up data storage
  - Results Cache: speeds up queries

---

### 🕰️ Tempo

To resolve the dependency:

```sh
cd tempo
helm dep update
```

To install a release:

```sh
cd tempo
helm install tempo . -n observability -f values.yaml
```

To list the current releases:

```sh
helm list -n observability
```

To upgrade/modify Tempo:

```sh
helm diff upgrade --install tempo . -n observability -f values.yaml
helm upgrade --install tempo . -n observability -f values.yaml
```

To delete the existing Helm release:

```sh
helm uninstall tempo -n observability
```

- Lightweight tracing backend
- Receives traces from instrumented apps via OTEL Collector
- Stores and serves trace data for Grafana UI

---



---
## ⏰Alerting 
### Alertmanager 
To setup alertmanager 
```sh
cd alertmanager/alertmanager_setup
helm dep update
```

To install a release:

```sh
cd alertmanager/alertmanager_setup
helm install alertmanager . -n monitoring -f values.yaml
```

To list the current releases:

```sh
helm list -n monitoring
```

To upgrade/modify alertmanager:

```sh
helm diff upgrade --install alertmanager . -n monitoring -f values.yaml
helm upgrade --install alertmanager . -n monitoring -f values.yaml
```

To delete the existing Helm release:

```sh
helm uninstall alertmanager -n monitoring
```
### Alerting-rules
To setup alerting-rules 


To install a release:

```sh
cd alertmanager/alerting_rules
helm install alerts . -n monitoring -f values.yaml
```

To list the current releases:

```sh
helm list -n monitoring
```

To upgrade/modify alerts:

```sh
helm diff upgrade --install alerts . -n monitoring -f values.yaml
helm upgrade --install alerts . -n monitoring -f values.yaml
```

To delete the existing Helm release:

```sh
helm uninstall alerts -n monitoring
```

## 📁 Folder Structure

```bash
.
├── grafana               # Dashboards & datasources
├── logging               # Fluent Bit & Loki
├── otel                  # OpenTelemetry collector & operator
├── tempo                 # Tracing backend
├── victoriametrics       # Metrics backend
└── alerting              # Alerts and alertmanager_configuration
```

---

## 🚀 Usage Guide

### ✅ Always Use Helm Diff Before Deploying

```bash
helm diff upgrade <release-name> <chart-path> -f values.yaml
```

### 🔼 Upgrade with Helm

```bash
helm upgrade --install <release-name> <chart-path> -f values.yaml
```

### ➕ Adding a New Feature

1. Modify `values.yaml` or template files.
2. Run `helm diff` to see changes.
3. If valid, apply using `helm upgrade`.

### 📜 How to View Changelogs

1. Note chart version from `Chart.lock` or `Chart.yaml`.
2. Visit [ArtifactHub](https://artifacthub.io/) or chart's GitHub repo.
3. Search for chart and review release notes.


## 📬 Contribution

- Make changes in a feature branch.
- Test with `helm diff` before committing.
- Submit a PR with a clear description.

---

## 🔗 References

- [Helm Diff Plugin](https://github.com/databus23/helm-diff)
- [Grafana Helm Charts](https://github.com/grafana/helm-charts)
- [VictoriaMetrics Helm Charts](https://github.com/VictoriaMetrics/helm-charts)
- [OpenTelemetry Helm Charts](https://github.com/open-telemetry/opentelemetry-helm-charts)

---
