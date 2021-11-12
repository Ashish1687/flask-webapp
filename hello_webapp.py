# File name: hello_webapp.py
from flask import Flask # include the flask library

app = Flask(__name__)

@app.route("/")
def index():
   return "Hello, World!"

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=5000, debug=True) # application will start listening for web request on port 5000
