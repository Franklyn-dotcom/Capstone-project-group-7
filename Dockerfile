# pull the python image as our base image
FROM python:3.10-alpine
LABEL maintainer="tuyojr olutuyod@gmail.com"

# install system dependencies
RUN apk add --no-cache mariadb-connector-c-dev musl-dev gcc python3-dev libffi-dev openssl-dev cmake

# copy project files to the working directory
COPY . /realworld

# set the working directory
WORKDIR /realworld

# create a virtual environment
RUN python -m venv venv

# expose the port 8000
EXPOSE 8000

# Give execute permissions to the entrypoint script
RUN chmod +x /realworld/entrypoint.sh

# Create entrypoint for the application
ENTRYPOINT ["/realworld/entrypoint.sh"]
