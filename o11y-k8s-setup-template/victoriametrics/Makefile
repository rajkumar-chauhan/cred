CHART_NAME  := vm
VALUES_FILE := values.yaml
CHART_PATH  := .
NAMESPACE   := monitoring

.PHONY: all deps upgrade

all: deps upgrade

deps:
	helm dep update $(CHART_PATH)

diff-vmagent-ldc:
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE) --create-namespace --set prometheus-operator-crds.enabled=true --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=coe-ldc,env=dev,dc=ashwathama'

upgrade-vmagent-ldc:
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE) --create-namespace --set prometheus-operator-crds.enabled=true --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=coe-ldc,env=dev,dc=ashwathama'

upgrade-vmagent-bp:
	helm upgrade --install $(CHART_NAME) $(CHART_PATH) -f vmagent-values.yaml -n $(NAMESPACE) --create-namespace --set prometheus-operator-crds.enabled=false --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=buildpiper,env=prod'

diff-vmagent-bp:
	helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f vmagent-values.yaml -n $(NAMESPACE) --set prometheus-operator-crds.enabled=false --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=buildpiper,env=prod'
