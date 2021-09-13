apiVersion: apps/v1
kind: Deployment
metadata:
  name: pelias-libpostal
spec:
  replicas: {{ .Values.libpostal.replicas }}
  minReadySeconds: {{ .Values.libpostal.minReadySeconds }}
  selector:
    matchLabels:
      app: pelias-libpostal
  strategy:
    rollingUpdate:
      maxSurge: {{ .Values.libpostal.maxSurge }}
      maxUnavailable: {{ .Values.libpostal.maxUnavailable }}
  template:
    metadata:
      labels:
        app: pelias-libpostal
      annotations:
{{- if .Values.libpostal.annotations }}
{{ toYaml .Values.libpostal.annotations | indent 8 }}
{{- end }}
    spec:
      containers:
        - name: pelias-libpostal
          image: 599239948849.dkr.ecr.ap-southeast-2.amazonaws.com/pelias/libpostal-service:{{ .Values.libpostal.dockerTag }}
          resources:
            limits:
              memory: 3Gi
              cpu: 1.5
            requests:
              memory: 2Gi
              cpu: 0.1
          livenessProbe:
            httpGet:
              path: /parse?address=readiness
              port: 4400
          readinessProbe:
            httpGet:
              path: /parse?address=readiness
              port: 4400
      nodeSelector:
{{ toYaml .Values.libpostal.nodeSelector | indent 8 }}
