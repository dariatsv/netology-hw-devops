# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
     [deployment.yaml](file/deployment.yaml)
    
     ```text
        dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
        NAME                                READY   STATUS    RESTARTS   AGE
        nginx-deployment-67b484cf74-vznb4   2/2     Running   0          10s

     ```
2. После запуска увеличить количество реплик работающего приложения до 2.
    ```text
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl scale deployment nginx-deployment --replicas=2
    deployment.apps/nginx-deployment scaled
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
    NAME                                READY   STATUS    RESTARTS   AGE
    nginx-deployment-67b484cf74-42b2l   2/2     Running   0          4s
    nginx-deployment-67b484cf74-vznb4   2/2     Running   0          27s


    ```
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
    [service.yaml](file/service.yaml)
    ```text
  dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get service
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
    kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   76m
    nginx-svc    ClusterIP   10.152.183.190   <none>        80/TCP    7s
    ```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
    
   ```text
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl run multitool --image=wbitt/network-multitool
    pod/multitool created
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
    NAME                                READY   STATUS    RESTARTS   AGE
    multitool                           1/1     Running   0          17s
    nginx-deployment-67b484cf74-42b2l   2/2     Running   0          4m39s
    nginx-deployment-67b484cf74-vznb4   2/2     Running   0          5m2s
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl exec multitool -- curl nginx-svc -I
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0   615    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
    HTTP/1.1 200 OK
    Server: nginx/1.27.2
    Date: Tue, 12 Nov 2024 09:30:30 GMT
    Content-Type: text/html
    Content-Length: 615
    Last-Modified: Wed, 02 Oct 2024 15:13:19 GMT
    Connection: keep-alive
    ETag: "66fd630f-267"
    Accept-Ranges: bytes
    
    ```
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
   [deployment-busy.yaml](file/deployment-busy.yaml)

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
```text
dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
NAME                                READY   STATUS     RESTARTS   AGE
deployment1-8899bc556-t8prg         0/1     Init:0/1   0          23s

```
3. Создать и запустить Service. Убедиться, что Init запустился.
    ```text
    dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get service
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
    kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   85m
    myapp        ClusterIP   10.152.183.72    <none>        80/TCP    29s
    nginx-svc    ClusterIP   10.152.183.190   <none>        80/TCP    9m30s

    ```
4. Продемонстрировать состояние пода до и после запуска сервиса.
```text
dasha21a@compute-vm-2-2-20-hdd-1731398635649:~$ microk8s kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
deployment1-8899bc556-t8prg         1/1     Running   0          2m5s

```
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------