# Примеры команд для установки PostgreSQL Beta

## Установка с значениями по умолчанию

```bash
helm install postgresql-beta ./postgresql-beta-chart
```

## Установка для тестового окружения

```bash
helm install postgresql-beta ./postgresql-beta-chart -f ./postgresql-beta-chart/values/test-values.yaml
```

## Установка для production окружения

### 1. Создание секрета с паролями

```bash
# Создание секрета из файла
kubectl apply -f ./postgresql-beta-chart/examples/create-secret.yaml

# Или создание секрета из командной строки
kubectl create secret generic postgresql-credentials \
  --from-literal=postgresql-password=your-secure-password \
  --from-literal=postgresql-replication-password=your-secure-replication-password
```

### 2. Установка с production значениями

```bash
helm install postgresql-beta ./postgresql-beta-chart -f ./postgresql-beta-chart/values/production-values.yaml
```

## Обновление существующей установки

```bash
helm upgrade postgresql-beta ./postgresql-beta-chart -f ./postgresql-beta-chart/values/production-values.yaml
```

## Удаление установки

```bash
helm uninstall postgresql-beta
```

**Примечание**: При удалении чарта PersistentVolumeClaims не удаляются автоматически. Если вы хотите удалить данные, вам нужно удалить PVC вручную:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=postgresql-beta
``` 