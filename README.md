# Mi Proyecto Lean

Proyecto de aprendizaje de **Lean 4**, un lenguaje de programación funcional y asistente de pruebas.

## Contenido

Este proyecto incluye ejemplos de:

- **Teoremas básicos**: demostraciones formales como `2 + 2 = 4`
- **Teoremas con tácticas**: prueba de que el cuadrado de cualquier entero es no negativo
- **Funciones**: definiciones y evaluaciones simples
- **Programa ejecutable**: un `main` que imprime resultados
- **Zero-Knowledge Proofs**: conceptos básicos de ZKP modelados en Lean

## Requisitos

- [Lean 4](https://lean-lang.org/)
- [Lake](https://github.com/leanprover/lake) (viene incluido con Lean)

## Instalación

```bash
# Clonar el repositorio
git clone https://github.com/EdVeralli/mi_proyecto_lean.git
cd mi_proyecto_lean

# Compilar
lake build
```

## Uso

```bash
# Ejecutar el programa
lake exe mi_proyecto_lean

# O verificar los teoremas
lake build MiProyectoLean
```

## Estructura

```
.
├── Main.lean              # Teoremas, funciones y programa principal
├── ZKBasics.lean          # Ejemplos de Zero-Knowledge Proofs
├── MiProyectoLean/
│   └── Basic.lean         # Módulo básico
├── lakefile.toml          # Configuración del proyecto
└── lean-toolchain         # Versión de Lean
```

## Ejemplos incluidos

### Teorema simple
```lean
theorem suma_dos_mas_dos : 2 + 2 = 4 := by rfl
```

### Teorema con casos
```lean
theorem cuadrado_positivo (x : Int) : x^2 ≥ 0 := by
  cases x with
  | ofNat n => exact Int.zero_le_ofNat _
  | negSucc n => exact Int.zero_le_ofNat _
```

### Función
```lean
def duplicar (n : Nat) : Nat := n + n
#eval duplicar 5  -- Output: 10
```

## Zero-Knowledge Proofs (ZKBasics.lean)

Ejemplos didácticos que modelan conceptos fundamentales de ZKP:

| Ejemplo | Concepto |
|---------|----------|
| Raíz cuadrada | Probar conocimiento de un valor sin revelarlo |
| Commitment | Comprometerse a un valor y verificarlo después |
| Range Proof | Probar que un número está en un rango |
| Coloreo de grafo | Problema NP-completo clásico de ZKP |
| Protocolo ZK | Estructura de un protocolo interactivo |

### Ejemplo: Probar conocimiento sin revelar
```lean
-- El tipo solo dice que EXISTE una raíz, no cuál es
theorem raiz_de_25_existe : conoceRaiz 25 :=
  ⟨5, rfl⟩  -- Solo la prueba conoce el valor 5
```

### Ejemplo: Commitment scheme
```lean
def crearCommitment (secret : Nat) (nonce : Nat) : Commitment :=
  { hash := simpleHash secret nonce }

#eval crearCommitment 42 777  -- hash = 42777
```

## Recursos para aprender Lean

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/)
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/)
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)