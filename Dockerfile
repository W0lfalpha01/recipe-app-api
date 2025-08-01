FROM python:3.9-alpine3.13
LABEL maintainer="stevedeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN adduser \
            --disabled-password \
            --no-create-home \
            django-user &&\
    python -m venv /py &&\
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
       /py/bin/pip install -r /tmp/requirements.dev.txt ;\
    fi && \
    chown -R django-user:django-user /py && \
    rm -f /tmp/requirements.txt /tmp/requirements.dev.txt \
    apk del .tmp-build-deps


ENV PATH="/py/bin:$PATH"

USER django-user


