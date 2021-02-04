This a Sample Flask App 
To run the App :
$python3 run.py

FROM docker container :
$export FLASK_APP=run.py
$flask run --host=0.0.0.0

File Structure 
.
├── apps
│   ├── app
│   │   ├── case_home
│   │   │   ├── controllers.py
│   │   │   ├── __init__.py                      
│   │   │   └── models.py                        
│   │   ├── __init__.py
│   │   ├── settings.cfg
│   │   ├── static
│   │   └── templates
│   │       └── case_home
│   │           └── index.html
│   ├── __init__.py
│   └── main.py
├── CHANGES.txt
├── config.py
├── MANIFEST.in
├── README.txt
├── run.py
└── setup.py

For generating the caseapp package
$python3 setup.py sdist bdist_wheel

For Uploading to pypi repo
$twine upload dist/* --repository-url http://<url>/repository/<repo_name>/ -u <username> -p <password>

For installing the package
$pip3 install caseapp==0.1.0 --index-url http://<username>:<password>@<url>/repository/<repo_name>/simple --trusted-host <url> --extra-index-url https://pypi.python.org/pypi --no-cache-dir

For running from CLI after package installed in environment
$caseapp Run
or
For running in background
$nohup caseapp Run >> app_out_logs.txt &

For WSGI Gunicorn Server
cat /etc/systemd/system/CaseApp.service
=============================================================================================================
[Unit]
Description=Gunicorn instance to serve CaseApp
After=network.target

[Service]
User=vagrant
Group=www-data
WorkingDirectory=/home/$USER/<path_to_Code>/CaseApp
Environment="PATH=/home/$USER/<path to environment>/bin"
ExecStart=/home/$USER/<path to environment>/bin/gunicorn --workers 3 --bind unix:CaseApp.sock -m 007 run:app

[Install]
WantedBy=multi-user.target
=============================================================================================================
sudo systemctl start CaseApp.service
sudo systemctl enable CaseApp.service

=======For Nginx=====
cat /etc/nginx/sites-available/CaseApp
server {
    listen 80;
    server_name 172.31.0.200;

    location = /favicon.ico { access_log off; log_not_found off; }
    location / {
        include proxy_params;
        proxy_pass http://unix:<path_to_socket>/CaseApp.sock;
    }
}
Enable the site Nginx
sudo ln -s /etc/nginx/sites-available/CaseApp /etc/nginx/sites-enabled
ufw allow 'Nginx Full'