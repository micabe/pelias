{{- if (and .Values.api.ingress.hostname .Values.api.ingress.enabled) }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pelias-api-ingress
  annotations:
  {{- range $key, $value := .Values.api.ingress.annotations }}
    {{ $key }}: {{ $value | quote }}
  {{- end }}
spec:
  rules:
    - host: {{ .Values.api.ingress.hostname }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: pelias-api-service
                port:
                  number: 3100
{{- end -}}