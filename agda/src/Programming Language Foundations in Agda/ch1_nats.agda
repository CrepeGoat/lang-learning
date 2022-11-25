data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

{-# BUILTIN NATURAL ℕ #-}


import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; _∎)


{------ Addition ------}
_+_ : ℕ → ℕ → ℕ
zero + n = n
(suc m) + n = suc (m + n)

_ =
  begin
    2 + 3
  ≡⟨⟩
    suc (1 + 3)
  ≡⟨⟩
    suc (suc (0 + 3))
  ≡⟨⟩
    suc (suc 3)
  ≡⟨⟩
    5
  ∎


{------ Multiplication ------}
_*_ : ℕ → ℕ → ℕ
zero    * n  =  zero
(suc m) * n  =  n + (m * n)

{------ Exponentiation ------}
_^_ : ℕ → ℕ → ℕ
n ^ zero = suc zero
n ^ (suc m) = n * (n ^ m)

{---- Exercise _^_ -----}
_ =
  begin
    3 ^ 4
  ≡⟨⟩
    3 * (3 ^ 3)
  ≡⟨⟩
    3 * (3 * (3 ^ 2))
  ≡⟨⟩
    3 * (3 * (3 * (3 ^ 1)))
  ≡⟨⟩
    3 * (3 * (3 * (3 * (3 ^ 0))))
  ≡⟨⟩
    3 * (3 * (3 * (3 * 1)))
  ≡⟨⟩
    3 * (3 * (3 * (3)))
  ≡⟨⟩
    3 * (3 * (9))
  ≡⟨⟩
    3 * (27)
  ≡⟨⟩
    81
  ∎

{------ Monus ------}
_∸_ : ℕ → ℕ → ℕ
m ∸ zero = m
zero ∸ suc n = zero
suc m ∸ suc n = m ∸ n

{---- Exercise ∸-example₁ -----}
_ =
  begin
    5 ∸ 3
  ≡⟨⟩
    4 ∸ 2
  ≡⟨⟩
    3 ∸ 1
  ≡⟨⟩
    2 ∸ 0
  ≡⟨⟩
    2
  ∎

{---- Exercise ∸-example₂ -----}
_ =
  begin
    3 ∸ 5
  ≡⟨⟩
    2 ∸ 4
  ≡⟨⟩
    1 ∸ 3
  ≡⟨⟩
    0 ∸ 2
  ≡⟨⟩
    0
  ∎

{------ Operator Precedence ------}
infixl 6  _+_  _∸_
infixl 7  _*_

{---- Exercise Bin -----}
data Bin : Set where
  ⟨⟩ : Bin
  _O : Bin → Bin
  _I : Bin → Bin

inc_ : Bin → Bin
inc ⟨⟩ = ⟨⟩ I
inc (n O) = n I
inc (n I) = (inc n) O

_ =
  begin
    inc (⟨⟩ I O I I)
  ≡⟨⟩ ⟨⟩ I I O O
  ∎

to_ : ℕ → Bin
to zero  = ⟨⟩ O
to (suc n) = inc (to n)

_ =  begin to zero ≡⟨⟩ ⟨⟩ O ∎
_ = begin to (suc zero) ≡⟨⟩ ⟨⟩ I ∎
_ = begin to (suc (suc zero)) ≡⟨⟩ ⟨⟩ I O ∎
_ = begin to (suc (suc (suc zero))) ≡⟨⟩ ⟨⟩ I I ∎
_ = begin to (suc (suc (suc (suc zero)))) ≡⟨⟩ ⟨⟩ I O O ∎

from_ : Bin → ℕ
from ⟨⟩ = zero
from (n O) = (suc (suc zero)) * (from n)
from (n I) = suc ((suc (suc zero)) * (from n))

_ = begin from(⟨⟩ O) ≡⟨⟩ zero ∎
_ = begin from(⟨⟩ I) ≡⟨⟩ suc zero ∎
_ = begin from(⟨⟩ I O) ≡⟨⟩ suc (suc zero) ∎
_ = begin from(⟨⟩ I I) ≡⟨⟩ suc (suc (suc zero)) ∎
_ = begin from(⟨⟩ I O O) ≡⟨⟩ suc (suc (suc (suc zero))) ∎

