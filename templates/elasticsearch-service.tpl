apiVersion: v1
kind: Service
metadata:
  name: pelias-elasticsearch-service
spec:
  ports:
    - name: "9200"
      port: 9200
      targetPort: 9200
    - name: "9300"
      port: 9300
      targetPort: 9300
  type: ClusterIP
  selector:
    app: pelias-elasticsearch
