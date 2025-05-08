import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_funcion(funcion_str):
    def funcion(t, y):
        return eval(funcion_str, {"__builtins__": None}, {**math.__dict__, "t": t, "y": y})
    return funcion

def runge_kutta_orden2(funcion_str, t0, y0, h, n):
    t = evaluar_expresion(t0)
    y = evaluar_expresion(y0)
    funcion = crear_funcion(funcion_str)

    for _ in range(n):
        k1 = funcion(t, y)
        k2 = funcion(t + h, y + h * k1)
        y += (h / 2) * (k1 + k2)
        t += h

    return y

def result(funcion_str, t0, y0, h, n):
    try:
        return runge_kutta_orden2(funcion_str, t0, y0, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None