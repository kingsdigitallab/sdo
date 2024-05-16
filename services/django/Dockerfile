FROM python:${PYTHON_VERSION:-3.12-slim}

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
  # dependencies for building Python packages
  && apt-get install -y build-essential \
  # curl for node
  # && apt-get install -y curl \
  # psycopg2 dependencies
  && apt-get install -y libpq-dev
# ldap dependencies
# && apt-get install -y libldap2-dev libsasl2-dev ldap-utils \
# lxml depedndencies
# && apt-get install -y libxml2-dev libxslt-dev python-dev \
# && apt-get install -y python3-lxml \
# gdal libraries
# && apt-get install -y binutils libproj-dev gdal-bin

COPY ../volumes/django/requirements.txt /requirements/
RUN pip install -U pip \
  && pip install -r /requirements/requirements.txt

COPY ../services/django/entrypoint /entrypoint
RUN sed -i 's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

WORKDIR /app

ENTRYPOINT ["/entrypoint"]