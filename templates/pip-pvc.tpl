{{- if .Values.pip.pvc.create }}
{{- if (or (.Values.pipEnabled) (.Values.pip.enabled)) }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.pip.pvc.name }}
  labels:
    {{- range $key, $value := .Values.pip.pvc.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  annotations:
    {{- range $key, $value := .Values.pip.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.pip.pvc.storageClass }}
  volumeMode: Filesystem
  accessModes:
    - {{ .Values.pip.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.pip.pvc.storage }}
{{- end -}}
{{- end -}}
