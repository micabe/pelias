apiVersion: batch/v1
kind: Job
metadata:
  name: openstreetmap-import
spec:
  template:
    metadata:
      name: openstreetmap-import
    spec:
      securityContext:
        runAsUser: 1000
        fsGroup: 1000
      initContainers:
      - name: setup
        image: busybox:latest
        command: ["/bin/sh","-c"]
        # args: ["mkdir -p /data/openstreetmap && chown 1000:1000 /data/openstreetmap"]
        args: ["mkdir -p /data/openstreetmap"]
        volumeMounts:
        - name: data-volume
          mountPath: /data
      - name: download
        image: pelias/openstreetmap:{{ .Values.openstreetmapDockerTag | default "latest"}}
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
            memory: 1Gi
          requests:
            memory: 256Mi
      containers:
      - name: openstreetmap-import-container
        image: pelias/openstreetmap:{{ .Values.openstreetmapDockerTag | default "latest"}}
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
            memory: 8Gi
          requests:
            memory: 4Gi
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
            claimName: {{ .Values.efs.pvc.name }}
