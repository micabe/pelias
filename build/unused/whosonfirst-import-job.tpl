apiVersion: batch/v1
kind: Job
metadata:
  name: whosonfirst-import
spec:
  template:
    metadata:
      name: whosonfirst-import
    spec:
      securityContext:
        runAsUser: 1000
        fsGroup: 1000
      initContainers:
      - name: setup
        image: busybox:latest
        command: ["/bin/sh","-c"]
        # args: ["mkdir -p /data/whosonfirst && chown 1000:1000 /data/whosonfirst"]
        args: ["mkdir -p /data/whosonfirst"]
        volumeMounts:
          - name: data-volume
            mountPath: /data
      - name: download
        image: pelias/whosonfirst:{{ .Values.whosonfirstDockerTag | default "latest" }}
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
            memory: 3Gi
          requests:
            memory: 512Mi
      containers:
      - name: whosonfirst-import-container
        image: pelias/whosonfirst:{{ .Values.whosonfirstDockerTag | default "latest" }}
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
          requests:
            memory: 2Gi
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
