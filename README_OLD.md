# Containerizing The Real-World Application

The Real-World Application is a reference implementation of a Medium.com clone using different technology stacks. The original implementation is a Node.js application. This repository contains a [Dockerfile](Dockerfile) and [docker-compose.yml](docker-compose.yml) file to build and run the application in a [Docker](https://www.docker.com/) container. The application contained here is a clone of the Django implementation by @danjac with some modifications to use a MySQL database instead of the dbsqlite3 used for development.

The following are required before building and running the application:

1. Docker engine, docker compose and all other docker required applications must be installed on the host machine.
2. The host machine must have internet access to download the required images from docker hub.
3. The host machine must have enough resources to run the application.

To build and run the application:

1. Clone this repository to the host machine `git clone https://github.com/tuyojr/CG7.git` and change directory into the cloned repo.
2. There are a few things to be noted.
    - In the root of the project directory, edit the [.env.example](.env.example) file and create a `.env` file that the MySQL database will use to create the user and database.
    - In the [docker-compose.yml](docker-compose.yml) file, the MySQL database is configured to use the `.env` file created above to create the user and database. The django application depends on this.
    - The [Dockerfile](Dockerfile) is configured to use python as a base image, install the required packages so that our django application can connect to the MySQL container and use it as a database.
    - The [Dockerfile](Dockerfile) also copies the project directory into the container and runs the django application. Exposes the application on port 8000,a nd also sets the entrypoint to run the application.
    - The [entrypoint.sh](entrypoint.sh) file is used to install the project requirements, generate a secret key, run the migrations and start the application.
3. Before going ahead to build the django image and run it in a container, there's a need to edit the [settings.py](settings.py) file in the `/realworld` folder so that it can make use of the MySQL database running inside its container. The details for the MySQL database will be picked from a [var.py](var.py) file. The application also needs to get the secret key generated at entrypoint from the environment variable.

    `settings.py` snippets of places to edit:

    ```PYTHON
    # import the variables from the var.py file in the root directory
    import os

    from realworld.var import MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_PORT, MYSQL_HOST, MYSQL_ROOT_PASSWORD

    # SECURITY WARNING: keep the secret key used in production secret!
    # SECRET_KEY = "django-insecure-f35(x7w#1hz7%oejc(t(x8ii7n^%n0pvzsp@x*qtfh8^$3^3j+"
    SECRET_KEY = os.environ.get('secret_key')

    # Database
    # https://docs.djangoproject.com/en/4.2/ref/settings/#databases

    DATABASES = {
        # "default": {
        #     "ENGINE": "django.db.backends.sqlite3",
        #     "NAME": BASE_DIR / "db.sqlite3",
        # }
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': MYSQL_DATABASE,
            'USER': MYSQL_USER,
            'PASSWORD': MYSQL_PASSWORD,
            'HOST': MYSQL_HOST,
            'PORT': MYSQL_PORT,
            'ROOT_PASSWORD': MYSQL_ROOT_PASSWORD,
            'OPTIONS': {
                'init_command': "SET sql_mode='STRICT_TRANS_TABLES'"
            }
        }
    }
    ```

4. Next, build the django image and running it in a container using `docker compose up -d`.

5. The database is created alongside the django application. Next we may need to rerun certain commands to ensure our application runs smoothly.
    - log into the database container `docker exec container_name /bin/bash`. While in the container:
        a. run `mysql -ppassword -uuser`, drop the created database and create a new one with the same name.
        b. `drop database database_name;`
        c. `create database database_name;`
        d. `use database_name;`
    - log out of the database container and run the entrypoint for the django application `docker exec container_name ./entrypoint.sh`. This will run the migrations and start the application.

6. Lastly, check the application in your browser using https://ip_address:8000. The application should be running.

## Implementation of real-world application using Django and HTMX by Dan Jacob

>[Gothinkster Real-World Application](https://github.com/gothinkster/realworld/)

An in-depth discussion of this implementation can be found [here](https://danjacob.net/posts/anatomyofdjangohtmxproject/).

Tech Stack:

- [Django](https://djangoproject.com)
- [HTMX](https://htmx.org)
- [Alpine](https://alpinejs.dev)

To install and run locally:

```bash
git clone https://github.com/danjac/realworld/ && cd realworld

python -m venv venv

source venv/bin/activate

pip install -r requirements.txt

./manage.py migrate && ./manage.py runserver
```

**Note: this is just a reference implementation and is not intended for production use.**
