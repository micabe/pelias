{{- if (and .Values.dashboard.ingress.hostname .Values.dashboard.ingress.enabled) }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pelias-dashboard-ingress
  annotations:
  {{- range $key, $value := .Values.dashboard.ingress.annotations }}
    {{ $key }}: {{ $value | quote }}
  {{- end }}
spec:
  rules:
    - host: {{ .Values.dashboard.ingress.hostname }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: pelias-dashboard-service
                port:
                  number: 3030
{{- end -}}