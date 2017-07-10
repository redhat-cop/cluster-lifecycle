# An Approach to OpenShift Cluster Lifecycle Management

## Declarative Structure

The following is a proposed structure for declaring the various parts of cluster state:

```
policy/ - yml files defining clusterroles, clusterrolebindings, rolebindings, storage classes, resourcequotas
namespaces/ - yml files defining desired namespaces in a cluster
namespace-templates/ - helper templates for generating namespace configs
deploy/ - yml files defining deployments, deploymentConfigs, services, routes, configmaps, secrets, daemonsets, persistentvolumeclaims
builds/ - yml files defining imagestreams, buildConfigs
```

## Scripts

The following scripts are provided to support cluster population and are found in the [bin](bin) directory

### oc-applier.sh

The applier script will apply the various resource types contained in this repo.

Usage for the script looks something like:

```
./bin/oc-applier.sh --action=policy|namespaces|build|deploy
```

You can also apply all types with one command:

```
./bin/oc-applier.sh --all
```

## How We Handle Object Types

### Cluster Policy

The cluster policy objects are stored in `./policy` and are made up of:

* ClusterRoles
* ClusterRoleBindings
* StorageClasses
* PersistentVolumes

These resources are applied as an entire directory via

```
oc apply -f ./policy
```

However, because there are some interdependencies between roles and rolebindings, they may not all apply successfully the first time. Therefore, a retry loop may be required to get all objects applied successfully. See `./bin/oc-applier.sh` for an example.

### Namespaces & Quotas

A new namespace config should be generated from a template to ensure consistency. A Default template is provided as a starter. A process to add a new namespace to a repo would look like:

```
oc process -f namespace-templates/default.yml \
  -p PROJECT_NAME=myapp-dev \
  -p PROJECT_DISPLAYNAME="MyApp Development Environment" \
  -p PROJECT_ADMIN_USER=bob \
  -p PROJECT_REQUESTING_USER=alice \
  > namespaces/myapp-dev.yml
```

A new file the defines your namespace is now added to the `namespaces` directory. From there, we can then re-apply the namespace changes to the desired cluster with:

```
oc apply -f namespaces/
```

### Build Artifacts

Build artifacts include `Builds` and `ImageStreams` defined in templates. They are arranged by app & namespace, as such.

```
./builds
./builds/<app-name>
./builds/<app-name>/<app-name>-template.yml
./builds/<app-name>/<namespace>
./builds/<app-name>/<namespace>/params
```

And applied with

```
oc process -f build/<app-name>/<app-name>-template.yml --param-file=build/<app-name>/<namespace>/params | oc apply -f -
```

### Deploy Artifacts

Deploy artifacts include `DeploymentConfigs`, `StatefulSets`, `Daemonsets`, `Services`, `Routes`, `PersistentVolumeClaims`, `ConfigMaps`, `Secrets`, `ServiceAccounts` and other objects that get deployed to namespaces. These resources should be created via templates using the following directory structure.

```
./deploy
./deploy/<app-name>
./deploy/<app-name>/<app-name>-template.yml
./deploy/<app-name>/<namespace>
./deploy/<app-name>/<namespace>/params
```

And applied with

```
oc process -f deploy/<app-name>/<app-name>-template.yml --param-file=deploy/<app-name>/<namespace>/params | oc apply -f -
```
