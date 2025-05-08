def interpolacion_newton(x_datos, y_datos):
    def diferencias_divididas(x_datos, y_datos):
        n = len(x_datos)
        coeficientes = y_datos[:]

        for j in range(1, n):
            for i in range(n - 1, j - 1, -1):
                coeficientes[i] = (coeficientes[i] - coeficientes[i - 1]) / (x_datos[i] - x_datos[i - j])
        return coeficientes

    def interpolar(x, x_datos, coeficientes):
        n = len(x_datos)
        resultado = coeficientes[-1]
        for k in range(n - 2, -1, -1):
            resultado = coeficientes[k] + (x - x_datos[k]) * resultado
        return resultado

    coeficientes = diferencias_divididas(x_datos, y_datos)

    return lambda x: interpolar(x, x_datos, coeficientes)


def result(x_datos, y_datos):
    try:
        polinomio = interpolacion_newton(x_datos, y_datos)
        return polinomio
    except Exception as e:
        print(f"Error: {e}")
        return None
