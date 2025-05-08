import math

def evaluar_funciones_g(g_strs, variables_str):
    variables = variables_str.split()
    contexto = {k: getattr(math, k) for k in dir(math) if not k.startswith("__")}

    def crear_funcion(expr):
        def f(*args):
            local_context = contexto.copy()
            for var, val in zip(variables, args):
                local_context[var] = val
            return eval(expr, local_context)
        return f

    funciones = [crear_funcion(expr) for expr in g_strs]
    return funciones

def punto_fijo_sistema(g_funcs, valores_iniciales, tolerancia=1e-6, max_iter=50):
    n = len(valores_iniciales)
    x = list(valores_iniciales)

    for it in range(max_iter):
        x_nuevo = [g(*x) for g in g_funcs]

        diferencias = [abs(x_nuevo[i] - x[i]) for i in range(n)]
        if all(d < tolerancia for d in diferencias):
            return x_nuevo, it + 1

        x = x_nuevo

    raise ValueError("El método no convergió en el número máximo de iteraciones")

def result(g_strs, variables_str, valores_iniciales):
    try:
        g_funcs = evaluar_funciones_g(g_strs, variables_str)
        solucion, iteraciones = punto_fijo_sistema(g_funcs, valores_iniciales)
        return solucion, iteraciones
    except Exception as e:
        print(f"Error: {e}")
        return None, 0
