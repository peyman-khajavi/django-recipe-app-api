FROM python:3.10-alpine3.18
LABEL maintainer="peymankhajavi.com"


RUN apk update && apk upgrade

ENV PYTHONUNBUFFERED 1


COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt ./tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r /tmp/requirements.txt \
    && if [ "$DEV" = "true" ]; then /opt/venv/bin/pip install -r /tmp/requirements.dev.txt; fi \
    && rm -rf /tmp \
    && adduser -D django-user

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
 
USER django-user    

