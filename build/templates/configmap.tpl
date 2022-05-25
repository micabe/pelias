apiVersion: v1
kind: ConfigMap
metadata:
  name: pelias-api-calls
data:
  extract.sh: |
    #!/bin/sh

    cd /tmp

    tar -zxvf elasticsearch-snapshot.tar.gz

    curl -XPUT 'http://pelias-elasticsearch-service:9200/_snapshot/snap' -H 'Content-Type: application/json' -d '{
        "type": "fs",
        "settings": {
          "location": "snap",
          "compress": true
      }
    }'

  restore.sh: |
    #!/bin/bash




    GETURL="http://pelias-elasticsearch-service:9200/_cat/indices"

    while true; 
      do 
        RES=$(curl -XGET $GETURL);
        echo ${RES}
        sleep 10;
      done

