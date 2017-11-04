# CakePHP Cluster LifeCycle Example

Using the [CakePHP inventory](../inventory/cakephp) with the [openshift-applier](https://github.com/redhat-cop/casl-ansible/roles/openshift-applier) and the [openshift-cluster-seed](https://github.com/redhat-cop/casl-ansible/playbooks/openshift-cluster-seed.yml) playbook, it deploys a working pipeline and build/deployment stages projects, based on the CakePHP examples. 

## Example Execution

``` 
> ansible-playbook -i cakephp-example playbooks/openshift-cluster-seed.yml --connection=local
```

Where `cakephp-example` is the [CakePHP inventory](../inventory/cakephp), and `playbooks/openshift-cluster-seed.yml` playbook is the one in the [casl-ansible](https://github.com/redhat-cop/casl-ansible) repository.
