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

def regla_trapecio_abierto(funcion_str, a, b, h=0.1):
    a_val = evaluar_expresion(a)
    b_val = evaluar_expresion(b)
    h_val = evaluar_expresion(h)

    funcion = crear_funcion(funcion_str)

    f_a_h = funcion(a_val + h_val)
    f_b_h = funcion(b_val - h_val)

    integral = (b_val - a_val) * (f_a_h + f_b_h) / 2
    return integral

def result(funcion_str, a, b, h=0.1):
    try:
        integral = regla_trapecio_abierto(funcion_str, a, b, h)
        return integral
    except Exception as e:
        print(f"Error: {e}")
        return None
