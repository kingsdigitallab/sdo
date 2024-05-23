FROM node:16-bookworm-slim as node-builder

ARG APP_HOME=/app
WORKDIR ${APP_HOME}

COPY ../django/package.json ${APP_HOME}

RUN npm install && npm cache clean --force

FROM python:3.9-slim-bookworm

ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
    # dependencies for building Python packages
    && apt-get install -y build-essential \
    # psycopg2 dependencies
    libpq-dev \
    # ldap dependencies
    libldap2-dev libsasl2-dev ldap-utils \
    # lxml depedndencies
    libxml2-dev libxslt-dev python3-dev python3-lxml \
    # gdal libraries
    binutils libproj-dev gdal-bin \
    # cleaning up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY ../django/requirements.txt /requirements/
RUN pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir -r /requirements/requirements.txt

COPY --from=node-builder ${APP_HOME}/node_modules ${APP_HOME}/node_modules

COPY ../services/django/entrypoint /entrypoint
RUN sed -i 's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

WORKDIR ${APP_HOME}

ENTRYPOINT ["/entrypoint"]
