{{/*
Return the chart name.
*/}}
{{- define "kanboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the fully qualified application name.
*/}}
{{- define "kanboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return the chart name and chart version.
*/}}
{{- define "kanboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common Kanboard labels.
*/}}
{{- define "kanboard.labels" -}}
helm.sh/chart: {{ include "kanboard.chart" . }}
{{ include "kanboard.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Kanboard selector labels.
These labels must remain stable because the Deployment
and Service use them to find the application Pods.
*/}}
{{- define "kanboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kanboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: web
{{- end }}

{{/*
Kanboard application data PVC name.
*/}}
{{- define "kanboard.dataPvcName" -}}
{{- printf "%s-data" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Kanboard plugins PVC name.
*/}}
{{- define "kanboard.pluginsPvcName" -}}
{{- printf "%s-plugins" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PostgreSQL StatefulSet and client Service name.
*/}}
{{- define "kanboard.postgresName" -}}
{{- printf "%s-postgres" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PostgreSQL headless Service name.
*/}}
{{- define "kanboard.postgresHeadlessName" -}}
{{- printf "%s-postgres-headless" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Stable PostgreSQL selector labels.
*/}}
{{- define "kanboard.postgresSelectorLabels" -}}
app.kubernetes.io/name: {{ include "kanboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
{{- end }}

{{/*
Common PostgreSQL labels.
*/}}
{{- define "kanboard.postgresLabels" -}}
helm.sh/chart: {{ include "kanboard.chart" . }}
{{ include "kanboard.postgresSelectorLabels" . }}
app.kubernetes.io/version: {{ .Values.postgres.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
