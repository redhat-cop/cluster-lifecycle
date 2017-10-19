# Acme

Using this inventory with the [openshift-applier](https://github.com/redhat-cop/casl-ansible/roles/openshift-applier) and the [openshift-cluster-seed](https://github.com/redhat-cop/casl-ansible/playbooks/openshift-cluster-seed.yml) playbook, it deploys a controller to [Let's Encrypt](https://letsencrypt.org/) (ACME) service. 

## Example Execution

``` 
$ ansible-playbook -i acme playbooks/openshift-cluster-seed.yml --connection=local
```

Where `acme` is this inventory, and `playbooks/openshift-cluster-seed.yml` playbook is the one in the [casl-ansible](https://github.com/redhat-cop/casl-ansible) repository.
