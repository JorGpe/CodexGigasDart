import numpy as np
import sympy as sp

def newton_polinomios(fx, dfx, valor_inicial):
    x = valor_inicial
    tol = 1e-6
    max_iter = 50
    for i in range(max_iter):
        fx_val = fx(x)
        dfx_val = dfx(x)
        
        if abs(fx_val) < tol:
            return x, i+1  # Si la función ya es suficientemente pequeña, retornamos la raíz
        
        if dfx_val == 0:
            raise ValueError("La derivada se anuló, no se puede continuar con el método de Newton")
        
        x_next = x - fx_val / dfx_val  # Fórmula de Newton-Raphson
        
        if abs(x_next - x) < tol:
            return x_next, i+1
        
        x = x_next
    
    raise ValueError("El método no convergió en el número máximo de iteraciones")

expr = input("Ingrese el polinomio: ")
valor_inicial = float(input("Ingrese el valor inicial: "))

x_sym = sp.Symbol('x')
funcion = sp.sympify(expr)
derivada = sp.diff(funcion, x_sym)

def funcion_evaluar(x):
    return funcion.subs(x_sym, x).evalf()

def funcion_derivada(x):
    return derivada.subs(x_sym, x).evalf()

raiz, iteraciones = newton_polinomios(funcion_evaluar, funcion_derivada, valor_inicial)
print("Aproximación de la raíz:", raiz)
print("Iteraciones realizadas:", iteraciones)
