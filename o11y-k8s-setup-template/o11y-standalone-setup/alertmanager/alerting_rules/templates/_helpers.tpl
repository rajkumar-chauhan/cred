{{/*
Escape Prometheus Go template syntax from Helm by wrapping in raw string syntax.
*/}}
{{- define "alerting-rules.alertmanagerAnnotation" -}}
{{- printf "{{`%s`}}" . -}}
{{- end -}}
