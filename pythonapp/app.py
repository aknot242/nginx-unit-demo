from flask import Flask
app = Flask(__name__)
application = app


@app.route('/')
def hello_world():
    return 'From Python Flask: Hello, World!'
