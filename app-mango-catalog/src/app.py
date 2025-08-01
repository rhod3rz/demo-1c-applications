from flask import Flask, Response, request
import os
import requests

app = Flask(__name__)

def read_file(file_path):
    try:
        with open(file_path, 'r') as file:
            return file.read().replace("\n", "<br>").replace("\r", "")
    except Exception as ex:
        return f"Could not read {file_path}: {ex}"

def get_public_ip():
    try:
        return requests.get('https://api.ipify.org', timeout=2).text
    except Exception as ex:
        return f"Unavailable: {ex}"

@app.route('/')
def home():
    message = read_file('messageStatic.txt')

    env_message = read_file('messageEnvironment.txt')
    micro_service = os.getenv('RDZ_MICRO_SERVICE', 'Environment Variable Not Set')
    test_secret = os.getenv('RDZ_TEST_SECRET', 'Environment Variable Not Set')
    host_name = os.getenv('HOSTNAME', 'Environment Variable Not Set')
    public_ip = get_public_ip()
    env_message = (
        env_message
        .replace('$RDZ_MICRO_SERVICE', f'[ {micro_service} ]')
        .replace('$RDZ_TEST_SECRET', f'[ {test_secret} ]')
        .replace('$HOSTNAME', f'[ {host_name} ]')
        .replace('$PUBLIC_IP', f'[ {public_ip} ]')
    )

    response_content = f"""
    <html>
        <head>
            <meta charset='UTF-8'>
            <link href='https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&display=swap' rel='stylesheet'>
            <style>
                body {{
                    text-align: center;
                    font-family: 'Open Sans', sans-serif;
                    font-size: 18px;
                    background-color: #F5F5F5;
                }}
            </style>
        </head>
        <body>
            {message}<br><br>{env_message}
        </body>
    </html>
    """
    return Response(response_content, content_type='text/html; charset=UTF-8')

@app.route('/readiness', methods=['GET', 'HEAD'])
def readiness():
    if request.method == 'HEAD':
        return '', 200  # No body for HEAD requests (health probes)
    return 'OK', 200  # Display "OK" for GET requests

@app.route('/liveness', methods=['GET', 'HEAD'])
def liveness():
    if request.method == 'HEAD':
        return '', 200  # No body for HEAD requests
    return 'OK', 200  # Display "OK" for GET requests

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
