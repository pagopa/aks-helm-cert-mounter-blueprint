{{/*
Expand the name of the chart.
*/}}
{{- define "cert-mounter-blueprint.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cert-mounter-blueprint.fullname" -}}
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
Progressive Delivery
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cert-mounter-blueprint.fullnameCanaryDelivery" -}}
beta-{{ include "cert-mounter-blueprint.fullname" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cert-mounter-blueprint.chart" -}}
{{- printf "%s-%s" .Chart.Name (.Values.image.tag | default .Chart.Version) | replace "@sha256:" "_" | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cert-mounter-blueprint.labels" -}}
helm.sh/chart: {{ include "cert-mounter-blueprint.chart" . }}
{{ include "cert-mounter-blueprint.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Progressive Delivery Common labels
*/}}
{{- define "cert-mounter-blueprint.labelsCanaryDelivery" -}}
helm.sh/chart: {{ include "cert-mounter-blueprint.chart" . }}
{{ include "cert-mounter-blueprint.selectorLabelsCanaryDelivery" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cert-mounter-blueprint.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-mounter-blueprint.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
canaryDelivery: "false"
{{- end }}

{{/*
Progressive Delivery Selector labels
*/}}
{{- define "cert-mounter-blueprint.selectorLabelsCanaryDelivery" -}}
app.kubernetes.io/name: {{ include "cert-mounter-blueprint.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
canaryDelivery: "true"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cert-mounter-blueprint.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cert-mounter-blueprint.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Extra labels
*/}}
{{- define "cert-mounter-blueprint.extraLabels" -}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ (.Values.image.tag | default .Chart.AppVersion) | replace "@sha256:" "_" | trunc 63 | quote }}
{{- end }}
{{- if .Values.azure.workloadIdentityEnabled }}
azure.workload.identity/use: "{{ .Values.azure.workloadIdentityEnabled }}"
{{- end }}
{{- end }}
