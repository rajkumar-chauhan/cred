CHART_NAME  := clickhouse
VALUES_FILE := values.yaml
CHART_PATH  := .
NAMESPACE   := clickhouse

.PHONY: all deps upgrade diff create-namespace

all: deps upgrade

create-namespace:
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

deps:
	helm dependency update $(CHART_PATH)

diff: create-namespace
	ADMIN_PASSWORD=$$(kubectl get secret --namespace $(NAMESPACE) $(CHART_NAME) -o jsonpath="{.data.admin-password}" | base64 -d); \
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) \
		-f $(VALUES_FILE) -n $(NAMESPACE) \
		--set adminPassword=$$ADMIN_PASSWORD

upgrade: create-namespace
	ADMIN_PASSWORD=$$(kubectl get secret --namespace $(NAMESPACE) $(CHART_NAME) -o jsonpath="{.data.admin-password}" | base64 -d); \
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) \
		-f $(VALUES_FILE) -n $(NAMESPACE) \
		--set adminPassword=$$ADMIN_PASSWORD
