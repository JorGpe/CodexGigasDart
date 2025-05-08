from flask import Flask, jsonify, request
from flask_cors import CORS

from api.functions.ecu_no_poli import punto_fijo

app = Flask(__name__)
CORS(app) # This will enable CORS for all routes

products = [
    {"name": "Awesome Gadget", "description": "A revolutionary device."},
    {"name": "Super Software", "description": "Boost your productivity."},
    {"name": "Cozy Sweater", "description": "Stay warm and stylish."},
    {"name": "Delicious Coffee Beans", "description": "Start your day right."},
    {"name": "Smart Backpack", "description": "Organize your life on the go."},
]

@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(products)

@app.route('/punto_fijo', methods=['POST'])
def calculate_area():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_inicial' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_inicial = data['valor_inicial']
 
       
        return jsonify({"result":  punto_fijo.result(funcion_entrada, valor_inicial)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)