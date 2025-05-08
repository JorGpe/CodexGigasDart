def minimos_cuadrados(x_datos, y_datos):

    if len(x_datos) != len(y_datos):
        raise ValueError("Los arreglos x e y deben tener la misma longitud")
    if len(x_datos) < 2:
        raise ValueError("Se necesitan al menos 2 puntos para el ajuste")
    
    n = len(x_datos)
    sum_x = sum_y = sum_xy = sum_x2 = 0.0
    
    for xi, yi in zip(x_datos, y_datos):
        sum_x += xi
        sum_y += yi
        sum_xy += xi * yi
        sum_x2 += xi * xi

    denominador = n * sum_x2 - sum_x * sum_x
    if denominador == 0:
        raise ValueError("No se puede calcular (división por cero), los datos x deben ser diferentes")
    
    m = (n * sum_xy - sum_x * sum_y) / denominador
    b = (sum_y - m * sum_x) / n
 
    ss_tot = ss_res = 0.0
    y_mean = sum_y / n
    for xi, yi in zip(x_datos, y_datos):
        y_pred = m * xi + b
        ss_tot += (yi - y_mean) ** 2
        ss_res += (yi - y_pred) ** 2
    r2 = 1 - (ss_res / ss_tot) if ss_tot != 0 else 1
    
    def prediccion(x):
        return m * x + b

    prediccion.m = m
    prediccion.b = b
    prediccion.r2 = r2
    return prediccion

def result(x_datos, y_datos):
    try:
        polinomio = minimos_cuadrados(x_datos, y_datos)
        return polinomio
    except Exception as e:
        print(f"Error: {e}")
        return None