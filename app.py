from flask import Flask, jsonify

app = Flask(__name__)

# Rota principal
@app.route('/')
def home():
    return "API is running :) :)"

# Rota de health check
@app.route('/health')
def health():
    return jsonify(status="healthy"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
