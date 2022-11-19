apiVersion: batch/v1
kind: Job
metadata:
  name: restore-snapshot
spec:
  template:
    metadata:
      name: restore-snapshot-pod
    spec:
      initContainers:
        - name: extract
          image: everpeace/curl-jq
          command: ["/chapsvision/extract.sh"]
          volumeMounts:
            - name: elasticsearch-pvc
              mountPath: /tmp
            - name: restore-snap
              mountPath: /chapsvision
          resources:
            limits:
              memory: 512Mi
            requests:
              memory: 512Mi
      containers:
      - name: restore-snapshot-container
        image: everpeace/curl-jq
        command: ["/chapsvision/restore.sh"]
        volumeMounts:
          - name: restore-snap
            mountPath: /chapsvision
        resources:
          limits:
            memory: 3Gi
          requests:
            memory: 512Mi
      restartPolicy: OnFailure
      volumes:
      - name: restore-snap
        configMap:
          name: pelias-api-calls
          defaultMode: 0755
      - name: elasticsearch-pvc
        {{- if .Values.elasticsearch.pvc.create }}
        persistentVolumeClaim:
          claimName: {{ .Values.elasticsearch.pvc.name }}
        {{- else }}
        emptyDir: {}
        {{- end }}
