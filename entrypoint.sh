#!/bin/sh
source venv/bin/activate
export PYTHONPATH=$PYTHONPATH:$(pwd)
pip install -r requirements.txt
secret_key=$(python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
export secret_key=$secret_key
./manage.py migrate
./manage.py runserver 0.0.0.0:8000
