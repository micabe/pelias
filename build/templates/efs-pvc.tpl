kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.efs.pvc.name }}
  annotations:
    {{- range $key, $value := .Values.efs.pvc.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  storageClassName: {{ .Values.efs.pvc.storageClass }}
  volumeMode: Filesystem
  accessModes:
    - {{ .Values.efs.pvc.accessModes }}
  resources:
    requests:
      storage: {{ .Values.efs.pvc.storage }}
