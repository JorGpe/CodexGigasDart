import math
import sympy as sp

def newton_raphson(f_str, x0):
    tolerancia = 1e-6
    max_iter = 50

    x = sp.symbols('x')
    try:
        f_expr = sp.sympify(f_str, locals={"pi": sp.pi, "e": sp.E})
        f_deriv_expr = sp.diff(f_expr, x)

        f = sp.lambdify(x, f_expr, modules=["math"])
        f_deriv = sp.lambdify(x, f_deriv_expr, modules=["math"])

        for i in range(max_iter):
            f_x = f(x0)
            f_prime_x = f_deriv(x0)

            if f_prime_x == 0:
                raise ZeroDivisionError("Derivada cero. No se puede continuar.")

            x1 = x0 - f_x / f_prime_x

            if abs(x1 - x0) < tolerancia:
                return x1, i + 1

            x0 = x1

        raise ValueError("El método no convergió en el número máximo de iteraciones")

    except Exception as e:
        print(f"Error evaluando la función o su derivada: {e}")
        return None, 0

def result(funcion_entrada, valor_inicial):
    raiz, iteraciones = newton_raphson(funcion_entrada, valor_inicial)
    return raiz, iteraciones
