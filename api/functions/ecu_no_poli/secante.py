import math

def secante(f, x0, x1):
    tolerancia = 1e-6
    max_iter = 50

    for i in range(max_iter):
        f_x0 = f(x0)
        f_x1 = f(x1)

        if f_x1 - f_x0 == 0:
            raise ZeroDivisionError("División por cero: f(x1) - f(x0) = 0")

        # Fórmula del método de la secante
        x2 = x1 - f_x1 * (x1 - x0) / (f_x1 - f_x0)

        if abs(x2 - x1) < tolerancia:
            return x2, i + 1

        # Avanzamos los puntos para la siguiente iteración
        x0, x1 = x1, x2

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

def result(funcion_entrada, x0, x1):
    funcion_eval = evaluar_fx(funcion_entrada)
    if funcion_eval:
        raiz, iteraciones = secante(funcion_eval, x0, x1)
        return raiz, iteraciones
    else:
        return None, 0
