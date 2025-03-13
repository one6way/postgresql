# PostgreSQL Beta Helm Chart

Упрощенная версия Helm Chart для PostgreSQL с репликацией и отказоустойчивостью. Этот чарт предназначен для быстрого развертывания PostgreSQL в Kubernetes с минимальными настройками, но с сохранением основных функций для обеспечения надежности.

## Особенности

- **Отказоустойчивость**: Поддержка репликации для высокой доступности
- **Простота**: Минимальный набор настроек для быстрого старта
- **Масштабируемость**: Настраиваемое количество реплик
- **Безопасность**: Автоматическая генерация паролей и поддержка существующих секретов

## Требования

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner поддержка в кластере (для постоянного хранения данных)

## Установка

```bash
# Установка с значениями по умолчанию
helm install postgresql-beta ./postgresql-beta-chart

# Установка с пользовательскими значениями
helm install postgresql-beta ./postgresql-beta-chart -f values.yaml
```

## Конфигурация

### Основные параметры

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `replicaCount` | Количество реплик PostgreSQL | `3` |
| `image.repository` | Репозиторий образа PostgreSQL | `postgres` |
| `image.tag` | Тег образа PostgreSQL | `14.5` |
| `image.pullPolicy` | Политика загрузки образа | `IfNotPresent` |
| `postgresql.username` | Имя пользователя PostgreSQL | `postgres` |
| `postgresql.password` | Пароль пользователя PostgreSQL | `""` (генерируется случайно) |
| `postgresql.database` | Имя базы данных | `postgres` |
| `postgresql.existingSecret` | Имя существующего секрета с паролями | `""` |
| `postgresql.port` | Порт PostgreSQL | `5432` |

### Репликация

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `postgresql.replication.enabled` | Включить репликацию | `true` |
| `postgresql.replication.user` | Пользователь для репликации | `repl_user` |
| `postgresql.replication.password` | Пароль для репликации | `""` (генерируется случайно) |
| `postgresql.replication.synchronousCommit` | Режим синхронного коммита | `on` |
| `postgresql.replication.numSynchronousReplicas` | Количество синхронных реплик | `1` |

### Хранилище

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `persistence.enabled` | Включить постоянное хранилище | `true` |
| `persistence.storageClass` | Класс хранилища | `""` |
| `persistence.accessMode` | Режим доступа к хранилищу | `ReadWriteOnce` |
| `persistence.size` | Размер хранилища | `8Gi` |

### Сервис

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `service.type` | Тип сервиса Kubernetes | `ClusterIP` |
| `service.port` | Порт сервиса | `5432` |

## Примеры использования

### Базовая установка

```yaml
# values.yaml
replicaCount: 3
postgresql:
  username: myapp
  password: mypassword
  database: myapp_db
```

### Настройка репликации

```yaml
# values.yaml
replicaCount: 5
postgresql:
  replication:
    numSynchronousReplicas: 2
```

### Настройка хранилища

```yaml
# values.yaml
persistence:
  storageClass: "standard"
  size: 20Gi
```

## Безопасность

Для повышения безопасности рекомендуется:

1. Использовать `existingSecret` для паролей в production
2. Настроить сетевые политики для ограничения доступа к базе данных

## Устранение неполадок

### Проверка состояния

```bash
# Проверка состояния подов
kubectl get pods -l app.kubernetes.io/instance=postgresql-beta

# Просмотр логов
kubectl logs -l app.kubernetes.io/instance=postgresql-beta -c postgresql

# Проверка статуса репликации
kubectl exec -it postgresql-beta-0 -- psql -U postgres -c "SELECT * FROM pg_stat_replication;"
```

### Частые проблемы

1. **Проблемы с хранилищем**: Убедитесь, что PVC создан и привязан к поду
2. **Проблемы с репликацией**: Проверьте логи на наличие ошибок репликации

## Ограничения

- Автоматическое масштабирование не поддерживается в этой версии
- Отсутствует встроенная поддержка резервного копирования
- Отсутствует интеграция с внешними системами управления секретами

## Лицензия

Copyright © 2023

Licensed under the Apache License, Version 2.0 