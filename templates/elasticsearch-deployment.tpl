apiVersion: apps/v1
kind: Deployment
metadata:
  name: pelias-elasticsearch
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pelias-elasticsearch
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: pelias-elasticsearch
    spec:
      securityContext:
        runAsUser: 1000
        fsGroup: 1000
      containers:
        - image: pelias/elasticsearch:7.16.1
          name: pelias-elasticsearch
          ports:
            - containerPort: 9200
            - containerPort: 9300
          resources: {}
          securityContext:
            capabilities:
              add:
                - IPC_LOCK
          volumeMounts:
            - mountPath: /usr/share/elasticsearch/data
              name: elasticsearch-pvc
            - mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
              subPath: elasticsearch.yml
              name: config-volume
      restartPolicy: Always
      volumes:
        - name: config-volume
          configMap:
            name: pelias-json-configmap
            items:
              - key: elasticsearch.yml
                path: elasticsearch.yml
        - name: elasticsearch-pvc
          {{- if .Values.elasticsearch.pvc.create }}
          persistentVolumeClaim:
            claimName: {{ .Values.elasticsearch.pvc.name }}
          {{- else }}
          emptyDir: {}
          {{- end }}
