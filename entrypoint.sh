#!/bin/bash
set -e

export DATABASE_URL="postgis://local_db_user:local_db_pass@db:5432/{{ project_name }}"

python manage.py migrate
python manage.py runserver 0.0.0.0:8000

exec "$@"
