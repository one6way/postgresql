# PostgreSQL для Kubernetes

Этот проект содержит Helm чарт для развертывания отказоустойчивого кластера PostgreSQL в Kubernetes с репликацией.

## Содержимое проекта

- `postgresql-chart/` - Helm чарт для PostgreSQL
  - `templates/` - Шаблоны Kubernetes ресурсов
  - `values.yaml` - Файл значений по умолчанию
  - `Chart.yaml` - Метаданные чарта
  - `README.md` - Документация по чарту

## Быстрый старт

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/yourusername/postgresql-k8s.git
   cd postgresql-k8s
   ```

2. Установите чарт:
   ```bash
   helm install my-postgresql ./postgresql-chart
   ```

3. Проверьте статус:
   ```bash
   kubectl get pods -l app.kubernetes.io/name=postgresql
   ```

## Особенности

- Отказоустойчивая архитектура с репликацией
- Настраиваемые параметры PostgreSQL
- Поддержка синхронной и асинхронной репликации
- Автоматическое резервное копирование с поддержкой S3
- Мониторинг с помощью Prometheus и интеграция с Prometheus Operator
- Постоянное хранилище данных
- Автоматическое масштабирование
- Шифрование данных
- Интеграция с Vault для управления секретами

## Улучшения

В последней версии добавлены следующие улучшения:

1. **Автоматическое масштабирование** - Поддержка HorizontalPodAutoscaler для автоматического масштабирования на основе использования CPU и памяти.
2. **Улучшенное резервное копирование** - Поддержка резервного копирования в S3, мониторинг использования диска, улучшенная ротация резервных копий.
3. **Шифрование данных** - Поддержка шифрования данных PostgreSQL для повышения безопасности.
4. **Интеграция с Vault** - Поддержка интеграции с HashiCorp Vault для управления секретами.
5. **Расширенный мониторинг** - Интеграция с Prometheus Operator через ServiceMonitor.

## Документация

Подробная документация доступна в [README.md](postgresql-chart/README.md) Helm чарта.

## Образ Docker

В этом проекте используется официальный образ PostgreSQL:
- Репозиторий: `postgres`
- Тег: `15.4`

## Примеры конфигураций

- [Базовая конфигурация](postgresql-chart/values.yaml)
- [Тестовое окружение](postgresql-chart/values/test-values.yaml)
- [Продакшн окружение](postgresql-chart/values/production-values.yaml)
- [Продакшн окружение с улучшениями](postgresql-chart/values/production-values-enhanced.yaml)

## Лицензия

MIT
