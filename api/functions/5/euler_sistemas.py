import math

def evaluar_expresion(expr):
    if isinstance(expr, (int, float)):
        return expr
    try:
        return eval(expr, {"__builtins__": None}, math.__dict__)
    except Exception as e:
        raise ValueError(f"Error al evaluar '{expr}': {e}")

def crear_sistema_funciones(ecuaciones_strs):
    funciones = []
    for eq_str in ecuaciones_strs:
        def f(t, vars, eq=eq_str):
            contexto = {**math.__dict__, "t": t}
            contexto.update({f"y{i}": val for i, val in enumerate(vars)})
            return eval(eq, {"__builtins__": None}, contexto)
        funciones.append(f)
    return funciones

def euler_sistemas(ecuaciones_strs, t0_str, y0_strs, h, n):
    t = evaluar_expresion(t0_str)
    y = [evaluar_expresion(val) for val in y0_strs]
    fs = crear_sistema_funciones(ecuaciones_strs)

    for _ in range(n):
        y = [yi + h * fi(t, y) for yi, fi in zip(y, fs)]
        t += h

    return y

def result(ecuaciones_strs, t0, y0_list, h, n):
    try:
        return euler_sistemas(ecuaciones_strs, t0, y0_list, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None
