{{- define "url-shortener.name" -}}
url-shortener
{{- end -}}

{{- define "url-shortener.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "url-shortener.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "url-shortener.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
{{- .Values.serviceAccount.name -}}
{{- else -}}
{{ include "url-shortener.fullname" . }}
{{- end -}}
{{- end -}}
