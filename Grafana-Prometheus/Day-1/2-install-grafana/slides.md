%title: Prometheus/Grafana
%author: pmerle


# Qu'est-ce que Grafana ?

* visualisation
 * graphiques
 * tableaux
 * gauges
 * histogrammes
 * points

* alerting
 * declencheurs

* multisources
 * prometheus
 * influxdb
 * postgres
 * mysql
 * elasticsearch

-------------------------------------------------------------------------------------------


# Comment l'installer ?


## Installation de Grafana


```
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install grafana
```


## Start service


```
sudo /etc/init.d/grafana start
```

## Accès

```
localhost:3000
```
