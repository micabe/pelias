apiVersion: apps/v1
kind: Deployment
metadata:
  name: pelias-elasticsearch
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: elasticsearch
  strategy:
    type: Recreate
  template:
    metadata:
      annotations:
        kompose.cmd: kompose convert -f docker-compose.yml
        kompose.version: 1.22.0 (955b78124)
      creationTimestamp: null
      labels:
        io.kompose.network: "true"
        io.kompose.service: elasticsearch
    spec:
      # EFS is mounted as root only so it needs to be chowned.
      initContainers:
        - name: efs-bootstrap
          image: busybox:latest
          command: ["/bin/chown"]
          args: ["-c", "1000:1000", "/usr/share/elasticsearch/data"]
          volumeMounts:
            - mountPath: /usr/share/elasticsearch/data
              name: elasticsearch-claim0
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
              name: elasticsearch-claim0
      restartPolicy: Always
      volumes:
        - name: elasticsearch-claim0
          persistentVolumeClaim:
            claimName: elasticsearch-claim0
status: {}
