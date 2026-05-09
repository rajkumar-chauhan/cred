CHART_NAME  := vm
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
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE) --create-namespace

vmagent-bp:
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f vmagent-values.yaml -n $(NAMESPACE) --create-namespace --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=bp,env=prod'

diff-vmagent-bp:
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f vmagent-values.yaml -n $(NAMESPACE) --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=bp,env=prod'