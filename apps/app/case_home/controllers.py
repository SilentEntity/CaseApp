from flask import Blueprint, request, render_template

case_home = Blueprint("home", __name__, url_prefix="/")

@case_home.route("/")
def index():
    return render_template("case_home/index.html")
