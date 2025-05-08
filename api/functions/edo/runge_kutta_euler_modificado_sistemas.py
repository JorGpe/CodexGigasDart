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

def runge_kutta_sistemas(ecuaciones_strs, t0_str, y0_strs, h, n):
    t = evaluar_expresion(t0_str)
    y = [evaluar_expresion(val) for val in y0_strs]
    fs = crear_sistema_funciones(ecuaciones_strs)

    for _ in range(n):
        k1 = [h * fi(t, y) for fi in fs]
        k2 = [h * fi(t + h/2, [yi + k1i/2 for yi, k1i in zip(y, k1)]) for fi in fs]
        k3 = [h * fi(t + h/2, [yi + k2i/2 for yi, k2i in zip(y, k2)]) for fi in fs]
        k4 = [h * fi(t + h, [yi + k3i for yi, k3i in zip(y, k3)]) for fi in fs]

        y = [yi + (k1i + 2*k2i + 2*k3i + k4i)/6 for yi, k1i, k2i, k3i, k4i in zip(y, k1, k2, k3, k4)]
        t += h

    return y

def result(ecuaciones_strs, t0, y0_list, h, n):
    try:
        return runge_kutta_sistemas(ecuaciones_strs, t0, y0_list, h, n)
    except Exception as e:
        print(f"Error: {e}")
        return None