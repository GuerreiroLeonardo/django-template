format:
	@black . --exclude="node_modules"

lint:
	@autoflake -i -r --remove-all-unused-imports --remove-unused-variables --ignore-init-module-imports .
	@isort -rc --atomic --multi-line=3 --trailing-comma --force-grid-wrap=0 --use-parentheses --line-width=88 .

run:
	@python manage.py runserver

run-local:
	@env SECURE_SSL_REDIRECT=False DEBUG=True STATIC_URL="/static/" STATICFILES_STORAGE="django.contrib.staticfiles.storage.StaticFilesStorage" make run

migrate:
	@python manage.py migrate

collecstatic:
	@python manage.py collectstatic --no-input

setup:
	@poetry install && poetry shell

test:
	@pytest

test-coverage:
	@coverage erase && coverage run -m pytest && coverage report

test-watcher:
	@ptw

snapshot-update:
	@python manage.py test $(module) --keepdb --snapshot-update

update-pre-commit:
	@pre-commit install

services:
	@docker-compose up -d

al_reindex:
	@python manage.py algolia_clearindex $(model) && python manage.py algolia_reindex $(model) && python manage.py algolia_applysettings $(model)

workers:
	@REMAP_SIGTERM=SIGQUIT celery -A super worker -l info --autoscale=75,10 --concurrency=75 -P gevent

celery-web:
	@celery flower --broker=`heroku config:get CLOUDAMQP_CRIMSON_URL -a appsuperapi`

code-climate:
	@docker run  --interactive --tty --rm  --env CODECLIMATE_CODE="$PWD"  --volume "$PWD":/code  --volume /var/run/docker.sock:/var/run/docker.sock  --volume /tmp/cc:/tmp/cc  codeclimate/codeclimate analyze -f html > cc.html
