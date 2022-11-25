


Imports:

```agda

open import Level using (Level)

open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.Nat using (Nat; zero; suc; _<_)
open import Agda.Builtin.Float
open import Agda.Builtin.Float.Properties
open import Agda.Builtin.List
open import Agda.Builtin.Maybe

open import Agda.Builtin.Equality
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit

open import Data.Fin using (Fin; zero; suc)
open import Data.Vec using (Vec; []; _∷_)

private
  variable
    a b : Level
    A : Set a
    B : Set b
    n : Nat



```


# The Algorithm

## Why does it work?

One understanding of the algorithm can be broken down into two parts:

1. After the first iteration of the first loop (where $i = 0$), the largest value in the list is moved into the first position, $a[0]$
2. After every subsequent iteration of $i$, the value $a[i]$ is insertion-sorted into the already-sorted sublist $a[0:i]$, while the other items in $a[i+1:n]$ are left unmoved.


```agda
swap-front : Vec A n → Vec A n
swap-front [] = []
swap-front (x ∷ []) = x ∷ []
swap-front (x ∷ x₁ ∷ l) = (x₁ ∷ x ∷ l)

swap : (Fin n) → (Fin n) → (Vec A n) → Vec A n
-- bad input cases
swap zero zero v = v
-- terminating cases
swap zero (suc zero) v = swap-front v
swap (suc zero) zero v = swap-front v
-- recursive cases
swap zero (suc (suc j)) (x₀ ∷ x₁ ∷ v) = swap-front (x₁ ∷ swap zero ((suc j)) ((x₀ ∷ v)))
swap (suc (suc i)) zero (x₀ ∷ x₁ ∷ v) = swap-front (x₁ ∷ swap ((suc i)) zero ((x₀ ∷ v)))
swap (suc i) (suc j) (x ∷ v) = x ∷ (swap i j v)
```
