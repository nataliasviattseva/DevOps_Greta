%title: ANSIBLE
%author: pmerle


# ANSIBLE : With Item et boucles


<br>

Documentation : https://docs.ansible.com/ansible/latest/plugins/lookup/items.html

<br>

* la liste des boucles :

<br>

- with_items : liste de dictionnaire
<br>

- with_nested : liste de liste
<br>

- with_dict : parcours de dictionnaire
<br>

- with_fileglob : liste de fichiers avec pattern et non récursif
<br>

- with_filetree : liste de fichiers dans une arborescence (pattern) suivant des critères
<br>

- with_together : croisement de deux listes en parallèle
<br>

- with_sequence : avec des ranges à interval
<br>

- with_random_choice : tirage au sort dans une liste
<br>

- with_first_found : premier élément d'une liste (qui elle même est variable)
<br>

- with_lines : avec chaque ligne d'un programme (shell exemple)
<br>

- with_ini : parcourir un init file
<br>

- with_inventory_hostnames : avec l'inventory

----------------------------------------------------------------------------------------

# ANSIBLE : With Item et boucles


<br>

* liste simple

```
  - name: boucle création de répertoire
    file:
      path: /tmp/pmerle/{{ item }}
      state: directory
      recurse: yes
    with_items:
    - pmerle1
    - pmerle2
    - pmerle3
    - pmerle4
```

<br>

* liste composée (liste de dicts/hash)

```
  - name: création de fichiers
    file:
      path: /tmp/pmerle/{{ item.dir }}/{{ item.file }}
      state: touch
    with_items:
    - { dir: "pmerle1", file: "fichierA"}
    - { dir: "pmerle2", file: "fichierB"}
    - { dir: "pmerle3", file: "fichierC"}
    - { dir: "pmerle4", file: "fichierD"}
```

----------------------------------------------------------------------------------------

# ANSIBLE : With Item et boucles


<br>

* version condensée

```
  vars:
    fichiers:
    - { dir: "pmerle1", file: "fichierA"}
    - { dir: "pmerle2", file: "fichierB"}
    - { dir: "pmerle3", file: "fichierC"}
    - { dir: "pmerle4", file: "fichierD"}
  tasks:
  - name: création de fichiers
    file:
      path: /tmp/pmerle/{{ item.dir }}/{{ item.file }}
      state: touch
    with_items:
    - "{{ fichiers }}"
```

<br>

* parcourir une liste de machines de l'inventaire

```
 with_items:
    - "{{ groups['all'] }}"
```

<br>

* en version plus simple :

```
  - name: création de fichiers
    file:
      path: /tmp/{{ item }}
      state: touch
    with_inventory_hostnames:
    - all
```
