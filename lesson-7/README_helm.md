# Work 7: Helm (K8s)

### СТРУКТУРА ПРОЕКТУ
##### *декотрі файли з'являються після розгортання terraform та виконання певних команд*


```python
tree
.
├── README_helm.md
├── backend.tf
├── charts
│   ├── check.txt
│   └── django-chart
│       ├── Chart.yaml
│       ├── templates
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   └── service.yaml
│       └── values.yaml
├── graph.png
├── main.tf
├── modules
│   ├── ecr
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── eks.tf
│   │   ├── node.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── info.txt
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

9 directories, 31 files

```

### ОПИС ПРОЕКТУ

Проєкт демонструє деплой Django‑застосунку в Kubernetes (EKS) із використанням:

- Terraform для створення інфраструктури (VPC, EKS, ECR, S3, DynamoDB).

- Docker для контейнеризації Django.

- ECR як реєстр образів.

- Helm для деплою застосунку в кластер.

- HPA для автомасштабування.


### ПОПЕРЕДНІ ВИМОГИ

- AWS CLI налаштований (aws configure).

- kubectl встановлений.

- Helm встановлений.

- Docker встановлений.

- Graphviz (для візуалізації графа Terraform).


### КОМАНДИ ВИКОРИСТАНІ У ПРОЕКТІ ТА ЇХ РЕЗУЛЬТАТ

```python
terraform init
terraform init reconfigure - після розкоментування файлу backend.tf
```

##### Корисно для валідації
```python
terraform validate
```

##### ВИВІД СТРУКТУРИ
```python
terraform plan
terraform plan -out=tfplan - по бажанню
```

##### ЗАПУСК РОБОТИ КОДУ
```python
terraform apply
terraform apply "tfplan" - по бажанню
terraform apply -auto-approve - варіант запуску
```


### OUTPUTS

```python
terraform output

dynamodb_table_name = "terraform-locks"
internet_gateway_id = "igw-0324abdc652448524"
private_subnets = [
  "subnet-0400c01767001256a",
  "subnet-00181a72f2d46f5c0",
  "subnet-0a1b4c843e9a0b859",
]
public_subnets = [
  "subnet-0d1cfb6c66ec3582e",
  "subnet-080832fd0a2ea37a7",
  "subnet-0636e7d312f10098d",
]
repository_url = "768405431530.dkr.ecr.eu-west-1.amazonaws.com/lesson-7-ecr-helm"
s3_bucket_name = "lesson-7-helm-state-bucket-001001"
vpc_id = "vpc-0c850f0c91a0d3495"
```

```python
helm upgrade --install django-app . --set image.repository=768405431530.dkr.ecr.eu-west-1
.amazonaws.com/lesson-7-ecr-helm --set image.tag=latest_helm

Release "django-app" has been upgraded. Happy Helming!
NAME: django-app
LAST DEPLOYED: Mon Apr 13 16:13:04 2026
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
```

```python
aws eks update-kubeconfig --region eu-west-1 --name eks-cluster-lesson-7-helm

Updated context arn:aws:eks:eu-west-1:768405431530:cluster/eks-cluster-lesson-7-helm in /home/shimoda/.kube/config
```

```python
kubectl get nodes

NAME                                       STATUS   ROLES    AGE   VERSION
ip-10-0-4-232.eu-west-1.compute.internal   Ready    <none>   25m   v1.35.2-eks-f69f56f
ip-10-0-6-37.eu-west-1.compute.internal    Ready    <none>   25m   v1.35.2-eks-f69f56f
```

```python
kubectl get pods

NAME                                 READY   STATUS    RESTARTS   AGE
django-app-django-54985489b9-fkrzd   1/1     Running   0          3m12s
django-app-django-54985489b9-w2wl8   1/1     Running   0          3m12s
```

```python
kubectl get svc

NAME                TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE
django-app-django   LoadBalancer   172.20.221.212   a9de422df99844104982d6eca62692b4-119516156.eu-west-1.elb.amazonaws.com   80:31458/TCP   3m20s
kubernetes          ClusterIP      172.20.0.1       <none>                                                                   443/TCP        30m
```

```python
kubectl get hpa

NAME             REFERENCE                      TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
django-app-hpa   Deployment/django-app-django   cpu: <unknown>/70%   2         6         2          3m31s
```

#### КОМАНДА ЯКА СТВОРИТЬ ГРАФ  у форматі .png

```python
terraform graph | dot -Tpng > graph.png
```


#### ЗНИЩЕННЯ terraform

```pyton
terraform destroy
terraform destroy -auto-approve - по бажанню
```

#### Примітка

- Після виконання `terraform destroy` ресурси будуть видалені, але файли `terraform.tfstate` та `terraform.tfstate.backup` залишаться. Їх можна видалити вручну, якщо вони більше не потрібні.

- Нажаль навіть при виконання terraform destoy, РЕКОМЕНДОВАНО перевірити в ручному режимі видалення створених ресурсів.


































