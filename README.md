# Pelias on Kubernetes

## Importers

Each importer has different memory requirements. Note that they all require the PIP service (6GB+ RAM) to be running first.

- Who's on First (requires about 1GB of RAM)
- OpenStreetMap (requires between 0.25GB and 6GB of RAM depending on import size)
- OpenAddresses (requires 1GB of RAM)
- Geonames (requires ~0.5GB of RAM)
- Polylines (requires 1GB of RAM)

Use the [data sources](https://github.com/pelias/documentation/blob/master/data-sources.md) documentation to decide
which importers to be run.

Importers can be run in any order, in parallel or one at a time.

## Running the charts

Start by running all the services

```
helm install pelias --namespace pelias . --values values.yaml
```

Then download and import indices into elasticsearch

```
helm install pelias-build --namespace pelias ./build --values values.yaml
```

## Test API

- http://localhost:3100/v1/reverse?point.lon=18.063240&point.lat=59.334591
- http://localhost:3100/v1/autocomplete?text=stock
- http://localhost:3100/v1/search?text=stockholm

## Restore a snapshot

Now everything should be set up so we can begin to restore our snapshot from the repository. We can list the snapshots in the repository with:

GET /\_snapshot/snap/\_all

Elasticsearch snapshot restore
Let’s now restore one of the repositories that we just listed:

POST /\_snapshot/snap/myindexsnapshot/\_restore
We can monitor the progress of restoring a snapshot in Kibana with:

GET /\_snapshot/snap/myindexsnapshot
Restoring snapshot in Elasticsearch

Great! As the response in Kibana suggests, our restore process was successful. You can check that the snapshot indexes are now on the cluster2 by typing:

GET \_cat/indices?pretty
