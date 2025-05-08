import math

def biseccion(f, a, b):
    tolerancia = 1e-6
    max_iter = 50

    if f(a) * f(b) >= 0:
        raise ValueError("El intervalo no es válido: f(a) y f(b) deben tener signos opuestos")

    for i in range(max_iter):
        c = (a + b) / 2.0
        if abs(f(c)) < tolerancia or (b - a)/2 < tolerancia:
            return c, i+1

        if f(a) * f(c) < 0:
            b = c
        else:
            a = c

    raise ValueError("El método no convergió en el número máximo de iteraciones")

def evaluar_fx(funcion_entrada):
    try:
        contexto = {
            name: getattr(math, name)
            for name in dir(math)
            if not name.startswith("__")
        }

        def funcion_evaluadora(x):
            local_context = contexto.copy()
            local_context["x"] = x
            return eval(funcion_entrada, local_context)

        return funcion_evaluadora

    except (NameError, TypeError, SyntaxError, AttributeError) as e:
        print(f"Error al compilar la función '{funcion_entrada}': {e}")
        return None

def result(funcion_entrada, a, b):
    funcion_eval = evaluar_fx(funcion_entrada)
    if funcion_eval:
        raiz, iteraciones = biseccion(funcion_eval, a, b)
        return raiz, iteraciones
    else:
        return None, 0