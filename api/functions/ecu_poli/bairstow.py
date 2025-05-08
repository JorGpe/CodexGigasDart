import cmath

def bairstow_method(coeficientes, r, s):
    tol = 1e-6
    max_iter = 100

    def solve_quadratic(r, s):
        D = r**2 + 4*s
        sqrt_D = cmath.sqrt(D)
        x1 = (r + sqrt_D) / 2
        x2 = (r - sqrt_D) / 2
        return x1, x2

    n = len(coeficientes) - 1
    roots = []
    coeficientes = coeficientes[:]

    while n >= 3:
        for _ in range(max_iter):
            b = [0.0] * (n + 1)
            c = [0.0] * (n + 1)

            b[n] = coeficientes[n]
            b[n - 1] = coeficientes[n - 1] + r * b[n]

            for i in range(n - 2, -1, -1):
                b[i] = coeficientes[i] + r * b[i + 1] + s * b[i + 2]

            c[n] = b[n]
            c[n - 1] = b[n - 1] + r * c[n]

            for i in range(n - 2, -1, -1):
                c[i] = b[i + 1] + r * c[i + 1] + s * c[i + 2]

            det = c[2]*c[2] - c[3]*c[1]
            if abs(det) < tol:
                break

            dr = (-b[1]*c[2] + b[0]*c[3]) / det
            ds = (-b[0]*c[2] + b[1]*c[1]) / det

            r += dr
            s += ds

            if abs(dr) < tol and abs(ds) < tol:
                break

        x1, x2 = solve_quadratic(r, s)
        roots.extend([x1, x2])
        coeficientes = b[2:]
        n = len(coeficientes) - 1

    if n == 2:
        r_final = -coeficientes[1] / coeficientes[2]
        s_final = -coeficientes[0] / coeficientes[2]
        x1, x2 = solve_quadratic(r_final, s_final)
        roots.extend([x1, x2])
    elif n == 1:
        roots.append(-a[0] / a[1])

    return roots

def result(coeficientes, r_inicial, s_inicial):
    try:
        raices = bairstow_method(coeficientes, r_inicial, s_inicial)
        return raices
    except Exception as e:
        print(f"Error: {e}")
        return None, 0

