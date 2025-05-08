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

def regla_simpson_38(funcion_str, a, b):
    a_val = evaluar_expresion(a)
    b_val = evaluar_expresion(b)
    funcion = crear_funcion(funcion_str)

    f_a = funcion(a_val)
    f_b = funcion(b_val)
    f_1 = funcion(a_val + (b_val - a_val) / 3)
    f_2 = funcion(a_val + 2 * (b_val - a_val) / 3)

    integral = (b_val - a_val) / 8 * (f_a + 3 * f_1 + 3 * f_2 + f_b)
    return integral

def result(funcion_str, a, b):
    try:
        integral = regla_simpson_38(funcion_str, a, b)
        return integral
    except Exception as e:
        print(f"Error: {e}")
        return None
