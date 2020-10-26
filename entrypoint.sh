#!/bin/bash
set -e

export DATABASE_URL="postgis://local_db_user:local_db_pass@db:5432/local_db_test"

python manage.py migrate
python manage.py runserver 0.0.0.0:8000

exec "$@"
