{{- if .Values.placeholder.pvc.create }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.placeholder.pvc.name }}
  labels:
    {{- range $key, $value := .Values.pip.pvc.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  annotations:
    {{- range $key, $value := .Values.placeholder.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.placeholder.pvc.storageClass }}
  volumeMode: Filesystem
  accessModes:
    - {{ .Values.placeholder.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.placeholder.pvc.storage }}
{{- end -}}
