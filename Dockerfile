ARG PY_VERSION=3.8
FROM python:$PY_VERSION as backend

ARG POETRY_VERSION=1.1.12
ARG CHANNELS_VERSION
ARG ASGIREF_VERSION
ARG DJANGO_VERSION

ARG POETRY_HOME=/poetry
ARG DJANGO_SECRET_KEY=django-insecure-change*&^this
ARG DEBUG=0
ARG PORT=8999
ARG ASGI=1
ARG GUNICORN_MAX_REQUESTS=0
ARG GUNICORN_MAX_REQUESTS_JITTER=0
ARG GUNICORN_WORKERS=4
ARG GUNICORN_TIMEOUT=20
ARG USE_WHITENOISE=1



ENV PATH=$PATH:${POETRY_HOME}/bin \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/work \
    DJANGO_SETTINGS_MODULE=test_app.settings \
    PORT=$PORT \
    DEBUG=$DEBUG \
    USE_WHITENOISE=$USE_WHITENOISE \
    APPEND_STATICFILES_URLPATTERN=${APPEND_STATICFILES_URLPATTERN} \
    GUNICORN_CMD_ARGS=" \
    --max-requests=$GUNICORN_MAX_REQUESTS \
    --max-requests-jitter=$GUNICORN_MAX_REQUESTS_JITTER \
    --workers $GUNICORN_WORKERS \
    --worker-class=uvicorn.workers.UvicornWorker \
    --error-logfile - \
    --access-logfile - \
    --timeout $GUNICORN_TIMEOUT"

ARG BUILD_ENV

EXPOSE $PORT

RUN useradd test_app

RUN mkdir /work
WORKDIR /work

RUN curl -sSL https://install.python-poetry.org | env POETRY_VERSION=$POETRY_VERSION python -
RUN poetry self --version

RUN poetry config virtualenvs.create false

COPY --chown=test_app pyproject.toml poetry.lock manage.py ./
COPY --chown=test_app . .

RUN poetry install --extras 'gunicorn uvicorn daphne whitenoise'
RUN [ -n "$DJANGO_VERSION" ] && poetry run pip install django==$DJANGO_VERSION || true
RUN [ -n "$ASGIREF_VERSION" ] && poetry run pip install asgiref==$ASGIREF_VERSION || true
RUN [ -n "$CHANNELS_VERSION" ] && poetry run pip install channels==$CHANNELS_VERSION || true

RUN SECRET_KEY=${DJANGO_SECRET_KEY} poetry run ./manage.py collectstatic --noinput

USER test_app

CMD poetry run gunicorn test_app.asgi:application
# CMD poetry run gunicorn test_app.wsgi:application
