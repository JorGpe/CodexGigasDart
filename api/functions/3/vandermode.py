def vandermonde_solver(x_values, y_values):
    try:
        n = len(x_values)
        V = [[x**i for i in range(n)] for x in x_values]
        augmented_matrix = [V[i] + [y_values[i]] for i in range(n)]

        for i in range(n):

            max_row = max(range(i, n), key=lambda r: abs(augmented_matrix[r][i]))
            augmented_matrix[i], augmented_matrix[max_row] = augmented_matrix[max_row], augmented_matrix[i]

            pivot = augmented_matrix[i][i]
            for j in range(i, n + 1):
                augmented_matrix[i][j] /= pivot

            for j in range(i + 1, n):
                factor = augmented_matrix[j][i]
                for k in range(i, n + 1):
                    augmented_matrix[j][k] -= factor * augmented_matrix[i][k]

        solution = [0] * n
        for i in range(n - 1, -1, -1):
            solution[i] = augmented_matrix[i][n]
            for j in range(i + 1, n):
                solution[i] -= augmented_matrix[i][j] * solution[j]

        return solution
    except Exception as e:
        return f"Error: {e}"

def result(x_values, y_values):
    try:
        return vandermonde_solver(x_values, y_values)
    except Exception as e:
        return f"Error: {e}"


