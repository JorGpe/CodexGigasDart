import math
import numpy as np

def runge_kutta_orden2(f, x0, y0, h, n):

    x, y = x0, y0
    for i in range(n):
        # Calcular k1 usando la función f en el punto actual (x, y)
        k1 = f(x, y)
        # Calcular k2 usando la función f en el punto (x + h, y + h * k1)
        k2 = f(x + h, y + h * k1)
        # Actualizar el valor de y usando la fórmula del método de Runge-Kutta de orden 2
        y = y + (h / 2) * (k1 + k2)
        # Avanzar en x en un paso h
        x = x + h
    return y

funcion_entrada = input("Ingrese la función dy/dx: ")
x0 = float(input("Ingrese el valor inicial de x: "))
y0 = float(input("Ingrese el valor inicial de y: "))
h = float(input("Ingrese el tamaño de paso h: "))
n = int(input("Ingrese el número de iteraciones: "))

contexto = {**{func: getattr(math, func) for func in dir(math) if callable(getattr(math, func))}, "x": 0, "y": 0, "np": np}
f = lambda x, y: eval(funcion_entrada, contexto, {"x": x, "y": y})

y_final = runge_kutta_orden2(f, x0, y0, h, n)
print(f"El valor final de y después de {n} iteraciones es: {y_final:.4f}")