from flask import Flask, render_template
import os
import pathlib
app = Flask(__name__)
try:
    os.environ['FLASK_SETTINGS'] = '{}/settings.cfg'.format(pathlib.Path(__file__).parent.absolute())
    app.config.from_envvar('FLASK_SETTINGS')
except Exception as e:
    print("FLASK_SETTINGS environment variable is not set")

try:
    # When it is running from run.py
    from apps.app.case_home.controllers import case_home
except Exception as e:
    # When it is running from cli caseapp
    from app.case_home.controllers import case_home

app.register_blueprint(case_home)
