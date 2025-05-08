def interpolacion_lagrange(x_datos, y_datos):
    
    def L(i, x_val):
        result = 1
        for j in range(len(x_datos)):
            if j != i:
                result *= (x_val - x_datos[j]) / (x_datos[i] - x_datos[j])
        return result
    
    def interpolar(x_val):
        suma = 0
        for i in range(len(x_datos)):
            suma += y_datos[i] * L(i, x_val)
        return suma

    return interpolar

def result(x_datos, y_datos):
    try:
        polinomio = interpolacion_lagrange(x_datos, y_datos)
        return polinomio
    except Exception as e:
        print(f"Error: {e}")
        return None
