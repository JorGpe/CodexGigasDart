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

def regla_trapecio(funcion, a, b, n):
    h = (b - a) / n
    s = 0.5 * (funcion(a) + funcion(b))
    for i in range(1, n):
        s += funcion(a + i * h)
    return s * h

def romberg(funcion_str, a, b, max_iter=10):
    a_val = evaluar_expresion(a)
    b_val = evaluar_expresion(b)
    funcion = crear_funcion(funcion_str)

    tolerancia = 1e-6
    R = [[0] * (max_iter + 1) for _ in range(max_iter + 1)]

    R[0][0] = regla_trapecio(funcion, a_val, b_val, 1)

    for k in range(1, max_iter + 1):
        n = 2 ** k
        R[k][0] = regla_trapecio(funcion, a_val, b_val, n)

        for j in range(1, k + 1):
            R[k][j] = (4**j * R[k][j - 1] - R[k - 1][j - 1]) / (4**j - 1)

        if abs(R[k][k] - R[k - 1][k - 1]) < tolerancia:
            return R[k][k]

    return R[max_iter][max_iter]

def result(funcion_str, a, b):
    try:
        integral = romberg(funcion_str, a, b)
        return integral
    except Exception as e:
        print(f"Error: {e}")
        return None
