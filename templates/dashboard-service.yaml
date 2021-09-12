{{- if .Values.dashboard.enabled }}
apiVersion: v1
kind: Service
metadata:
    name: pelias-dashboard-service
spec:
    selector:
        app: pelias-dashboard
    ports:
        - protocol: TCP
          port: 3030
    type: {{- if .Values.dashboard.serviceType  }} {{ .Values.dashboard.serviceType }} {{ else }} ClusterIP {{ end }}
{{- end -}}
