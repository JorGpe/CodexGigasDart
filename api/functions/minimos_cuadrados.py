import numpy as np

def minimos_cuadrados(x, y):
    n = len(x)
    sum_x = np.sum(x)
    sum_y = np.sum(y)
    sum_xx = np.sum(x**2)
    sum_xy = np.sum(x*y)
    
    # Cálculo de los coeficientes de la recta: y = a*x + b
    a = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x**2)
    b = (sum_y - a * sum_x) / n
    
    return a, b

x_values = list(map(float, input("Ingrese los valores de x separados por espacios: ").split()))
y_values = list(map(float, input("Ingrese los valores de y separados por espacios: ").split()))

x_values = np.array(x_values)
y_values = np.array(y_values)

a, b = minimos_cuadrados(x_values, y_values)
print(f"Ecuación ajustada: y = {a:.4f}x + {b:.4f}")