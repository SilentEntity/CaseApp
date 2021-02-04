FROM python:3.7.3-slim
COPY requirements.txt /
COPY run.py /
COPY apps /
RUN pip3 install -r /requirements.txt
WORKDIR /
EXPOSE 9090
ENTRYPOINT ["gunicorn --workers 3 --bind 0.0.0.0:9090 run:app"]