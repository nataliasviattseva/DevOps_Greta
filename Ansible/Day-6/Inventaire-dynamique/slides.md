%title: ANSIBLE
%author: pmerle




# ANSIBLE : Inventory dynamic


Documentation : 

https://docs.ansible.com/ansible/latest/plugins/inventory.html
https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html

https://github.com/ansible-collections/community.general/tree/main/scripts/inventory


<br>

* ansible.cfg

```
[inventory]
# enable inventory plugins, default: 'host_list', 'script', 'auto', 'yaml', 'ini', 'toml'
enable_plugins = host_list, script, auto, yaml, ini, toml, community.docker.docker_containers
```


* fichier d'inventaire

```
plugin: community.docker.docker_containers
docker_host: unix://var/run/docker.sock
```

```
ansible-inventory -i docker.yml --l
```
