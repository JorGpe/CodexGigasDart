from flask import Flask, jsonify, request
from flask_cors import CORS

from functions.ecu_no_poli import biseccion
from functions.ecu_no_poli import regla_falsa
from functions.ecu_no_poli import secante
from functions.ecu_no_poli import newton_raphson
from functions.ecu_no_poli import punto_fijo
from functions.ecu_no_poli import newton_raphson_ecu_no_lineales
from functions.ecu_no_poli import punto_fijo_ecu_no_lineales
from functions.ecu_poli import bairstow
from functions.ecu_poli import newton
from functions.inter_poli import vandermode
from functions.inter_poli import interpolacion_newton
from functions.inter_poli import interpolacion_lagrange
from functions.inter_poli import minimos_cuadrados
from functions.inter_poli import poli_orto_chebyshev
from functions.integracion import trapecio
from functions.integracion import simpson
from functions.integracion import simpson38
from functions.integracion import punto_medio
from functions.integracion import trapecio_abierto
from functions.integracion import simpson_abierto
from functions.integracion import integracion_romberg
from functions.integracion import gauss_legendre_n2
from functions.integracion import gauss_legendre_n3
from functions.edo import euler
from functions.edo import euler_cauchy
from functions.edo import runge_kutta_euler_modificado
from functions.edo import runge_kutta_heun
from functions.edo import predictor_corrector
from functions.edo import euler_sistemas
from functions.edo import euler_cauchy_sistemas
from functions.edo import runge_kutta_euler_modificado_sistemas
from functions.edo import runge_kutta_heun_sistemas

app = Flask(__name__)
CORS(app) # This will enable CORS for all routes

@app.route('/biseccion', methods=['POST'])
def run_biseccion():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
       
        return jsonify({"result":  biseccion.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/regla_falsa', methods=['POST'])
def run_regla_falsa():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
       
        return jsonify({"result":  regla_falsa.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/secante', methods=['POST'])
def run_secante():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
       
        return jsonify({"result":  secante.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/newton_raphson', methods=['POST'])
def run_newton_raphson():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_inicial' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_inicial = data['valor_inicial']
 
       
        return jsonify({"result":  newton_raphson.result(funcion_entrada, valor_inicial)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/punto_fijo', methods=['POST'])
def run_punto_fijo():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_inicial' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_inicial = data['valor_inicial']
 
       
        return jsonify({"result":  punto_fijo.result(funcion_entrada, valor_inicial)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/newton_raphson_ecu_no_lineales', methods=['POST'])
def run_newton_raphson_ecu_no_lineales():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'string_variables' not in data or 'lista_x' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        string_variables = data['string_variables']
        lista_x = data['lista_x']
 
        return jsonify({"result":  newton_raphson_ecu_no_lineales.result(lista_funciones,string_variables,lista_x)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/punto_fijo_ecu_no_lineales', methods=['POST'])
def run_punto_fijo_ecu_no_lineales():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'string_variables' not in data or 'lista_x' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        string_variables = data['string_variables']
        lista_x = data['lista_x']
 
        return jsonify({"result":  punto_fijo_ecu_no_lineales.result(lista_funciones,string_variables,lista_x)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/bairstow', methods=['POST'])
def run_bairstow():
    try:
        data = request.get_json()
        if not data or 'lista_valores' not in data or 'valor_r' not in data or 'valor_s' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_valores = data['lista_valores']
        valor_r = data['valor_r']
        valor_s = data['valor_s']
 
        return jsonify({"result":  bairstow.result(lista_valores,valor_r, valor_s)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/newton', methods=['POST'])
def run_newton():
    try:
        data = request.get_json()
        if not data or 'lista_x' not in data or 'lista_y' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_x = data['lista_x']
        lista_y = data['lista_y']
 
        return jsonify({"result":  newton.result(lista_x,lista_y)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/vandermode', methods=['POST'])
def run_vandermode():
    try:
        data = request.get_json()
        if not data or 'lista_x' not in data or 'lista_y' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_x = data['lista_x']
        lista_y = data['lista_y']
 
        return jsonify({"result":  vandermode.result(lista_x,lista_y)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/interpolacion_newton', methods=['POST'])
def run_interpolacion_newton():
    try:
        data = request.get_json()
        if not data or 'lista_x' not in data or 'lista_y' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_x = data['lista_x']
        lista_y = data['lista_y']
 
        return jsonify({"result":  interpolacion_newton.result(lista_x,lista_y)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/interpolacion_lagrange', methods=['POST'])
def run_interpolacion_lagrange():
    try:
        data = request.get_json()
        if not data or 'lista_x' not in data or 'lista_y' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_x = data['lista_x']
        lista_y = data['lista_y']
 
        return jsonify({"result":  interpolacion_lagrange.result(lista_x,lista_y)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/minimos_cuadrados', methods=['POST'])
def run_minimos_cuadrados():
    try:
        data = request.get_json()
        if not data or 'lista_x' not in data or 'lista_y' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_x = data['lista_x']
        lista_y = data['lista_y']
 
        return jsonify({"result":  minimos_cuadrados.result(lista_x,lista_y)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/poli_orto_chebyshev', methods=['POST'])
def run_poli_orto_chebyshev():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
        valor_n = data['valor_n']
 
        return jsonify({"result":  poli_orto_chebyshev.result(funcion_entrada, valor_a, valor_b, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/trapecio', methods=['POST'])
def run_trapecio():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  trapecio.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/simpson', methods=['POST'])
def run_simpson():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  simpson.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/simpson38', methods=['POST'])
def run_simpson38():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  simpson38.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/punto_medio', methods=['POST'])
def run_punto_medio():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  punto_medio.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/trapecio_abierto', methods=['POST'])
def run_trapecio_abierto():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  trapecio_abierto.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/simpson_abierto', methods=['POST'])
def run_simpson_abierto():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  simpson_abierto.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/integracion_romberg', methods=['POST'])
def run_integracion_romberg():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  integracion_romberg.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/gauss_legendre_n2', methods=['POST'])
def run_gauss_legendre_n2():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  gauss_legendre_n2.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/gauss_legendre_n3', methods=['POST'])
def run_gauss_legendre_n3():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_a' not in data or 'valor_b' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_a = data['valor_a']
        valor_b = data['valor_b']
 
        return jsonify({"result":  gauss_legendre_n3.result(funcion_entrada, valor_a, valor_b)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/euler', methods=['POST'])
def run_euler():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_t0' not in data or 'valor_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_t0 = data['valor_t0']
        valor_y0 = data['valor_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  euler.result(funcion_entrada, valor_t0, valor_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/euler_cauchy', methods=['POST'])
def run_euler_cauchy():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_t0' not in data or 'valor_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_t0 = data['valor_t0']
        valor_y0 = data['valor_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  euler_cauchy.result(funcion_entrada, valor_t0, valor_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/runge_kutta_euler_modificado', methods=['POST'])
def run_runge_kutta_euler_modificado():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_t0' not in data or 'valor_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_t0 = data['valor_t0']
        valor_y0 = data['valor_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  runge_kutta_euler_modificado.result(funcion_entrada, valor_t0, valor_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/runge_kutta_heun', methods=['POST'])
def run_runge_kutta_heun():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_t0' not in data or 'valor_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_t0 = data['valor_t0']
        valor_y0 = data['valor_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  runge_kutta_heun.result(funcion_entrada, valor_t0, valor_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/predictor_corrector', methods=['POST'])
def run_predictor_corrector():
    try:
        data = request.get_json()
        if not data or 'funcion_entrada' not in data or 'valor_t0' not in data or 'valor_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        funcion_entrada = data['funcion_entrada']
        valor_t0 = data['valor_t0']
        valor_y0 = data['valor_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  predictor_corrector.result(funcion_entrada, valor_t0, valor_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/euler_sistemas', methods=['POST'])
def run_euler_sistemas():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'valor_t0' not in data or 'lista_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        valor_t0 = data['valor_t0']
        lista_y0 = data['lista_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  euler_sistemas.result(lista_funciones, valor_t0, lista_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/euler_cauchy_sistemas', methods=['POST'])
def run_euler_cauchy_sistemas():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'valor_t0' not in data or 'lista_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        valor_t0 = data['valor_t0']
        lista_y0 = data['lista_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  euler_cauchy_sistemas.result(lista_funciones, valor_t0, lista_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/runge_kutta_euler_modificado_sistemas', methods=['POST'])
def run_runge_kutta_euler_modificado_sistemas():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'valor_t0' not in data or 'lista_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        valor_t0 = data['valor_t0']
        lista_y0 = data['lista_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  runge_kutta_euler_modificado_sistemas.result(lista_funciones, valor_t0, lista_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/runge_kutta_heun_sistemas', methods=['POST'])
def run_runge_kutta_heun_sistemas():
    try:
        data = request.get_json()
        if not data or 'lista_funciones' not in data or 'valor_t0' not in data or 'lista_y0' not in data or 'valor_h' not in data or 'valor_n' not in data:
            return jsonify({"error": "Missing 'length' or 'width' in request body"}), 400

        lista_funciones = data['lista_funciones']
        valor_t0 = data['valor_t0']
        lista_y0 = data['lista_y0']
        valor_h = data['valor_h']
        valor_n = data['valor_n']
 
        return jsonify({"result":  runge_kutta_heun_sistemas.result(lista_funciones, valor_t0, lista_y0, valor_h, valor_n)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=5000, debug=True)

