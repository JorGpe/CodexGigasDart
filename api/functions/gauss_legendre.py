import numpy as np
import math
from scipy.special import roots_legendre

def cuadratura_Gauss_Legendre_N3(fx, inf, sup):

    # Obtener los pesos y nodos de la cuadratura de Gauss-Legendre
    raiz1, raiz2 = roots_legendre(3)
    
    # Transformar los nodos al intervalo [a, b]
    intervalo_inf_sup = 0.5 * (sup - inf) * raiz1 + 0.5 * (sup + inf)
    
    # Evaluar la función en los nodos y calcular la suma ponderada
    integral = 0.5 * (sup - inf) * np.sum(raiz2 * fx(intervalo_inf_sup))
    
    return integral

def evaluar_fx(x):
    # Incluir todas las funciones matemáticas disponibles
    contexto = {func: getattr(math, func) for func in dir(math) if callable(getattr(math, func))}
    contexto["x"] = x
    return eval(funcion_entrada, contexto)

funcion_entrada = input("Funcion de la integral a aproximar: ") 
inf = float(input("Limite inferior de la integral: "))
sup = float(input("Limite superior de la integral: "))

resultado = cuadratura_Gauss_Legendre_N3(evaluar_fx, inf, sup)
print("Aproximación de la integral:", resultado)