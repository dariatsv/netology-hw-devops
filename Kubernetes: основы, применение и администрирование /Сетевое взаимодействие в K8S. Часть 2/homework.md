# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool.
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
      [](img/1.png)
      [](img/2.png)
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

    Deployment:
    [](file/deployment_frontend.yaml)
    [](file/deployment_backend.yaml)

    ```text
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
    NAME                        READY   STATUS    RESTARTS   AGE
    backend-7557d45d65-zphcw    1/1     Running   0          86s
    frontend-54b9c68f67-6c5p9   1/1     Running   0          59s
    frontend-54b9c68f67-84mrk   1/1     Running   0          59s
    frontend-54b9c68f67-mf96v   1/1     Running   0          59s
    
    ```
   
    Service:
    [](file/service_frontend.yaml)
    [](file/service_backend.yaml)

    ```text
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get services
    NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    back-service    ClusterIP   10.152.183.73   <none>        80/TCP    36s
    front-service   ClusterIP   10.152.183.99   <none>        80/TCP    28s
    kubernetes      ClusterIP   10.152.183.1    <none>        443/TCP   81m
    
    ```

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

Еще нужно включить ingress на microk8s
```text
dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s enable ingress
Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enabled
```

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

   ```text
   daracvetkova@192-168-1-120 netology-hw-devops % curl http://netology.local
   <!DOCTYPE html>
   <html>
   <head>
   <title>Welcome to nginx!</title>
   <style>
   html { color-scheme: light dark; }
   body { width: 35em; margin: 0 auto;
   font-family: Tahoma, Verdana, Arial, sans-serif; }
   </style>
   </head>
   <body>
   <h1>Welcome to nginx!</h1>
   <p>If you see this page, the nginx web server is successfully installed and
   working. Further configuration is required.</p>
   
   <p>For online documentation and support please refer to
   <a href="http://nginx.org/">nginx.org</a>.<br/>
   Commercial support is available at
   <a href="http://nginx.com/">nginx.com</a>.</p>
   
   <p><em>Thank you for using nginx.</em></p>
   </body>
   </html>
   ```
      ```text
   daracvetkova@192-168-1-120 netology-hw-devops % curl http://netology.local/api
    WBITT Network MultiTool (with NGINX) - backend-7557d45d65-qzq27 - 10.1.14.125 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

   ```
4. Предоставить манифесты и скриншоты или вывод команды п.2.
    [](file/ingress.yaml)

```text
dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get ingress
NAME      CLASS    HOSTS            ADDRESS   PORTS   AGE
ingress   public   netology.local             80      7s



```
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------