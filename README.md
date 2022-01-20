# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

## Задание 2 (*): подготовить и проверить инвентарь для кластера в AWS
Часть новых проектов хотят запускать на мощностях AWS. Требования похожи:
* разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
* работать должны на минимально допустимых EC2 — t3.small.

---
Все разворачивается в Yandex Cloud, файлы Terraform есть в репозитории
Файлы, которые я изменял в kubespray
- [inventory.ini](/kubespray/inventory/mycluster/inventory.ini)
- [all.yml](/kubespray/inventory/mycluster/group_vars/all/all.yml) - параметр `loadbalancer_apiserver`

```
$ kubectl get nodes -o wide
NAME    STATUS   ROLES                  AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
node1   Ready    control-plane,master   14m   v1.23.1   10.2.35.4     <none>        Ubuntu 20.04.3 LTS   5.4.0-42-generic   containerd://1.5.9
node2   Ready    <none>                 12m   v1.23.1   10.2.35.33    <none>        Ubuntu 20.04.3 LTS   5.4.0-42-generic   containerd://1.5.9
node3   Ready    <none>                 12m   v1.23.1   10.2.35.31    <none>        Ubuntu 20.04.3 LTS   5.4.0-42-generic   containerd://1.5.9
```
