{{- if .Values.elasticsearch.pvc.create }}
{{- if .Values.elasticsearch.enabled }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.elasticsearch.pvc.name }}
  labels:
    {{- range $key, $value := .Values.pip.pvc.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  annotations:
    {{- range $key, $value := .Values.elasticsearch.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.elasticsearch.pvc.storageClass }}
  volumeMode: Filesystem
  accessModes:
    - {{ .Values.elasticsearch.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.elasticsearch.pvc.storage }}
{{- end -}}
{{- end -}}