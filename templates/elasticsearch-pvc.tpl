{{- if .Values.elasticsearch.pvc.create }}
{{- if .Values.elasticsearch.enabled }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.elasticsearch.pvc.name }}
  annotations:
    {{- range $key, $value := .Values.elasticsearch.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.elasticsearch.pvc.storageClass }}
  accessModes:
    - {{ .Values.elasticsearch.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.elasticsearch.pvc.storage }}
{{- end -}}
{{- end -}}