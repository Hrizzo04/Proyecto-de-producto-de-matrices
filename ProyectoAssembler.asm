; Proyecto: Multiplicacion de matrices en 8086
; Integrantes: Humberto Villacis, Diego Hernandez, Pedro Sabatino, Ismael Quintero
; Organizacion del Computador - 2026

.model small
.stack 100h

.data
SUMLO dw 0  ; guarda la parte pequena de la suma acumulada
SUMHI dw 0  ; guarda la parte alta de la suma acumulada
N dw 8      ; tamano de la matriz (entre 3 y 8)
bufDec label byte ; buffer para convertir a decimal
buf0 db 0
buf1 db 0
buf2 db 0
buf3 db 0
buf4 db 0
buf5 db 0

; Matriz A (8x8, rellena con ceros si sobra)

A: dw  3, -2,  7,  0,  5, -1,  4,  8,
dw -6,  1,  0,  9, -3,  2, -7,  6,
dw  4,  5, -8,  2,  0,  3,  1, -4,
dw  7,  0,  6, -5,  8, -2,  9,  0,
dw -3,  2,  1,  4, -6,  7,  0,  5,
dw  0, -9,  3,  2,  6, -4,  8, -1,
dw  5,  7, -2,  0,  3,  1, -8,  4,
dw -4,  0,  9, -7,  2,  6,  0, -3



; Matriz B (8x8)

B:  dw  1,  0, -5,  7,  2, -3,  4,  6,
dw -2,  8,  0, -1,  5,  9, -4,  0,
dw  3, -6,  2,  0, -7,  1,  8, -5,
dw  0,  4, -9,  2,  6, -8,  0,  7,
dw -1,  0,  3, -2,  4,  0, -6,  9,
dw  5, -7,  0,  8, -3,  2,  1,  0,
dw  0,  6, -4,  0,  7, -5,  3, -2,
dw -8,  0,  9, -1,  0,  4, -7,  6




; Matriz resultado (8x8 inicializada en 0)
PROD dw 64 dup(0)

.code
main PROC
mov ax, @data
mov ds, ax

; validar N antes de todo
call verificarTamano

; Llamar a la rutina de multiplicacion
call multiplicarMatrices

; Imprimir por filas
call imprimirFilas

; Pausa (esperar tecla)
mov ah, 1
int 21h

; Imprimir por columnas
call imprimirColumnas

; Terminar programa
mov ax, 4C00h
int 21h
main ENDP

; Verfica si el tamano puesto es correcto
verificarTamano PROC
; Cargar N en AX
mov ax, N

; ¿AX < 3?
cmp ax, 3
jl  vt_fail

; ¿AX > 8?
cmp ax, 8
jg  vt_fail

; OK ? continuar
ret

vt_fail:
; Terminar programa directamente
mov ax, 4C00h
int 21h
verificarTamano ENDP


; -------------------------------
; Rutina de multiplicacion
; -------------------------------
; PROD[i][j] = sum_{k=0..N-1} A[i][k] * B[k][j]
; i, j, k recorren solo 0..N-1, pero las matrices estan almacenadas 8x8.
; Desplazamiento en palabras: i*8 + j (o k).
; Desplazamiento en bytes: (i*8 + j) * 2.

multiplicarMatrices PROC
; DI = i, SI = j, CX = k
xor di, di              ; i = 0
for_i:
cmp di, N
jge end_mult            ; fin de i

xor si, si              ; j = 0
for_j:
cmp si, N
jge next_i              ; siguiente i

; sum = 0 (32 bits en SUMHI:SUMLO)
mov SUMLO, 0
mov SUMHI, 0

xor cx, cx              ; k = 0
for_k:
cmp cx, N
jge store_prod      ; guardar producto

; ---------------------------
; Cargar A[i][k]
; bx = (i*8 + k) * 2
mov bx, di              ; bx = i
shl bx, 3               ; i*8
add bx, cx              ; i*8 + k
shl bx, 1               ; *2 -> bytes
mov ax, [A + bx]        ; AX = A[i][k]

; ---------------------------
; Cargar B[k][j]
; bx = (k*8 + j) * 2
mov bx, cx              ; bx = k
shl bx, 3               ; k*8
add bx, si              ; k*8 + j
shl bx, 1               ; *2 -> bytes
mov bp, [B + bx]        ; BP = B[k][j]

; ---------------------------
; Producto y acumulacion (signed)
imul bp                 ; DX:AX = AX * BP (signed 16x16 -> 32 bits)

; sum += DX:AX
; SUMLO += AX, SUMHI += DX + carry
push ax                 ; AX = producto low
mov ax, SUMLO
pop bx                  ; BX = producto low
add ax, bx              ; SUMLO + producto low
mov SUMLO, ax
mov ax, SUMHI
adc ax, dx              ; SUMHI + producto high + carry
mov SUMHI, ax

; siguiente k
inc cx
jmp for_k

store_prod:
; Guardar solo la parte baja en PROD[i][j]
; bx = (i*8 + j) * 2
mov bx, di
shl bx, 3               ; i*8
add bx, si              ; i*8 + j
shl bx, 1               ; *2 -> bytes

mov ax, SUMLO
mov [PROD + bx], ax     ; PROD[i][j] = SUMLO

; siguiente j
inc si
jmp for_j

next_i:
inc di
jmp for_i

end_mult:
ret
multiplicarMatrices ENDP

; -------------------------------
; Rutina para imprimir numeros

; Imprime AX como entero decimal con signo (16-bit)
imprimirNumero PROC
push ax     ; guardar registros
push bx     ; guardar registros
push cx     ; guardar registros
push dx     ; guardar registros
push si     ; guardar registros

mov bx, ax           ; BX = valor original
; ZER0
cmp bx, 0
jne not_zero    ; no es cero
mov dl, '0'     ; caracter '0'
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir '0'
jmp done

not_zero:
; SIGNO
mov si, 0            ; si = 1 si hay signo
cmp bx, 0
jge pos             ; positivo -> comparador >=
mov dl, '-'         ; signo negativo
mov ah, 2           ; funcion imprimir caracter
int 21h             ; imprimir signo
neg bx              ; hacer positivo
pos:
; CONVERTIR A DECIMAL EN bufDec (al derecho)
; Vamos llenando de atras hacia adelante
mov cx, 0           ; contador de digitos
conv_loop:
mov ax, bx
xor dx, dx        ; limpiar DX antes de division
mov si, 10
div si              ; AX/10 -> AX=cociente, DX=residuo -> llevamos a base 10
; Guardar digito en bufDec[cx]
; DX residuo en DL (0..9)
add dl, '0'         ; convertir a ASCII ('0'..'9')
mov bx, cx
mov buf0[bx], dl    
inc cx
mov bx, ax          ; siguiente cociente
cmp bx, 0
jne conv_loop

; Imprimir digitos en orden inverso: bufDec[cx-1 .. 0]
; Ya que se guarda de manera inversa
; ejemplo: si tenemos 123, se guarda como ->
; bufDec[0]='3', bufDec[1]='2', bufDec[2]='1', cx=3 

print_rev:
dec cx
mov bx, cx  ; indice del digito a imprimir
mov dl, buf0[bx]    ; cargar digito
mov ah, 2  ; funcion imprimir caracter 
int 21h    ; imprimir caracter
cmp cx, 0
jne print_rev   ; repetir hasta cx=0


done:
pop si          ; restaurar registros
pop dx          ; restaurar registros
pop cx          ; restaurar registros
pop bx          ;   restaurar registros
pop ax          ; restaurar registros
ret             ;  vuelva al llamador
imprimirNumero ENDP

; -------------------------------
; Rutina imprimir por filas
imprimirFilas PROC
xor di, di              ; i = 0
fila_loop1:
cmp di, N
jge end_filas           ; fin de filas -> comparador >=

xor si, si              ; j = 0
col_loop2:
cmp si, N
jge next_fila           ; fin de columnas -> comparador >=

; offset = (i*8 + j)*2
mov bx, di
shl bx, 3               ; i*8
add bx, si              ; i*8 + j
shl bx, 1               ; *2 -> bytes
mov ax, [PROD + bx]     ; AX = PROD[i][j]

call imprimirNumero        ; imprimir numero

; imprimir espacio
mov dl, ' '     ;   caracter espacio 
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter

inc si
jmp col_loop2

next_fila:
; salto de linea
mov dl, 0Dh     ; caracter retorno carro
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter
mov dl, 0Ah     ; caracter nueva linea
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter

inc di
jmp fila_loop1

end_filas:
; salto de linea final
mov dl, 0Dh     ; caracter retorno carro
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter
mov dl, 0Ah     ; caracter nueva linea
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter

ret
imprimirFilas ENDP

; -------------------------------
; Rutina imprimir por columnas
imprimirColumnas PROC
xor si, si              ; j = 0 (columna)
col_loop3:
cmp si, N
jge end_cols        ; fin de columnas -> comparador >=

xor di, di              ; i = 0 (fila)
fila_loop4:
cmp di, N
jge next_col        ; fin de filas -> comparador >=

; offset = (i*8 + j)*2
mov bx, di
shl bx, 3               ; i*8
add bx, si              ; i*8 + j
shl bx, 1               ; *2 -> bytes
mov ax, [PROD + bx]     ; AX = PROD[i][j]

call imprimirNumero        ; imprimir numero

; imprimir espacio
mov dl, ' '    ;   caracter espacio
mov ah, 2       ; funcion imprimir caracter
int 21h     ; imprimir caracter

inc di
jmp fila_loop4

next_col:
; salto de linea al terminar una columna
mov dl, 0Dh     ; caracter retorno carro
mov ah, 2       ; funcion imprimir caracter
int 21h         ; imprimir caracter
mov dl, 0Ah     ; caracter nueva linea
mov ah, 2       ; funcion imprimir caracter
int 21h     ; imprimir caracter

inc si
jmp col_loop3

end_cols:
; pausa al final de impresion por columnas
mov ah, 1       ; esperar tecla
int 21h             

ret
imprimirColumnas ENDP

END main