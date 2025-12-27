# Proyecto: Multiplicación de matrices en ensamblador 8086

**Integrantes del equipo:**
- Humberto Villacis  
- Diego Hernández  
- Pedro Sabatino  
- Ismael Quintero  

**Asignatura:** Organización del Computador  

## 📌 Descripción

Este proyecto universitario consiste en la implementación de un programa en **lenguaje ensamblador 8086** que recibe dos matrices cuadradas (A y B), calcula su producto y muestra el resultado en pantalla.  

El programa cumple con los siguientes requisitos:
- Las matrices tienen un tamaño máximo de **8x8** y un mínimo de **3x3**.  
- El tamaño de la matriz se controla mediante la variable `N`.  
- Las matrices A y B están **definidas estáticamente** en el código fuente (no hay entrada por teclado).  
- El resultado se almacena en la matriz `PROD`.  
- La salida se muestra primero **por filas**, luego hace una pausa, y finalmente se muestra **por columnas**.  

---

## ⚙️ Funcionalidades principales

- **Verificación del tamaño (`verificarTamano`)**  
  Valida que `N` esté entre 3 y 8. Si no cumple, el programa termina inmediatamente.  

- **Multiplicación de matrices (`multiplicarMatrices`)**  
  Implementa el cálculo `PROD = A × B` usando un acumulador de 32 bits (`SUMHI:SUMLO`) para evitar desbordamientos.  

- **Impresión de números (`imprimirNumero`)**  
  Convierte los valores de la matriz resultado a texto decimal ASCII y los muestra en pantalla.  

- **Impresión por filas (`imprimirFilas`)**  
  Recorre la matriz resultado fila por fila y la imprime con espacios entre elementos. Al final añade un salto de línea adicional.  

- **Impresión por columnas (`imprimirColumnas`)**  
  Recorre la matriz resultado columna por columna y la imprime. Al finalizar, hace una pausa esperando que el usuario presione una tecla.  

---

## 🛠️ Herramientas utilizadas

Este proyecto universitario se desarrolló utilizando las siguientes herramientas:

- **Emu8086**  
  Entorno de simulación y ensamblador para procesadores Intel 8086. Se utilizó para escribir, compilar y ejecutar el código fuente en ensamblador, así como para depurar y verificar la lógica paso a paso.

- **Lenguaje C (referencia lógica)**  
  Se implementó primero la lógica de multiplicación de matrices en C para validar el algoritmo y facilitar la traducción al lenguaje ensamblador.

- **8086 Assembly Language**  
  Lenguaje de bajo nivel utilizado para programar directamente las rutinas de multiplicación, verificación y salida en pantalla. Se aplicaron modos de direccionamiento directo y con desplazamiento.

- **Sistema operativo DOS (interrupciones 21h)**  
  Se emplearon las interrupciones del DOS (`int 21h`) para realizar operaciones de entrada/salida, como mostrar caracteres en pantalla y pausar la ejecución esperando una tecla.

- **Editor de texto**  
  Para la escritura y documentación del código fuente (`.asm`) y del informe técnico.

---

## 📚 Documentación requerida

El proyecto incluye un informe breve donde se explica:
- Los **modos de acceso a los datos** utilizados.  
- El **tipo de direccionamiento** aplicado en el código.  
- La **modularidad** del programa (separación en procedimientos).  
- Ejemplos de salida con diferentes valores de `N`.  

---

## ✨ Nota

Este proyecto es parte de la **UCAB** en la asignatura *Organización del Computador*.


