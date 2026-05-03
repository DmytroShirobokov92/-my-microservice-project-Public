<!-- lesson-8-9/README_jenkins_argo_cd.md -->
# Work 8-9: Jenkins and Argo CD

### СТРУКТУРА ПРОЕКТУ ТА КОМАНДИ З ВІДПОВІДДЮ
##### *декотрі файли з'являються після розгортання terraform та виконання певних команд*


```python
~/my-microservice-project/lesson-8-9$ tree
.
├── Jenkinsfile
├── README_jenkins_argo_cd.md
├── backend.tf
├── charts
│   └── django-app
│       ├── Chart.yaml
│       ├── templates
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   └── service.yaml
│       └── values.yaml
├── docker
│   ├── django
│   │   ├── Dockerfile
│   │   ├── goit
│   │   │   ├── __init__.py
│   │   │   ├── asgi.py
│   │   │   ├── settings.py
│   │   │   ├── urls.py
│   │   │   └── wsgi.py
│   │   ├── manage.py
│   │   └── requirements.txt
│   ├── docker-compose.yaml
│   ├── env.txt
│   └── nginx
│       └── default.conf
├── main.tf
├── modules
│   ├── argo_cd
│   │   ├── argo_cd.tf
│   │   ├── charts
│   │   │   ├── Chart.yaml
│   │   │   ├── templates
│   │   │   │   ├── application.yaml
│   │   │   │   └── repository.yaml
│   │   │   └── values.yaml
│   │   ├── jenkins.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   └── variables.tf
│   ├── ecr
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── eks.tf
│   │   ├── node.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── jenkins
│   │   ├── jenkins.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   └── variables.tf
│   ├── s3-backend
│   │   ├── dynamodb.tf
│   │   ├── outputs.tf
│   │   ├── s3.tf
│   │   └── variables.tf
│   └── vpc
│       ├── outputs.tf
│       ├── routes.tf
│       ├── variables.tf
│       └── vpc.tf
├── outputs.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── tfplan

17 directories, 56 files

```

1. Terraform (ініціалізація та створення ресурсів)

```python
cd lesson-8-9

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

2. Remote Backend

```python
# Розкоментувати backend.tf
terraform init -migrate-state
```

3. Базові ресурси

```python
terraform apply -target=module.s3_backend
terraform apply -target=module.vpc -target=module.ecr -target=module.eks
```

4. Підключення до EKS

```python
aws eks update-kubeconfig --region eu-west-1 --name eks-cluster-lesson-8-9-jenkins-argo-cd
```

```python
kubectl get nodes -o wide
```

```bash
NAME                                       STATUS   ROLES    AGE     VERSION               INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-10-0-5-46.eu-west-1.compute.internal    Ready    <none>   3h38m   v1.35.3-eks-bbe087e   10.0.5.46     <none>        Amazon Linux 2023.11.20260413   6.12.79-101.147.amzn2023.x86_64   containerd://2.2.1+unknown
ip-10-0-6-171.eu-west-1.compute.internal   Ready    <none>   3h38m   v1.35.3-eks-bbe087e   10.0.6.171    <none>        Amazon Linux 2023.11.20260413   6.12.79-101.147.amzn2023.x86_64   containerd://2.2.1+unknown
```


```python
kubectl get pods -A
```
```bash
NAMESPACE     NAME                                                        READY   STATUS    RESTARTS   AGE
argocd        argo-cd-argocd-application-controller-0                     1/1     Running   0          3h34m
argocd        argo-cd-argocd-applicationset-controller-59cd8c8d4b-99smz   1/1     Running   0          3h34m
argocd        argo-cd-argocd-dex-server-7464fdb74b-wbdzz                  1/1     Running   0          3h34m
argocd        argo-cd-argocd-notifications-controller-678957db85-gxkxl    1/1     Running   0          3h34m
argocd        argo-cd-argocd-redis-78767dfbf8-fpq2f                       1/1     Running   0          3h34m
argocd        argo-cd-argocd-repo-server-65c8b55dbc-shcht                 1/1     Running   0          3h34m
argocd        argo-cd-argocd-server-668bb5976d-x42q4                      1/1     Running   0          3h34m
default       django-app-django-64cf5fb79c-mqf9p                          1/1     Running   0          51m
default       django-app-django-64cf5fb79c-xz8br                          1/1     Running   0          51m
jenkins       jenkins-0                                                   2/2     Running   0          3h30m
kube-system   aws-node-2f74h                                              2/2     Running   0          3h39m
kube-system   aws-node-jvlps                                              2/2     Running   0          3h39m
kube-system   coredns-85987cc855-gh6dr                                    1/1     Running   0          3h43m
kube-system   coredns-85987cc855-mss8z                                    1/1     Running   0          3h43m
kube-system   ebs-csi-controller-b94d8859c-rk267                          6/6     Running   0          3h40m
kube-system   ebs-csi-controller-b94d8859c-w9fcx                          6/6     Running   0          3h40m
kube-system   ebs-csi-node-4zvgd                                          3/3     Running   0          3h39m
kube-system   ebs-csi-node-8xhzh                                          3/3     Running   0          3h39m
kube-system   kube-proxy-8gtfd                                            1/1     Running   0          3h39m
kube-system   kube-proxy-tz2nz                                            1/1     Running   0          3h39m
```


5. Jenkins

```python
terraform apply -target=module.jenkins
```

```python
kubectl get pods -n jenkins
```
```bash
NAME        READY   STATUS    RESTARTS   AGE
jenkins-0   2/2     Running   0          3h34m
```

```python
kubectl get svc -n jenkins
```
```bash
NAME            TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)        AGE
jenkins         LoadBalancer   172.20.165.139   aa9383f4e1706484aae9069b4d87b4a2-1124399724.eu-west-1.elb.amazonaws.com   80:31067/TCP   3h34m
jenkins-agent   ClusterIP      172.20.47.43     <none>                                                                    50000/TCP      3h34m
```

```python
# LoadBalancer URL Jenkins
kubectl get svc -n jenkins jenkins -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
```bash
aa9383f4e1706484aae9069b4d87b4a2-1124399724.eu-west-1.elb.amazonaws.com
```

6. Argo CD

```python
terraform apply -target=module.argo_cd

kubectl get pods -n argocd
kubectl get svc -n argocd

# LoadBalancer URL Argo CD
kubectl get svc -n argocd argo-cd-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'


kubectl get applications -n argocd
```

```bash
NAME                                                        READY   STATUS    RESTARTS   AGE
argo-cd-argocd-application-controller-0                     1/1     Running   0          3h41m
argo-cd-argocd-applicationset-controller-59cd8c8d4b-99smz   1/1     Running   0          3h41m
argo-cd-argocd-dex-server-7464fdb74b-wbdzz                  1/1     Running   0          3h41m
argo-cd-argocd-notifications-controller-678957db85-gxkxl    1/1     Running   0          3h41m
argo-cd-argocd-redis-78767dfbf8-fpq2f                       1/1     Running   0          3h41m
argo-cd-argocd-repo-server-65c8b55dbc-shcht                 1/1     Running   0          3h41m
argo-cd-argocd-server-668bb5976d-x42q4                      1/1     Running   0          3h41m



NAME                                       TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                      AGE
argo-cd-argocd-applicationset-controller   ClusterIP      172.20.50.43     <none>                                                                    7000/TCP                     3h42m
argo-cd-argocd-dex-server                  ClusterIP      172.20.17.22     <none>                                                                    5556/TCP,5557/TCP            3h42m
argo-cd-argocd-redis                       ClusterIP      172.20.165.165   <none>                                                                    6379/TCP                     3h42m
argo-cd-argocd-repo-server                 ClusterIP      172.20.248.92    <none>                                                                    8081/TCP                     3h42m
argo-cd-argocd-server                      LoadBalancer   172.20.196.233   a353e9e51487142c192680bd1f8398e7-1118306119.eu-west-1.elb.amazonaws.com   80:30554/TCP,443:30422/TCP   3h42m


a353e9e51487142c192680bd1f8398e7-1118306119.eu-west-1.elb.amazonaws.com
```

7. Django

```python
kubectl get pods -n default
kubectl get svc -n default

# LoadBalancer URL Django
kubectl get svc -n default django-app-django -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

```bash

NAME                                 READY   STATUS    RESTARTS   AGE
django-app-django-64cf5fb79c-mqf9p   1/1     Running   0          64m
django-app-django-64cf5fb79c-xz8br   1/1     Running   0          64m


NAME                TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE
django-app-django   LoadBalancer   172.20.129.208   acea3c0b139ef4a5982025cd26b0a806-273510444.eu-west-1.elb.amazonaws.com   80:31834/TCP   3h6m
kubernetes          ClusterIP      172.20.0.1       <none>                                                                   443/TCP        3h57m

```


9. Візуалізація графа залежностей

```python
terraform graph | dot -Tpng > graph.png
```
* у роботі збережено файл з назвою graph.png  - саме він зберіг структуру створеної роботи



10. Cleanup

```python
helm uninstall jenkins -n jenkins --ignore-not-found
helm uninstall argo-cd -n argocd --ignore-not-found

terraform destroy -lock=false
```

11. Видаленя ECR

```python
aws ecr delete-repository \
  --repository-name lesson-8-9-ecr-jenkins-argo-cd \
  --region eu-west-1 --force
```

#### Скріншоти

![django-app-1](/lesson-8-9/screenshot/argo-cd
-1.png)


![django-app-1](/lesson-8-9/screenshot/argo-cd-1.png)


![argo-cd-2](/lesson-8-9/screenshot/argo-cd-2.png)


![jenkins-1](/lesson-8-9/screenshot/jenkins-1.png)


![jenkins-2](/lesson-8-9/screenshot/jenkins-2.png)


![jenkins-3](/lesson-8-9/screenshot/jenkins-3.png)