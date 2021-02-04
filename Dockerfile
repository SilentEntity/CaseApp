FROM python:3.7.3-slim
COPY requirements.txt /
COPY run.py /
COPY Docker_gunicorn_Start.sh /
COPY apps /apps
RUN pip3 install -r /requirements.txt
WORKDIR /
EXPOSE 9090
ENTRYPOINT ["./Docker_gunicorn_Start.sh"]