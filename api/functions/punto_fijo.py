import math

def punto_fijo(g, valor_inicial):
    tolerancia = 1e-6
    max_iter = 50
    x = valor_inicial
    for i in range(max_iter):
        # print(i)
        # Calculamos el siguiente valor de x
        x_next = g(x) 
        # Verificamos si la diferencia entre iteraciones es menor que la tolerancia
        if abs(x_next - x) < tolerancia:
            # Si se cumple, retornamos la raíz aproximada y el número de iteraciones
            return x_next, i+1
        # Actualizamos x para la siguiente iteración
        x = x_next
    raise ValueError("El método no convergió en el número máximo de iteraciones")

def evaluar_fx(funcion_entrada):
    try:
        # Incluir todas las funciones matemáticas disponibles en el contexto
        contexto = {func: getattr(math, func) for func in dir(math) if callable(getattr(math, func))}

        def funcion_evaluadora(x):
            local_context = contexto.copy()
            local_context["x"] = x
            return eval(funcion_entrada, local_context)

        return funcion_evaluadora
    
    except (NameError, TypeError, SyntaxError, AttributeError) as e:
        print(f"Error al compilar la función '{funcion_entrada}': {e}")
        return None

def result(funcion_entrada, valor_inicial):
    funcion_eval = evaluar_fx(funcion_entrada)
    if funcion_eval:
        raiz, iteraciones = punto_fijo(funcion_eval, valor_inicial)
        return raiz, iteraciones
    else:
        return None, 0  # O algún valor indicando error
