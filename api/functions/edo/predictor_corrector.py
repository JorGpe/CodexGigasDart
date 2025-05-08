import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_funcion_ecuacion(ecuacion_str):
    def f(t, y):
        return eval(ecuacion_str, {"__builtins__": None}, {**math.__dict__, "t": t, "y": y})
    return f

def predictor_corrector_m0(ecuacion_str, t0_str, y0_str, h, n):
    t0 = evaluar_expresion(t0_str)
    y0 = evaluar_expresion(y0_str)
    f = crear_funcion_ecuacion(ecuacion_str)

    t = t0
    y = y0

    for _ in range(n):
        y_pred = y + h * f(t, y)

        y = y + h / 2 * (f(t, y) + f(t + h, y_pred))

        t += h

    return y

def result(ecuacion_str, t0, y0, h, n):
    try:
        return predictor_corrector_m0(ecuacion_str, t0, y0, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None