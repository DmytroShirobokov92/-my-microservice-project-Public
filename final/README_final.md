<!-- final/README_final.md -->
# FINAL HomeWork: Jenkins && Argo CD && Aurora/RDS && Django && MONITORING (PROMETHEUS + GRAFANA)

### СТРУКТУРА ПРОЕКТУ ТА КОМАНДИ ЯКІ БУЛИ ВИКОРИСТАНІ В ДАНІЙ РОБОТІ
##### *декотрі файли з'являються після розгортання terraform та виконання певних команд*


```python
/my-microservice-project/final$ tree
.
├── Django
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
│   └── nginx
│       └── default.conf
├── Jenkinsfile
├── README_final.md
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
│   │   ├── helm_release_django.tf
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
│   ├── monitoring
│   │   ├── grafana.tf
│   │   ├── outputs.tf
│   │   └── prometheus.tf
│   ├── rds
│   │   ├── aurora.tf
│   │   ├── outputs.tf
│   │   ├── rds.tf
│   │   ├── shared.tf
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
└── outputs.tf

19 directories, 60 files
```

1. Перевірка Kubernetes кластера

```bash
# Ноди
kubectl get nodes -o wide

# Поди у default namespace
kubectl get pods -n default -o wide

# Сервіси
kubectl get svc -n default

# Horizontal Pod Autoscaler
kubectl get hpa -n default
```

2. Django (питання в процесі вирішення)

```bash
# Логи Django
kubectl logs -f deploy/django-app-django -n default

# Перевірка доступності сервісу зсередини кластера
kubectl run tmp-shell --rm -it --image=alpine -- sh
apk add curl
curl http://django-app-django.default.svc.cluster.local:80/admin/
```

3. Jenkins

```bash
# Поди Jenkins
kubectl get pods -n default | grep jenkins

# Логи Jenkins
kubectl logs -f deploy/jenkins -n default

# Сервіс Jenkins
kubectl get svc jenkins -n default
```

4. Argo CD

```bash
# Поди Argo CD
kubectl get pods -n default | grep argo

# Сервіс Argo CD
kubectl get svc argo-cd -n default
```

5. RDS / Aurora

```bash
# Перевірка доступності БД з пода
kubectl run psql-client --rm -it --image=postgres:15 -- bash
psql -h myapp-db-cluster.cluster-cpoe6ggcw873.eu-west-1.rds.amazonaws.com -U django_user -d django_db
```

6. Моніторинг (Prometheus + Grafana)

```bash
# Поди Prometheus та Grafana
kubectl get pods -n default | grep prometheus
kubectl get pods -n default | grep grafana

# Сервіси Prometheus та Grafana
kubectl get svc prometheus -n default
kubectl get svc grafana -n default

# Перевірка доступності зсередини кластера (не завжди спрацьовувала)
kubectl run tmp-shell --rm -it --image=alpine -- sh
apk add curl
curl http://prometheus.default.svc.cluster.local:9090/-/ready
curl http://grafana.default.svc.cluster.local:3000/login
```

### Скріншоти

![argo](/final/scrinshots/argo.png)


![jenkins](/final/scrinshots/Jenkins.png)


![monitoring](/final/scrinshots/prometheus.png)


![django](/final/scrinshots/dashboard.png)



#####  *На даному етапі продовжується питання яке потребує вирішення, що до Джанго.