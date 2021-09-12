apiVersion: v1
kind: Service
metadata:
    name: pelias-api-service
spec:
    selector:
        app-group: pelias-api
    ports:
        - protocol: TCP
          port: 3100
    type: {{- if .Values.api.serviceType  }} {{ .Values.api.serviceType }} {{ else }} ClusterIP {{ end }}
