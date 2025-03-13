# PostgreSQL для TeamCity

Этот репозиторий содержит все необходимые файлы для развертывания PostgreSQL в Kubernetes с использованием Helm.

## Содержимое репозитория

- `postgresql-charts/postgresql/` - Helm чарты PostgreSQL от Bitnami
- `postgresql-image.tar` - Docker образ PostgreSQL для офлайн установки

## Данные для подключения к PostgreSQL

- **Database host[:port]**: postgresql.teamcity.svc.cluster.local:5432
- **Database name**: teamcity
- **User name**: teamcity
- **Password**: teamcity123

## Инструкции по развертыванию

### Предварительные требования

- Установленный Kubernetes кластер (например, Minikube)
- Установленный Helm
- Установленный Docker

### Установка с доступом к интернету

1. Добавьте репозиторий Helm:
   ```bash
   helm repo add stable https://charts.helm.sh/stable
   helm repo update
   ```

2. Создайте namespace для TeamCity:
   ```bash
   kubectl create namespace teamcity
   ```

3. Установите PostgreSQL:
   ```bash
   helm install postgresql stable/postgresql --namespace teamcity \
     --set postgresqlUsername=teamcity \
     --set postgresqlPassword=teamcity123 \
     --set postgresqlDatabase=teamcity \
     --set persistence.size=10Gi
   ```

### Установка без доступа к интернету

1. Загрузите Docker образ PostgreSQL:
   ```bash
   docker load -i postgresql-image.tar
   ```

2. Создайте namespace для TeamCity:
   ```bash
   kubectl create namespace teamcity
   ```

3. Установите PostgreSQL из локальных чартов:
   ```bash
   helm install postgresql ./postgresql-charts/postgresql/ \
     --namespace teamcity \
     --set auth.username=teamcity \
     --set auth.password=teamcity123 \
     --set auth.database=teamcity \
     --set primary.persistence.size=10Gi
   ```

## Настройка TeamCity

1. Скачайте JDBC драйвер PostgreSQL:
   ```bash
   wget https://jdbc.postgresql.org/download/postgresql-42.7.2.jar -O /opt/teamcity/TeamCityData/lib/jdbc/postgresql-42.7.2.jar
   ```

2. При настройке TeamCity укажите следующие параметры подключения к базе данных:
   - **Database host[:port]**: postgresql.teamcity.svc.cluster.local:5432
   - **Database name**: teamcity
   - **User name**: teamcity
   - **Password**: teamcity123

## Проверка статуса

Для проверки статуса PostgreSQL выполните:
```bash
kubectl get pods -n teamcity
```

## Подключение к PostgreSQL

Для подключения к PostgreSQL из кластера:
```bash
kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace teamcity \
  --image docker.io/bitnami/postgresql:latest \
  --env="PGPASSWORD=teamcity123" \
  --command -- psql --host postgresql -U teamcity -d teamcity -p 5432
```

Для подключения к PostgreSQL извне кластера:
```bash
kubectl port-forward --namespace teamcity svc/postgresql 5432:5432 &
PGPASSWORD="teamcity123" psql --host 127.0.0.1 -U teamcity -d teamcity -p 5432
```
