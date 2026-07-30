{{/*
Return the chart name.
*/}}
{{- define "kanboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the fully qualified application name.

Examples:
Release name: production
Chart name: kanboard

Result:
production-kanboard
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
Common labels included on all Kanboard resources.
*/}}
{{- define "kanboard.labels" -}}
helm.sh/chart: {{ include "kanboard.chart" . }}
{{ include "kanboard.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Stable labels used by the Service and Deployment selector.
*/}}
{{- define "kanboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kanboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Name of the Kanboard application data PVC.
*/}}
{{- define "kanboard.dataPvcName" -}}
{{- printf "%s-data" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of the Kanboard plugins PVC.
*/}}
{{- define "kanboard.pluginsPvcName" -}}
{{- printf "%s-plugins" (include "kanboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
