import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_funcion_ed(f_str):
    def f(t, y):
        return eval(f_str, {"__builtins__": None}, {**math.__dict__, "t": t, "y": y})
    return f

def metodo_euler(f_str, t0, y0, h, n):
    t0_val = evaluar_expresion(t0)
    y0_val = evaluar_expresion(y0)
    h_val = evaluar_expresion(h)
    n_val = int(n)

    f = crear_funcion_ed(f_str)
    t, y = t0_val, y0_val
    
    for _ in range(n_val):
        y += h_val * f(t, y)
        t += h_val

    return y

def result(f_str, t0, y0, h, n):
    try:
        return metodo_euler(f_str, t0, y0, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None