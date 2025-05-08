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

def regla_simpson(funcion_str, a, b):
    a_val = evaluar_expresion(a)
    b_val = evaluar_expresion(b)
    funcion = crear_funcion(funcion_str)
    f_a = funcion(a_val)
    f_b = funcion(b_val)
    f_mid = funcion((a_val + b_val) / 2)
    integral = (b_val - a_val) / 6 * (f_a + 4 * f_mid + f_b)
    return integral

def result(funcion_str, a, b):
    try:
        integral = regla_simpson(funcion_str, a, b)
        return integral
    except Exception as e:
        print(f"Error: {e}")
        return None