CHART_NAME  := grafana
VALUES_FILE := values.yaml
CHART_PATH  := .
NAMESPACE   := monitoring

.PHONY: all deps upgrade

all: deps upgrade

deps:
	helm dep update $(CHART_PATH)

diff:
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE)

upgrade:
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE)


# create secrets 
# kubectl create secret generic grafana-azure-ad-creds \
# --from-literal=client-id="<YOUR_AZURE_AD_CLIENT_ID>" \
# --from-literal=client-secret="<YOUR_AZURE_AD_CLIENT_SECRET>" \
# --from-literal=tenant-id="<YOUR_AZURE_AD_TENANT_ID>" \
# -n <your-namespace>