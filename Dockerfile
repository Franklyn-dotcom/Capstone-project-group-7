# pull the python image as our base image
FROM python:3.10-alpine
ENV PYTHONUNBUFFERED 1
LABEL maintainer="tuyojr olutuyod@gmail.com"

# install system dependencies
RUN pip install --upgrade pip
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev

RUN apk del .tmp-build-deps

# copy project files to the working directory
COPY ./app /app

COPY ./scripts /scripts

RUN chmod +x /scripts/*

# set the working directory
WORKDIR /app

# create a virtual environment
RUN python3 -m venv venv

# install the project dependencies
RUN pip install -r requirements.txt

# expose the port 8000
EXPOSE 8000


# Create entrypoint for the application
ENTRYPOINT ["/scripts/entrypoint.sh"]
