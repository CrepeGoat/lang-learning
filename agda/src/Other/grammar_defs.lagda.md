
# Goal
The goal is to describe & define a grammar (NOT context-free! ...not sure exactly what though) over binary strings within the Agda language. I'm using Agda (as opposed to something simpler and more purpose-built like, e.g., extended Backus–Naur form (EBNF)) because

- I can use Agda's **dependent type** system to express non-context-free-ness in a grammar of interest.
- I can construct logical proofs re: the bit alignment of a particular binary message.

A subsequent goal is to use a grammar described in Agda in order to programmatically generate a parser library for the given grammar. This would be applicable to binary formats like protobuf, EBML, etc. (note that these binary formats specifically are NOT context-free; hence the desire for dependent types).

If both of these goals are met, then it may be worthwhile to write a purpose-built dependently-typed language specifically for defining & describing binary formats.


# Example Definitions

From the 

```agda
{-# OPTIONS --without-K --allow-unsolved-metas --exact-split #-}


open import Agda.Primitive
open import Agda.Builtin.Equality
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.Sigma using (Σ; _,_; fst; snd)
open import Agda.Builtin.Maybe
-- open import Agda.Builtin.Nat using () renaming (mod-helper to modₕ)


open import Data.Fin using (Fin; zero; suc; fromℕ<; toℕ)
open import Data.List using (List; []; _∷_; map; foldr)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Nat.DivMod.Core using (a[modₕ]n<n)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Data.Vec using (Vec; []; _∷_)
open import Function.Base using (_∘_)

private
  variable
    a b : Level
    A : Set a
    B : Set b

```

Somehow the standard library doesn't have a `mod` function that takes `x m : Nat` and returns a `Fin m`?

```agda
private
  a≤b⇛a<1+b : ∀ {a b : ℕ} → a Data.Nat.≤ b → a Data.Nat.< (suc b)
  a≤b⇛a<1+b Data.Nat.z≤n = Data.Nat.s≤s Data.Nat.z≤n
  a≤b⇛a<1+b (Data.Nat.s≤s a≤b) = Data.Nat.s≤s (a≤b⇛a<1+b a≤b)

-- x mod1+ m ≅ x % (suc m)
_mod1+_ : ℕ → (m : ℕ) → Fin (suc m)
x mod1+ m with (a[modₕ]n<n 0 x m)
... | mod≤m = fromℕ< (a≤b⇛a<1+b mod≤m)

```



```agda
data BinData (a : Level) : Set a
byte-alignment : BinData a → Fin 8


data BitSeq : Set where
  _bits : ℕ → BitSeq

data LiteralBitSeq : Set where
  bin : {n : ℕ} → (Vec Bool n) → LiteralBitSeq

data AnyOf {i : Fin 8} (a : Level) : Set a where
  any : List (Σ (BinData a) (λ dat → (byte-alignment dat ≡ i))) → AnyOf a

data Concat (a : Level) : Set a where
  seq : List (BinData a) → Concat a


data BinData a where
  bitseq : BitSeq → BinData a
  litbitseq : LiteralBitSeq → BinData a
  anyof : {i : Fin 8} → AnyOf {i} a → BinData a
  concat : Concat a → BinData a

byte-alignment (bitseq (n bits)) = n mod1+ 7
byte-alignment (litbitseq (bin {n} x)) = n mod1+ 7
byte-alignment (anyof {i} _) = i
byte-alignment (concat (seq x)) = (seq-alignment x) mod1+ 7
  where
    seq-alignment : List (BinData a) → ℕ
    seq-alignment [] = zero
    seq-alignment (x ∷ x₁) = toℕ (byte-alignment x) Data.Nat.+ (seq-alignment x₁)

```

## EBML VINT

Octet Length | Usable Bits | Representation
-------------|-------------|:-------------------------------------------------
1            | 7           | 1xxx xxxx
2            | 14          | 01xx xxxx xxxx xxxx
3            | 21          | 001x xxxx xxxx xxxx xxxx xxxx
4            | 28          | 0001 xxxx xxxx xxxx xxxx xxxx xxxx xxxx
5            | 35          | 0000 1xxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx
Table: VINT examples depicting usable bits{#tableUsableBits}


```agda
VINT1 : BinData a
VINT1 = concat (seq ((litbitseq (bin (true ∷ []))) ∷ (bitseq (7 bits)) ∷ []))
VINT2 : BinData a
VINT2 = concat (seq ((litbitseq (bin (false ∷ true ∷ []))) ∷ (bitseq (14 bits)) ∷ []))
VINT3 : BinData a
VINT3 = concat (seq ((litbitseq (bin (false ∷ false ∷ true ∷ []))) ∷ (bitseq (21 bits)) ∷ []))
VINT4 : BinData a
VINT4 = concat (seq ((litbitseq (bin (false ∷ false ∷ false ∷ true ∷ []))) ∷ (bitseq (28 bits)) ∷ []))

VINT : BinData a
VINT = anyof (any ((VINT1 , refl) ∷ (VINT2 , refl) ∷ (VINT3 , refl) ∷ (VINT4 , refl) ∷ []))
```



