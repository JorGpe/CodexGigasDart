import math

def punto_fijo(g, valor_inicial):
    tolerancia = 1e-6
    max_iter = 50
    x = valor_inicial

    for i in range(max_iter):
        x_next = g(x)

        if abs(x_next - x) < tolerancia:
            return x_next, i + 1

        x = x_next

    raise ValueError("El método no convergió en el número máximo de iteraciones")

def evaluar_gx(funcion_entrada):
    try:
        contexto = {
            name: getattr(math, name)
            for name in dir(math)
            if not name.startswith("__")
        }

        def funcion_iteradora(x):
            local_context = contexto.copy()
            local_context["x"] = x
            return eval(funcion_entrada, local_context)

        return funcion_iteradora

    except (NameError, TypeError, SyntaxError, AttributeError) as e:
        print(f"Error al compilar la función g(x): {e}")
        return None

def result(funcion_g, valor_inicial):
    funcion_iteradora = evaluar_gx(funcion_g)
    if funcion_iteradora:
        raiz, iteraciones = punto_fijo(funcion_iteradora, valor_inicial)
        return raiz, iteraciones
    else:
        return None, 0


