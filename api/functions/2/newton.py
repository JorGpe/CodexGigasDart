def newton(x_values, y_values):
    n = len(x_values)
    coef = [[0 for _ in range(n)] for _ in range(n)]
    
    for i in range(n):
        coef[i][0] = y_values[i]

    for j in range(1, n):
        for i in range(n - j):
            numerador = coef[i + 1][j - 1] - coef[i][j - 1]
            denominador = x_values[i + j] - x_values[i]
            coef[i][j] = numerador / denominador

    a = [coef[0][j] for j in range(n)]
    return a

def result(x_values, y_values):
    try:
        coef = newton(x_values, y_values)
        return coef
    except Exception as e:
        print("Ocurrió un error:", e)
        return None
