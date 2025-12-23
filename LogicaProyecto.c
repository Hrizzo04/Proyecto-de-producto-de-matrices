#include <stdio.h>

#define N 3  // Constante universal para el tamaño de la matriz (entre 3 y 8)

// -------------------------------
// Función para verificar el tamaño
int verificarTamano() {
    if (N < 3 || N > 8) {
        printf("Error: El tamaño debe estar entre 3 y 8.\n");
        return 0; // tamaño inválido
    }
    return 1; // tamaño válido
}

// -------------------------------
// Función para imprimir matriz por filas
void imprimirPorFilas(int M[N][N]) {
    printf("\nResultado por filas:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%4d ", M[i][j]);
        }
        printf("\n");
    }
}

// -------------------------------
// Función para imprimir matriz por columnas
void imprimirPorColumnas(int M[N][N]) {
    printf("\nResultado por columnas:\n");
    for (int j = 0; j < N; j++) {
        for (int i = 0; i < N; i++) {
            printf("%4d ", M[i][j]);
        }
        printf("\n");
    }
}

// -------------------------------
// Función principal
int main() {
    // Verificar tamaño
    if (!verificarTamano()) {
        return 1; // salir si el tamaño es inválido
    }

    // Definición de matrices con tamaño N x N
    int A[N][N] = {
        {1, 2, 5, 8,  7, 6, 5, 4},
        {3, 1, 2, 11, 9, 8, 7, 6},
        {2, 4, 3, 9,  1, 2, 3, 4},
        {6, 5, 7, 8,  0, 1, 2, 3},
        {5, 4, 3, 2,  1, 2, 3, 4},
        {7, 8, 9, 1,  2, 3, 4, 5},
        {9, 8, 7, 6,  5, 4, 3, 2},
        {1, 2, 3, 4,  5, 6, 7, 8}
    };

    int B[N][N] = {
        {1, 0, 3, 2,  4, 5, 6, 7},
        {4, 10, 5, 2, 3, 2, 1, 0},
        {-1, 4, 2, 7, 8, 9, 1, 2},
        {9, 3, 1, 8, 7, 6, 5, 4},
        {2, 3, 4, 5, 6, 7, 8, 9},
        {5, 4, 3, 2, 1, 0, 9, 8},
        {7, 6, 5, 4, 3, 2, 1, 0},
        {8, 9, 1, 2, 3, 4, 5, 6}
    };


    int PROD[N][N] = {0}; // matriz resultado inicializada en 0

    // -------------------------------
    // Multiplicación de matrices
    for (int i = 0; i < N; i++) {          // filas de A
        for (int j = 0; j < N; j++) {      // columnas de B
            for (int k = 0; k < N; k++) {  // elementos de fila y columna
                PROD[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    // -------------------------------
    // Impresión de resultados
    imprimirPorFilas(PROD);

    printf("\n--- Pausa ---\n\n");

    imprimirPorColumnas(PROD);

    return 0;
}