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
## Restore a snapshot

Start by copying the snapshot inside the elasticsearch pod

```
kubectl cp elasticsearch-snapshot.tar.gz <namespace>/<pod-id>:/usr/share/elasticsearch/data
```

Then extract and restore indices into elasticsearch:

```
helm install pelias-build --namespace pelias ./build --values values.yaml
```

## Test Pelias API

- http://localhost:3100/v1/reverse?point.lon=18.063240&point.lat=59.334591
- http://localhost:3100/v1/autocomplete?text=stock
- http://localhost:3100/v1/search?text=stockholm

Make sure the results match with the ones in /curl/results