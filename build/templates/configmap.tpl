apiVersion: v1
kind: ConfigMap
metadata:
  name: pelias-api-calls
data:
  extract.sh: |
    #!/bin/sh

    cd /tmp

    # Should be /tmp/snap/indices
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

    RES=$(curl -XGET 'http://pelias-elasticsearch-service:9200/_snapshot/snap/_all')
    echo ${RES}

    GETURL="http://pelias-elasticsearch-service:9200/_snapshot/snap/myindexsnapshot"

    curl -XPOST "$GETURL/_restore?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d"{ \"indices\" : \"pelias\", \"ignore_unavailable\": \"true\", \"include_global_state\": \"false\" }"
    EXIT=1
    while [ $EXIT -eq 1 ]; do
        echo "Restoring snapshot.."
        sleep 5s
        EXIT=$(curl -XGET "$GETURL/_status" | grep -c "IN_PROGRESS")
    done

