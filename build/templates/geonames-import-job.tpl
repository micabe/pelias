apiVersion: batch/v1
kind: Job
metadata:
  name: geonames-import
spec:
  template:
    metadata:
      name: geonames-import-pod
    spec:
      initContainers:
        - name: setup
          image: 599239948849.dkr.ecr.ap-southeast-2.amazonaws.com/busybox:latest
          command: ["/bin/sh","-c"]
          # args: ["mkdir -p /data/geonames && chown 1000:1000 /data/geonames"]
          args: ["mkdir -p /data/geonames"]
          volumeMounts:
          - name: data-volume
            mountPath: /data
        - name: download
          image: 599239948849.dkr.ecr.ap-southeast-2.amazonaws.com/pelias/geonames:{{ .Values.geonamesDockerTag | default "latest" }}
          command: ["./bin/download"]
          volumeMounts:
          - name: config-volume
            mountPath: /etc/config
          - name: data-volume
            mountPath: /data
          env:
          - name: PELIAS_CONFIG
            value: "/etc/config/pelias.json"
          resources:
            limits:
              memory: 512Mi
              cpu: 1
            requests:
              memory: 512Mi
              cpu: 1
      containers:
      - name: geonames-import-container
        image: 599239948849.dkr.ecr.ap-southeast-2.amazonaws.com/pelias/geonames:{{ .Values.geonamesDockerTag | default "latest" }}
        command: ["./bin/start"]
        volumeMounts:
          - name: config-volume
            mountPath: /etc/config
          - name: data-volume
            mountPath: /data
        env:
          - name: PELIAS_CONFIG
            value: "/etc/config/pelias.json"
        resources:
          limits:
            memory: 3Gi
            cpu: 2
          requests:
            memory: 512Mi
            cpu: 1
      restartPolicy: OnFailure
      volumes:
      - name: config-volume
        configMap:
          name: pelias-json-configmap
          items:
          - key: pelias.json
            path: pelias.json
      - name: data-volume
        persistentVolumeClaim:
          claimName: pelias-build-pvc
