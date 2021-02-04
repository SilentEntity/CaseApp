import os
import pytest
from flask import Flask
# This check if flask is working ?
@pytest.fixture
def client():
    """A test client for the flask app."""
    app = Flask(__name__,instance_relative_config=True)

    @app.route("/working")
    def working():
        return "flask is working"
    
    return app.test_client()