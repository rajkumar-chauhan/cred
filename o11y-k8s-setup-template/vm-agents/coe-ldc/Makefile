CHART_NAME  := vm
VALUES_FILE := values.yaml
CHART_PATH  := .
NAMESPACE   := monitoring

.PHONY: all dep upgrade

all: dep upgrade

dep:
	helm dep update $(CHART_PATH)

diff-:
	#helm diff upgrade --install $(CHART_NAME) $(CHART_PATH) -f $(VALUES_FILE) -n $(NAMESPACE) --create-namespace --set prometheus-operator-crds.enabled=true --set vm.vmagent.spec.extraArgs."remoteWrite\.label"='cluster=coe-ldc,env=dev,dc=ashwathama'

upgrade:
	helm template --name-template=vm . -f values.yaml -n monitoring | kubectl apply -f - --server-side=true --force-conflicts
