# PostgreSQL Helm Chart

Этот Helm Chart предназначен для развертывания PostgreSQL в Kubernetes с расширенными возможностями для корпоративного использования.

## Особенности

- **Высокая доступность**: Поддержка репликации и автоматического восстановления
- **Автоматическое масштабирование**: Горизонтальное масштабирование на основе нагрузки
- **Резервное копирование**: Автоматические резервные копии с поддержкой S3
- **Шифрование данных**: Поддержка шифрования данных и SSL-соединений
- **Интеграция с Vault**: Управление секретами через HashiCorp Vault
- **Мониторинг**: Интеграция с Prometheus через ServiceMonitor

## Требования

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner поддержка в кластере (для постоянного хранения данных)
- Для использования S3 бэкапов: доступ к S3-совместимому хранилищу
- Для интеграции с Vault: настроенный HashiCorp Vault

## Установка

```bash
# Добавление репозитория
helm repo add my-repo https://example.com/charts

# Установка с значениями по умолчанию
helm install my-postgresql my-repo/postgresql

# Установка с пользовательскими значениями
helm install my-postgresql my-repo/postgresql -f values.yaml
```

## Конфигурация

### Основные параметры

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
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
| `postgresql.replication.enabled` | Включить репликацию | `false` |
| `postgresql.replication.user` | Пользователь для репликации | `repl_user` |
| `postgresql.replication.password` | Пароль для репликации | `""` (генерируется случайно) |
| `postgresql.replication.slaveReplicas` | Количество реплик | `1` |
| `postgresql.replication.synchronousCommit` | Режим синхронного коммита | `on` |
| `postgresql.replication.numSynchronousReplicas` | Количество синхронных реплик | `1` |

### Хранилище

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `persistence.enabled` | Включить постоянное хранилище | `true` |
| `persistence.storageClass` | Класс хранилища | `""` |
| `persistence.accessMode` | Режим доступа к хранилищу | `ReadWriteOnce` |
| `persistence.size` | Размер хранилища | `8Gi` |

### Автоматическое масштабирование

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `autoscaling.enabled` | Включить автоматическое масштабирование | `false` |
| `autoscaling.minReplicas` | Минимальное количество реплик | `1` |
| `autoscaling.maxReplicas` | Максимальное количество реплик | `3` |
| `autoscaling.targetCPUUtilizationPercentage` | Целевая утилизация CPU | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Целевая утилизация памяти | `80` |

### Резервное копирование

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `backup.enabled` | Включить резервное копирование | `false` |
| `backup.schedule` | Расписание резервного копирования (cron) | `0 1 * * *` |
| `backup.destination.type` | Тип хранилища для резервных копий | `s3` |
| `backup.destination.s3.bucket` | Имя S3 бакета | `""` |
| `backup.destination.s3.region` | Регион S3 | `""` |
| `backup.retention.days` | Количество дней хранения резервных копий | `7` |

### Шифрование данных

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `encryption.enabled` | Включить шифрование данных | `false` |
| `encryption.existingKey` | Существующий ключ шифрования | `""` |
| `encryption.ssl.enabled` | Включить SSL | `false` |
| `encryption.ssl.cert` | SSL сертификат | `""` |
| `encryption.ssl.key` | SSL ключ | `""` |
| `encryption.ssl.ca` | CA сертификат | `""` |
| `encryption.ssl.clientAuth` | Требовать аутентификацию клиента | `false` |

### Интеграция с Vault

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `vault.enabled` | Включить интеграцию с Vault | `false` |
| `vault.secretPath` | Путь к секрету в Vault | `secret/data/postgres` |
| `vault.role` | Роль для доступа к Vault | `postgres-role` |
| `vault.refreshInterval` | Интервал проверки обновлений секретов (сек) | `300` |
| `vault.restartOnSecretChange` | Перезапускать PostgreSQL при изменении секретов | `true` |

### Мониторинг

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| `metrics.enabled` | Включить экспорт метрик | `false` |
| `metrics.serviceMonitor.enabled` | Создать ServiceMonitor для Prometheus | `false` |
| `metrics.serviceMonitor.interval` | Интервал сбора метрик | `30s` |
| `metrics.serviceMonitor.scrapeTimeout` | Таймаут сбора метрик | `10s` |

## Примеры использования

### Базовая установка с репликацией

```yaml
postgresql:
  username: myapp
  password: mypassword
  database: myapp_db
  replication:
    enabled: true
    slaveReplicas: 2
```

### Включение резервного копирования в S3

```yaml
backup:
  enabled: true
  schedule: "0 2 * * *"
  destination:
    type: s3
    s3:
      bucket: my-backups
      region: us-east-1
      accessKeyId: AKIAXXXXXXXXXXXXXXXX
      secretAccessKey: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  retention:
    days: 14
```

### Включение шифрования и SSL

```yaml
encryption:
  enabled: true
  ssl:
    enabled: true
    # Для production рекомендуется предоставить собственные сертификаты
    # Если не указаны, будут сгенерированы самоподписанные
```

### Интеграция с Vault

```yaml
vault:
  enabled: true
  secretPath: secret/data/myapp/postgres
  role: postgres-role
  refreshInterval: 600
```

### Мониторинг с Prometheus

```yaml
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 15s
    additionalLabels:
      release: prometheus
```

## Безопасность

Для повышения безопасности рекомендуется:

1. Всегда использовать `existingSecret` для паролей в production
2. Включить SSL для шифрования соединений
3. Настроить сетевые политики для ограничения доступа к базе данных
4. Использовать интеграцию с Vault для управления секретами

## Устранение неполадок

### Проверка состояния

```bash
# Проверка состояния подов
kubectl get pods -l app.kubernetes.io/instance=my-postgresql

# Просмотр логов
kubectl logs -l app.kubernetes.io/instance=my-postgresql -c postgresql

# Проверка статуса репликации
kubectl exec -it my-postgresql-0 -- psql -U postgres -c "SELECT * FROM pg_stat_replication;"
```

### Частые проблемы

1. **Проблемы с хранилищем**: Убедитесь, что PVC создан и привязан к поду
2. **Проблемы с репликацией**: Проверьте логи на наличие ошибок репликации
3. **Проблемы с бэкапами**: Проверьте доступ к S3 и наличие необходимых прав

## Ограничения

- Автоматическое масштабирование работает только для реплик чтения
- При использовании шифрования данных производительность может снизиться
- Для полноценной интеграции с Vault требуется настроенный Vault Agent Injector

## Лицензия

Copyright © 2023

Licensed under the Apache License, Version 2.0 