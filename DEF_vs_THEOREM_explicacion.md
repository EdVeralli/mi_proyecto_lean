# DEF vs THEOREM en Lean 4

Explicación con ejemplos del protocolo de 3-coloreo de grafos para Zero-Knowledge Proofs.

---

## ¿Qué es un `def`?

Un `def` **define** algo. Puede ser:
- Una función computacional
- Una estructura de datos
- Una proposición lógica
- Un valor concreto

**Característica clave:** Se pueden evaluar con `#eval` (si no son `Prop`).

### Tipos de `def` en el Ejemplo de 3-Coloreo

#### 1. `def` que define un TIPO (estructura)

```lean
-- Define la estructura de un grafo
structure Graph where
  nodes : List NodeId
  edges : List Edge
  deriving Repr
```

**¿Qué hace?** Crea un nuevo tipo de dato llamado `Graph` con dos campos.

**Uso:**
```lean
def triangleGraph : Graph :=
  { nodes := [0, 1, 2]
  , edges := [ {from := 0, to := 1}
             , {from := 1, to := 2}
             , {from := 0, to := 2} ] }
```

---

#### 2. `def` que define una FUNCIÓN (computacional)

```lean
-- Función que verifica si un coloreo es válido
def isValidColoring (g : Graph) (coloring : Coloring) : Bool :=
  g.edges.all fun e => coloring e.from ≠ coloring e.to
```

**¿Qué hace?** Define una función que recibe un grafo y un coloreo, y retorna `true` o `false`.

**Tipo de retorno:** `Bool` (valor computacional, no una proposición)

**Uso:**
```lean
#eval isValidColoring triangleGraph secretColoring  -- true
```

✅ Puedes ejecutarlo con `#eval` porque retorna `Bool`.

---

#### 3. `def` que define una PROPOSICIÓN

```lean
-- Define qué significa "coloreo válido" como proposición lógica
def coloreoValido (c0 c1 c2 : Color) : Prop :=
  c0 ≠ c1 ∧ c1 ≠ c2 ∧ c0 ≠ c2
```

**¿Qué hace?** Define una proposición lógica (no una función que calcula).

**Tipo de retorno:** `Prop` (proposición matemática)

**Diferencia con el anterior:**
- `isValidColoring`: retorna `Bool` → se puede evaluar
- `coloreoValido`: retorna `Prop` → se debe **probar** (no evaluar)

```lean
#eval coloreoValido Color.rojo Color.verde Color.azul  -- ❌ ERROR
-- No se puede evaluar una Prop, solo probarla
```

---

#### 4. `def` que define un VALOR concreto

```lean
-- Coloreo secreto del Prover
def secretColoring : Coloring := fun node =>
  match node with
  | 0 => Color.rojo
  | 1 => Color.verde
  | 2 => Color.azul
  | _ => Color.rojo
```

**¿Qué hace?** Define un valor específico de tipo `Coloring`.

**Uso:**
```lean
#eval secretColoring 0  -- Color.rojo
#eval secretColoring 1  -- Color.verde
```

---

## ¿Qué es un `theorem`?

Un `theorem` **prueba** que una proposición es verdadera.

### Estructura de un Teorema

```lean
theorem nombre_teorema (variables) : enunciado := demostración
                       ↑_________↑   ↑________↑   ↑__________↑
                       CONTEXTO      ENUNCIADO    PRUEBA
```

El **ENUNCIADO** tiene dos partes:
1. **Hipótesis** (lo que asumimos)
2. **Conclusión** (lo que queremos probar)

---

## Ejemplos del 3-Coloreo

### Ejemplo 1: Teorema SIN hipótesis

```lean
theorem existe_coloreo_valido :
  ∃ (c0 c1 c2 : Color), coloreoValido c0 c1 c2 :=
  ⟨Color.rojo, Color.verde, Color.azul, 
   by native_decide, by native_decide, by native_decide⟩
```

**Desglose:**

| Parte | Contenido |
|-------|-----------|
| **Nombre** | `existe_coloreo_valido` |
| **Variables/Contexto** | (ninguna) |
| **Hipótesis** | (ninguna) |
| **Conclusión** | `∃ (c0 c1 c2 : Color), coloreoValido c0 c1 c2` |
| **Demostración** | `⟨Color.rojo, Color.verde, Color.azul, ...⟩` |

**Significado:** "Existe un coloreo válido (y aquí está la prueba constructiva)."

---

### Ejemplo 2: Teorema CON hipótesis

```lean
theorem permutation_preserves_validity 
    (g : Graph)                    -- CONTEXTO: variables que usaremos
    (coloring : Coloring) 
    (π : ColorPermutation) :
  isValidColoring g coloring = true →    -- HIPÓTESIS (lo que asumimos)
  isValidColoring g (permuteColoring π coloring) = true := by  -- CONCLUSIÓN
  -- DEMOSTRACIÓN:
  intro h          -- introducimos la hipótesis como 'h'
  unfold isValidColoring permuteColoring
  sorry
```

**Desglose:**

| Parte | Contenido |
|-------|-----------|
| **Nombre** | `permutation_preserves_validity` |
| **Variables/Contexto** | `g : Graph`, `coloring : Coloring`, `π : ColorPermutation` |
| **Hipótesis** | `isValidColoring g coloring = true` |
| **Conclusión** | `isValidColoring g (permuteColoring π coloring) = true` |
| **Demostración** | `intro h; unfold ...; sorry` |

**Significado:** "Para cualquier grafo g, coloreo y permutación π: SI el coloreo es válido, ENTONCES el coloreo permutado también es válido."

**Formato lógico:** `A → B` (si A entonces B)

---

### Ejemplo 3: Teorema con MÚLTIPLES hipótesis

```lean
theorem completeness 
    (g : Graph)                              -- CONTEXTO
    (coloring : Coloring) 
    (π : ColorPermutation) 
    (salts : List (NodeId × Nat)) 
    (ch : Challenge) :
  isValidColoring g coloring = true →        -- HIPÓTESIS 1
  ch.edge ∈ g.edges →                        -- HIPÓTESIS 2
  let commit := createCommitments g coloring π salts
  let resp := generateResponse commit coloring ch
  verify commit ch resp = true := by         -- CONCLUSIÓN
  -- DEMOSTRACIÓN:
  intro h_valid h_edge
  unfold verify generateResponse createCommitments
  sorry
```

**Desglose:**

| Parte | Contenido |
|-------|-----------|
| **Nombre** | `completeness` |
| **Variables/Contexto** | `g`, `coloring`, `π`, `salts`, `ch` |
| **Hipótesis 1** | `isValidColoring g coloring = true` |
| **Hipótesis 2** | `ch.edge ∈ g.edges` |
| **Conclusión** | `verify commit ch resp = true` |
| **Demostración** | `intro h_valid h_edge; ...` |

**Significado:** "Si el coloreo es válido Y la arista desafiada está en el grafo, ENTONCES el verificador acepta."

**Formato lógico:** `A → B → C` (si A y B entonces C)

---

## Comparación Lado a Lado

### DEF para proposición + THEOREM para probarla

```lean
-- DEF: Define QUÉ significa "conocer raíz cuadrada"
def conoceRaiz (n : Nat) : Prop :=
  ∃ x : Nat, x * x = n

-- THEOREM: Prueba que 25 tiene raíz cuadrada
theorem raiz_de_25_existe : conoceRaiz 25 :=
  ⟨5, rfl⟩
```

**Analogía:**
- `def conoceRaiz`: Es como definir la palabra "par" → "un número divisible por 2"
- `theorem raiz_de_25_existe`: Es como demostrar "4 es par"

---

### DEF para función + THEOREM sobre esa función

```lean
-- DEF: Función que permuta colores
def permuteColoring (π : ColorPermutation) (coloring : Coloring) : Coloring :=
  fun node => π.perm (coloring node)

-- THEOREM: Propiedad de esa función
theorem permutation_preserves_validity (g : Graph) (coloring : Coloring) (π : ColorPermutation) :
  isValidColoring g coloring = true →
  isValidColoring g (permuteColoring π coloring) = true := by
  sorry
```

**Analogía:**
- `def permuteColoring`: Define cómo mezclar los colores
- `theorem permutation_preserves_validity`: Prueba que mezclar preserva validez

---

## El Flujo Completo en el 3-Coloreo

### 1. Definimos los tipos básicos
```lean
inductive Color where
  | rojo | verde | azul

structure Graph where
  nodes : List NodeId
  edges : List Edge
```

### 2. Definimos funciones computacionales
```lean
def isValidColoring (g : Graph) (coloring : Coloring) : Bool := ...
def permuteColoring (π : ColorPermutation) (coloring : Coloring) : Coloring := ...
```

### 3. Definimos proposiciones
```lean
def coloreoValido (c0 c1 c2 : Color) : Prop :=
  c0 ≠ c1 ∧ c1 ≠ c2 ∧ c0 ≠ c2
```

### 4. Probamos teoremas sobre ellas
```lean
theorem existe_coloreo_valido :
  ∃ (c0 c1 c2 : Color), coloreoValido c0 c1 c2 := ...

theorem permutation_preserves_validity : ... := ...

theorem completeness : ... := ...
```

---

## Reglas Prácticas

### Usa `def` para:
✅ Definir estructuras de datos  
✅ Crear funciones que calculan valores  
✅ Definir proposiciones (plantear preguntas matemáticas)  
✅ Crear valores concretos  

### Usa `theorem` para:
✅ Probar que algo es verdadero  
✅ Demostrar propiedades de tus definiciones  
✅ Establecer garantías sobre tu código  

---

## Resumen Visual

```
┌─────────────────────────────────────────────────┐
│  DEF                                            │
│  "Así se DEFINE algo"                           │
│                                                 │
│  def coloreoValido (c0 c1 c2 : Color) : Prop   │
│    := c0 ≠ c1 ∧ c1 ≠ c2 ∧ c0 ≠ c2              │
│                                                 │
│  → Plantea la pregunta: "¿Qué es válido?"       │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│  THEOREM                                        │
│  "Esto es VERDAD (y aquí está la prueba)"       │
│                                                 │
│  theorem existe_coloreo_valido :               │
│    ∃ (c0 c1 c2), coloreoValido c0 c1 c2        │
│    := ⟨Color.rojo, Color.verde, Color.azul⟩     │
│                                                 │
│  → Responde la pregunta: "Sí, existe (prueba)"  │
└─────────────────────────────────────────────────┘
```

---

## Anatomía Completa de un Teorema

```lean
theorem completeness               -- NOMBRE del teorema
    (g : Graph)                    -- CONTEXTO: variables universalmente 
    (coloring : Coloring)          --           cuantificadas (∀)
    (π : ColorPermutation) 
    (salts : List (NodeId × Nat)) 
    (ch : Challenge) :
  isValidColoring g coloring = true →   -- HIPÓTESIS 1 (antecedente)
  ch.edge ∈ g.edges →                   -- HIPÓTESIS 2 (antecedente)
  verify commit ch resp = true := by    -- CONCLUSIÓN (consecuente)
  
  intro h_valid h_edge              -- DEMOSTRACIÓN: asumir hipótesis
  unfold verify                     -- expandir definiciones
  simp [generateResponse]           -- simplificar
  sorry                             -- (pendiente completar)
```

**Lectura lógica formal:**
```
∀ (g : Graph) (coloring : Coloring) (π : ColorPermutation) 
  (salts : List (NodeId × Nat)) (ch : Challenge),
  isValidColoring g coloring = true ∧ ch.edge ∈ g.edges 
    → verify commit ch resp = true
```

**Lectura en español:**
```
"Para todo grafo g, coloreo, permutación π, salts y challenge ch:
 Si el coloreo es válido Y la arista está en el grafo,
 Entonces el verificador acepta."
```

---

## Conclusión

- **`def`** = Las piezas de Lego (tipos, funciones, proposiciones)
- **`theorem`** = Probar que las piezas encajan de cierta manera

En el protocolo ZK de 3-coloreo:
1. Usamos `def` para construir el grafo, colores, commitments, funciones
2. Usamos `theorem` para probar que el protocolo tiene las propiedades deseadas (completitud, soundness, zero-knowledge)

**La belleza de Lean:** Las definiciones son precisas y ejecutables, y los teoremas garantizan que tu protocolo funciona correctamente. ✨
