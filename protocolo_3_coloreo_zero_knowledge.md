# Protocolo clásico de 3-coloreo de grafos (Zero-Knowledge)

## 1. Problema

Un grafo es **3-coloreable** si se puede asignar a cada vértice uno de
tres colores {1,2,3} de forma que ningún par de vértices adyacentes
tenga el mismo color.

Este problema es **NP-completo**.

------------------------------------------------------------------------

## 2. Objetivo del protocolo

Permitir que un **probador (P)** convenza a un **verificador (V)** de
que:

> "Conozco un 3-coloreo válido del grafo"

sin revelar absolutamente nada sobre dicho coloreo.

------------------------------------------------------------------------

## 3. Herramienta criptográfica: compromisos

Se usa una función:

    commit(valor, aleatoriedad)

con propiedades:

-   **Ocultamiento (hiding):** no revela el valor.
-   **Vinculación (binding):** no se puede cambiar luego.

Ejemplo: hashes criptográficos.

------------------------------------------------------------------------

## 4. Protocolo general

Para cada ronda:

1.  P permuta los colores aleatoriamente.
2.  P se compromete con los colores de todos los vértices.
3.  V elige una arista al azar.
4.  P abre los compromisos de los dos vértices.
5.  V verifica que los colores sean distintos.

Se repite muchas veces.

------------------------------------------------------------------------

## 5. Ejemplo práctico completo

### Grafo

Triángulo:

V = {A, B, C}

E = {(A,B), (B,C), (A,C)}

### Coloreo real secreto

  Vértice   Color
  --------- -------
  A         1
  B         2
  C         3

### Permutación elegida

π(1)=3, π(2)=1, π(3)=2

### Coloreo permutado

  Vértice   Color
  --------- -------
  A         3
  B         1
  C         2

### Compromisos enviados

    C_A = commit(3, rA)
    C_B = commit(1, rB)
    C_C = commit(2, rC)

### Desafío

V elige (B,C)

### Apertura

    B → (1, rB)
    C → (2, rC)

### Verificación

-   compromisos válidos
-   1 ≠ 2

Resultado: aceptado.

------------------------------------------------------------------------

## 6. Por qué el verificador no aprende el coloreo

-   Cada ronda usa una permutación distinta.
-   Solo se revelan dos vértices.
-   No hay correlación entre rondas.

Formalmente:

> Existe un simulador que puede producir transcripciones indistinguibles
> sin conocer el coloreo.

------------------------------------------------------------------------

## 7. Probabilidad de engaño

Si el grafo NO es 3-coloreable:

Probabilidad por ronda:

    1 - 1/|E|

Tras k rondas:

    (1 - 1/|E|)^k

Ejemplo con \|E\|=100:

Para seguridad 10⁻¹²:

    k ≈ 3000 rondas

------------------------------------------------------------------------

## 8. Resumen

  Propiedad               Resultado
  ----------------------- -----------
  Revela el coloreo       No
  Revela colores reales   No
  Prueba correcta         Sí
  Seguridad ajustable     Sí
  Base de ZK modernos     Sí

------------------------------------------------------------------------

## 9. Importancia histórica

Goldreich, Micali y Wigderson (1986) demostraron que:

> Todo problema en NP tiene una prueba de conocimiento cero.

Este protocolo es el ejemplo canónico.

------------------------------------------------------------------------

## 10. Referencias

-   Goldreich, Micali, Wigderson -- *How to prove all NP statements in
    zero-knowledge*
-   Katz & Lindell -- *Introduction to Modern Cryptography*

------------------------------------------------------------------------

Documento generado por ChatGPT.
