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
ENTRYPOINT ["/realworld