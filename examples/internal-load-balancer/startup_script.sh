#!/bin/bash -xe

apt-get update
apt-get install -yq build-essential python-pip rsync
pip install flask requests

mkdir /app

cat > /app/app.py <<'EOF'
import requests
from flask import Flask
app = Flask(__name__)

@app.route('/nameproxy')
def hello_nameproxy():
   return requests.get('http://${ilb_address}:5000/api').content

@app.route('/ipproxy')
def hello_ipproxy():
   return requests.get('http://${ilb_ip}:5000/api').content

app.run(host='0.0.0.0')
EOF

python /app/app.py &

