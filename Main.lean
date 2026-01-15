-- Mi primer teorema

theorem suma_dos_mas_dos : 2 + 2 = 4 := by
  rfl

#check suma_dos_mas_dos

-- Teorema del cuadrado
theorem cuadrado_positivo (x : Int) : x^2 ≥ 0 := by
  cases x with
  | ofNat n => exact Int.zero_le_ofNat _
  | negSucc n => exact Int.zero_le_ofNat _

#check cuadrado_positivo
#check cuadrado_positivo 5

-- Función
def duplicar (n : Nat) : Nat := n + n

#eval duplicar 5

-- Main para ejecutar
def main : IO Unit := do
  IO.println "¡Hola desde Lean!"
  IO.println s!"2 + 2 = {2 + 2}"
  IO.println s!"duplicar 5 = {duplicar 5}"
