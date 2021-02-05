#!/bin/sh
gunicorn --workers 3 --bind 0.0.0.0:9090 run:app 