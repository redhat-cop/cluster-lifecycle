# Acme

Using this [acme inventory](../inventory/acme)  with the [openshift-applier](https://github.com/redhat-cop/openshift-applier) and the [openshift-cluster-seed](https://github.com/redhat-cop/openshift-applier/blob/master/playbooks/openshift-cluster-seed.yml) playbook, it deploys a controller to [Let's Encrypt](https://letsencrypt.org/) (ACME) service. 

**Note:** This functionality only supports "cluster-wide" deployments right now.

## Example Execution

``` 
$ ansible-playbook -i acme playbooks/openshift-cluster-seed.yml
```

Where `acme` is [acme inventory](../inventory/acme), and `playbooks/openshift-cluster-seed.yml` playbook is the one in the [casl-ansible](https://github.com/redhat-cop/casl-ansible) repository.

## Reference

As the inventory shows, the original implementation for this functionality lives [here](https://github.com/tnozicka/openshift-acme)
