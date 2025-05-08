import sympy as sp

def evaluar_funciones_y_jacobiano(funciones_str, variables_str):
    variables = sp.symbols(variables_str)
    funciones = [sp.sympify(f, locals={"e": sp.E, "pi": sp.pi}) for f in funciones_str]
    jacobiano = sp.Matrix(funciones).jacobian(variables)

    f_lambdas = [sp.lambdify(variables, f, modules='math') for f in funciones]
    J_lambdas = [[sp.lambdify(variables, jacobiano[i, j], modules='math')
                  for j in range(len(variables))] for i in range(len(funciones))]

    return f_lambdas, J_lambdas, variables

def evaluar_en_punto(funciones, punto):
    return [f(*punto) for f in funciones]

def resolver_sistema_lineal(A, b):
    n = len(b)
    for i in range(n):
        if A[i][i] == 0:
            raise ZeroDivisionError("División por cero al resolver el sistema.")
        for j in range(i+1, n):
            factor = A[j][i] / A[i][i]
            for k in range(i, n):
                A[j][k] -= factor * A[i][k]
            b[j] -= factor * b[i]

    x = [0] * n
    for i in reversed(range(n)):
        suma = sum(A[i][j] * x[j] for j in range(i+1, n))
        x[i] = (b[i] - suma) / A[i][i]

    return x

def newton_raphson_sistema(funciones_str, variables_str, valores_iniciales):
    tolerancia = 1e-6
    max_iter = 50

    f_lambdas, J_lambdas, variables = evaluar_funciones_y_jacobiano(funciones_str, variables_str)
    x = list(valores_iniciales)

    for it in range(max_iter):
        F = evaluar_en_punto(f_lambdas, x)
        J = [[J_lambdas[i][j](*x) for j in range(len(variables))] for i in range(len(variables))]

        J_copy = [row[:] for row in J]
        F_neg = [-val for val in F]

        try:
            delta = resolver_sistema_lineal(J_copy, F_neg)
        except ZeroDivisionError:
            raise ValueError("Jacobiano no invertible.")

        x = [x[i] + delta[i] for i in range(len(x))]

        if all(abs(d) < tolerancia for d in delta):
            return x, it + 1

    raise ValueError("El método no convergió en el número máximo de iteraciones")

def result(funciones, variables_str, valores_iniciales):
    try:
        solucion, iteraciones = newton_raphson_sistema(funciones, variables_str, valores_iniciales)
        return solucion, iteraciones
    except Exception as e:
        print(f"Error: {e}")
        return None, 0
