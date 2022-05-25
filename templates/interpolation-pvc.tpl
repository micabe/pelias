{{- if .Values.interpolation.pvc.create }}
{{- if (or (.Values.interpolationEnabled) (.Values.interpolation.enabled))  }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.interpolation.pvc.name }}
  labels:
    {{- range $key, $value := .Values.pip.pvc.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  annotations:
    {{- range $key, $value := .Values.interpolation.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.interpolation.pvc.storageClass }}
  volumeMode: Filesystem
  accessModes:
    - {{ .Values.interpolation.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.interpolation.pvc.storage }}
{{- end -}}
{{- end -}}
