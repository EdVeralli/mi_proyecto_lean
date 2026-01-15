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
├── ZKProof_Realista.lean  # Protocolo ZKP de 3-coloreo de grafos
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

## Zero-Knowledge Proofs (ZKProof_Realista.lean)

Implementación del protocolo clásico de **3-coloreo de grafos**, uno de los ejemplos más didácticos de ZKP.

> Ver [protocolo_3_coloreo_zero_knowledge.md](protocolo_3_coloreo_zero_knowledge.md) para la explicación teórica completa.

### ¿Por qué es Zero-Knowledge?

El Prover demuestra que conoce un coloreo válido **sin revelar los colores**:

1. **Permutación aleatoria**: Cada ronda usa colores permutados
2. **Commitments**: Solo se revelan hashes, no los colores
3. **Revelación parcial**: Solo 2 de N colores por ronda
4. **No reconstruible**: El Verifier no puede inferir el coloreo original

### Protocolo interactivo

```
┌─────────┐                    ┌──────────┐
│ PROVER  │                    │ VERIFIER │
│(secreto)│                    │          │
└────┬────┘                    └────┬─────┘
     │  1. Commitments (hashes)     │
     │ ──────────────────────────>  │
     │                              │
     │  2. Challenge (arista)       │
     │ <──────────────────────────  │
     │                              │
     │  3. Response (2 colores)     │
     │ ──────────────────────────>  │
     │                              │
     │  4. Verificación ✓           │
```

### Ejemplo de código
```lean
-- Verificar que el coloreo es válido
#eval isValidColoring triangleGraph secretColoring  -- true

-- El Verifier solo ve: 2 colores diferentes en 1 arista
-- No puede reconstruir el coloreo completo
```

## Recursos para aprender Lean

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/)
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/)
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)