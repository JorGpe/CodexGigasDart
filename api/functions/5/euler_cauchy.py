import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_funcion_ed(funcion_str):
    def funcion(t, y):
        return eval(funcion_str, {"__builtins__": None}, {**math.__dict__, "t": t, "y": y})
    return funcion

def euler_cauchy(funcion_str, t0, y0, h, n):
    t = evaluar_expresion(t0)
    y = evaluar_expresion(y0)
    h = evaluar_expresion(h)
    n = int(n)

    funcion = crear_funcion_ed(funcion_str)

    for _ in range(n):
        y_pred = y + h * funcion(t, y)
        y = y + h / 2 * (funcion(t, y) + funcion(t + h, y_pred))
        t += h

    return y

def result(funcion_str, t0, y0, h, n):
    try:
        return euler_cauchy(funcion_str, t0, y0, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None