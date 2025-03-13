#!/bin/bash

# Скрипт для скачивания образа PostgreSQL

# Версия PostgreSQL
PG_VERSION="15.4"

echo "Скачивание образа PostgreSQL версии $PG_VERSION..."
docker pull postgres:$PG_VERSION

echo "Проверка скачанного образа:"
docker images | grep postgres

echo "Информация о образе:"
docker inspect postgres:$PG_VERSION | grep -E '(RepoTags|Architecture|Os|Size)'

echo "Образ PostgreSQL $PG_VERSION успешно скачан и готов к использованию в Kubernetes."
echo "Для использования в Kubernetes убедитесь, что образ доступен в вашем кластере или реестре." 