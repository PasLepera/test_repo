# Drupal Helm Chart

* Installs the [Drupal](https://www.drupal.org/) and [Nginx](https://www.nginx.com/resources/wiki/)


## TL;DR;

```console
$ helm install .
```

## Installing the Chart

To install the chart with the release name `my-release` and the `namespace`:

```console
$ helm install . --name my-release --namespace my-namespace
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration


| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `nameOverride`             | Override the resource name prefix | `drupal` |
| `fullnameOverride`         | Override the full resource names  | `drupal-{release-name} (or drupal if release-name is drupal)`|
| `containers.*.name`        | Container name in pod | `default nginx=nginx, drupal=drupal` |
| `containers.*.image.repository`        | Image repository | `default nginx=848353684207.dkr.ecr.eu-west-1.amazonaws.com/ibc/drupal-nginx, drupal=848353684207.dkr.ecr.eu-west-1.amazonaws.com/ibc/drupal` |
| `containers.*.image.tag`   | Image tag | `default nginx=latest, drupal=latest` |
| `containers.*.image.pullPolicy`   | Image pull policy | `default nginx=Always, drupal=Always` |
| `containers.*.image.containerPort`   | Container port | `default nginx=80, drupal=9000` |
| `containers.*.image.resources`   | Container CPU/Memory resource requests/limits | `nginx = rCPU: 100m, rmem: 128Mi, lcpu: 160m, lmem:160Mi, drupal = rCPU: 500m, rmem: 512Mi, lcpu: 750m, lmem:576Mi ` |
| `containers.*.image.env`   | Image tag | `default nginx={}, drupal={}` |
| `service.type`             | Kubernetes service type | `ClusterIP` |
| `service.port`             | Kubernetes port where service is exposed| `8090` |
| `service.labels`           | Service annotations | `{}` |
| `service.annotations`      | Service annotations | `{}` |
| `service.loadBalancerIP`   | An available static IP you have reserved on your cloud platform | `None` |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) platform | `None` |
| `service.clusterIP`        | IP address to assign to service | `None` |
| `service.externalIPs`      | Service external IP addresses | `[]` |
| `service.nodePort`         | For service type "NodePort"         | `None` |
| `ingress.enabled`          | Enables Ingress | `false` |
| `ingress.labels`           | Ingress labels | `{}` |
| `ingress.annotations`      | Ingress annotations | `{}` |
| `ingress.hosts`            | Ingress accepted hostnames | `[]` |
| `ingress.tls`              | Ingress TLS configuration | `[]` |
| `ingress.ssl`              | App behind LB is on https | `false` |
| `replicas`                 | Number of pods | `None` |
| `strategy`                 | Deployment strategy | `Recreate` |
| `restartPolicy`            | Pod restart policy | `None` |
| `minReadySeconds`          | Pods should be ready without crashing | `None` |
| `progressDeadlineSeconds`  | Wait for Pods before failure | `None` |
| `revisionHistoryLimit`     | Number of old ReplicaSets to retain | `None` |
| `labels`                   | Deployment labels | `None` |
| `annotations`              | Deployment annotations | `None` |
| `podLabels`                | Pod labels | `None` |
| `podAnnotations`           | Pod annotations | `None` |
| `nodeSelector`             | Node labels for pod assignment | `{}` |
| `tolerations`              | Toleration labels for pod assignment | `[]` |
| `affinity`                 | Affinity settings for pod assignment | `{}` |
| `persistentVolume.enabled`      | Use persistent volume to store data | `false` |
| `persistentVolume.size`         | Size of persistent volume claim | `2Gi` |
| `persistentVolume.existingClaim`| Use an existing PVC to persist data | `nil` |
| `persistentVolume.storageClass` | Type of persistent volume claim | `generic` |
| `persistentVolume.accessModes`  | persistentVolume access modes | `[]` |
| `persistentVolume.mountPath`  | Persistent Volume mount root path | `/var/www/html/persistent_volume` |