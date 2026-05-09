CHART_NAME  := otel-demo-postgres
VALUES_FILE := values.yaml
CHART_PATH  := .
NAMESPACE   := otel-demo

.PHONY: all deps upgrade

all: deps upgrade

deps:
	helm dep update $(CHART_PATH)

diff:
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE)

upgrade:
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE)