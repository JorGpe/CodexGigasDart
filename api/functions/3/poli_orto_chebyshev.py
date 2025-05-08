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

def chebyshev_integracion(func_str, a_str, b_str, n):
    a = evaluar_expresion(a_str)
    b = evaluar_expresion(b_str)
    f = crear_funcion(func_str)

    suma = 0
    for k in range(1, n + 1):
        tk = math.cos((2 * k - 1) * math.pi / (2 * n))
        xk = ((b - a) / 2) * tk + ((b + a) / 2)
        suma += f(xk)

    integral = (math.pi / n) * suma * ((b - a) / 2)
    return integral

def result(func_str, a_str, b_str, n):
    try:
        return chebyshev_integracion(func_str, a_str, b_str, n)
    except Exception as e:
        print(f"Error: {e}")
        return None
