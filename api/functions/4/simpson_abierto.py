import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_funcion(func_str):
    def f(x):
        return eval(func_str, {"__builtins__": None}, {**math.__dict__, "x": x})
    return f

def simpson_abierto(func_str, a_str, b_str):
    a = evaluar_expresion(a_str)
    b = evaluar_expresion(b_str)

    f = crear_funcion(func_str)
    
    h = (b - a) / 4
    x1 = a + h
    x2 = a + 2 * h
    x3 = a + 3 * h

    integral = (4 * h / 3) * (2 * f(x1) - f(x2) + 2 * f(x3))
    return integral

def result(func_str, a, b):
    try:
        return simpson_abierto(func_str, a, b)
    except Exception as e:
        print(f"Error: {e}")
        return None