# Примеры команд для установки PostgreSQL в Kubernetes

## Подготовка

Перед установкой убедитесь, что у вас установлены:
- kubectl
- helm (версия 3+)
- доступ к кластеру Kubernetes

## Создание пространства имен

```bash
kubectl create namespace postgresql
```

## Создание секретов (для продакшн)

### Секрет с учетными данными PostgreSQL

```bash
# Создание секрета из файла
kubectl apply -f create-secret.yaml -n postgresql

# Или создание секрета напрямую
kubectl create secret generic postgresql-credentials \
  --from-literal=postgresql-password=YourSecurePasswordHere \
  --from-literal=postgresql-replication-password=YourSecureReplicationPasswordHere \
  -n postgresql
```

### Секрет для шифрования данных

```bash
# Создание секрета из файла
kubectl apply -f create-encryption-secret.yaml -n postgresql

# Или создание секрета напрямую
kubectl create secret generic postgresql-encryption-key \
  --from-literal=encryption-key=YourSecureEncryptionKeyHere \
  -n postgresql
```

### Секрет для доступа к S3

```bash
# Создание секрета из файла
kubectl apply -f create-s3-secret.yaml -n postgresql

# Или создание секрета напрямую
kubectl create secret generic postgres-s3-credentials \
  --from-literal=access-key=YourS3AccessKeyHere \
  --from-literal=secret-key=YourS3SecretKeyHere \
  -n postgresql
```

## Установка в тестовое окружение

```bash
helm install postgresql ../postgresql-chart -f ../values/test-values.yaml -n postgresql
```

## Установка в продакшн окружение

```bash
helm install postgresql ../postgresql-chart -f ../values/production-values.yaml -n postgresql
```

## Установка в продакшн окружение с улучшениями

```bash
helm install postgresql ../postgresql-chart -f ../values/production-values-enhanced.yaml -n postgresql
```

## Обновление установки

```bash
helm upgrade postgresql ../postgresql-chart -f ../values/production-values-enhanced.yaml -n postgresql
```

## Проверка статуса

```bash
# Проверка подов
kubectl get pods -n postgresql

# Проверка сервисов
kubectl get svc -n postgresql

# Проверка StatefulSet
kubectl get statefulset -n postgresql

# Проверка PVC
kubectl get pvc -n postgresql

# Проверка HPA (если включено автомасштабирование)
kubectl get hpa -n postgresql

# Проверка ServiceMonitor (если включен мониторинг)
kubectl get servicemonitor -n postgresql
```

## Подключение к PostgreSQL

```bash
# Запуск клиентского пода
kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace postgresql \
  --image postgres:15.4 \
  --env="PGPASSWORD=YourSecurePasswordHere" \
  --command -- psql -h postgresql -U postgres -d postgres

# Или использование port-forward
kubectl port-forward svc/postgresql 5432:5432 -n postgresql
# Затем подключение с локального компьютера
# psql -h localhost -U postgres -d postgres
```

## Проверка резервного копирования

```bash
# Проверка статуса CronJob
kubectl get cronjob -n postgresql

# Проверка логов последнего задания резервного копирования
kubectl logs -l app.kubernetes.io/component=backup -n postgresql --tail=100
```

## Проверка шифрования

```bash
# Подключение к поду PostgreSQL
kubectl exec -it postgresql-0 -n postgresql -- bash

# Проверка настроек SSL
psql -U postgres -c "SHOW ssl;"
```

## Удаление

```bash
helm uninstall postgresql -n postgresql
``` 