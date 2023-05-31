# CG7

## Steps to Reproduce on A Linux O.S. with Docker Installed

This was tested on an Ubuntu 20.04 instance on AWS. If you need steps to install docker on it, check [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04). Also, dont forget to allow port 8000 from everywhere in your security group's inbound rule. THIS IS JUST FOR TESTING.

1. Build the application image using a python base image (as in the Dockerfile).
2. Instal git and clone the [conduit django fullstack project](https://github.com/danjac/realworld) in Dockerfile.
3. Build the image using `docker build -t image_name .`
4. Run the image inside a container and map it to the application port using `docker run -t -p 8000:8000 --name app -d image_name`, the application should start automatically 
5. If you're running this on the cloud, the steps are a bit different:
    - first, get into the `settings.py` file of the cloned repo and edit the `ALLOWED HOSTS` using `vi settings.py`, put the IP address of the server in quotes e.g. ['4.232.43.5'], save, quit, and exit the editor.
    - secondly, build the image using `docker build -t image_name .` and then run it in a container using `docker run -t -p 8000:8000 --name app -d image_name`.
6. To view the app locally, input the link https://localhost:8000/ in your browser. On the cloud just paste https://instance_public_IP:8000/ in your browser.

> Dockerfile

```Dockerfile
# pull the python image as our base image
FROM python:3.10-alpine

# install git
RUN apk add git

# clone the project repository
RUN git clone https://github.com/danjac/realworld.git

# set the working directory to the project directory
WORKDIR /realworld

# create a virtual environment
RUN python -m venv venv

# activate the virtual environment
RUN /bin/sh -c "source venv/bin/activate && pip install -r requirements.txt"

# install the project dependencies
RUN pip install -r requirements.txt

# expose the port 8000
EXPOSE 8000

# Copy the entrypoint script
COPY entrypoint.sh /realworld/entrypoint.sh

# Give execute permissions to the entrypoint script
RUN chmod +x /realworld/entrypoint.sh

# Create entrypoint for the application
ENTRYPOINT ["/realworld/entrypoint.sh"]
```

> entrypoint.sh

```SHELL
#!/bin/sh
source venv/bin/activate
./manage.py migrate
./manage.py runserver 0.0.0.0:8000
```