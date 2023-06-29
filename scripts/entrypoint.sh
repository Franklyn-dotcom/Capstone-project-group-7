#!/bin/sh
cd /app

python3 app/manage.py makemigrations
python3 app/manage.py migrate 
python3 app/manage.py runserver "0.0.0.0:8000"