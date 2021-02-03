# Run the server from CLI.
from apps.app import app
import sys


def app_cli():
    args = sys.argv[1:]
    if len(args) < 1:
        print("Usage : \n - Run - to Start the App \n")
        return
    if str(args[0]).lower() == "run":
        app.run(debug=False, host="0.0.0.0")
    else:
        print("Usage : \n - Run - to Start the App \n")
