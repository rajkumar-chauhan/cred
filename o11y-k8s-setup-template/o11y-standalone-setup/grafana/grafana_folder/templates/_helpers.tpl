{{/*
Return the name of the chart
*/}}
{{- define "grafana-folders.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Return the chart name and version
*/}}
{{- define "grafana-folders.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

