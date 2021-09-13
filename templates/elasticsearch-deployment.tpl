apiVersion: apps/v1
kind: Deployment
metadata:
  name: pelias-elasticsearch
spec:
  replicas: 1
  selector:
    matchLabels:
      app: elasticsearch
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      # EFS is mounted as root only so it needs to be chowned.
      initContainers:
        - name: efs-bootstrap
          image: busybox:latest
          command: ["/bin/chown"]
          args: ["-c", "1000:1000", "/usr/share/elasticsearch/data"]
          volumeMounts:
            - mountPath: /usr/share/elasticsearch/data
              name: elasticsearch-pvc
      containers:
        - image: pelias/elasticsearch:7.5.1
          name: pelias-elasticsearch
          securityContext:
            runAsUser: 1000
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
      restartPolicy: Always
      volumes:
        - name: elasticsearch-pvc
          {{- if .Values.elasticsearch.pvc.create }}
          persistentVolumeClaim:
            claimName: {{ .Values.elasticsearch.pvc.name }}
          {{- else }}
          emptyDir: {}
          {{- end }}
status: {}
