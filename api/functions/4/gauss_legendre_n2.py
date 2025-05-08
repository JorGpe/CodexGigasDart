import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")
    
def crear_funcion(funcion_str):
    def funcion(x):
        return eval(funcion_str, {"__builtins__": None}, {**math.__dict__, "x": x})
    return funcion

def cuadratura_Gauss_Legendre_N2(funcion_str, a, b):
    a_val = evaluar_expresion(a)
    b_val = evaluar_expresion(b)
    funcion = crear_funcion(funcion_str)

    raiz1 = [-1 / math.sqrt(3), 1 / math.sqrt(3)]
    raiz2 = [1, 1]
    
    puntos = [(0.5 * (b_val - a_val) * raiz + 0.5 * (b_val + a_val)) for raiz in raiz1]

    integral = 0
    for i in range(2):
        integral += raiz2[i] * funcion(puntos[i])
    
    integral *= 0.5 * (b_val - a_val)
    
    return integral

def result(funcion_str, a, b):
    try:
        return cuadratura_Gauss_Legendre_N2(funcion_str, a, b)
    except Exception as e:
        print(f"Error: {e}")
        return None