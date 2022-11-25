import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; sym)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)
open import Data.Nat using (ℕ; zero; suc; _+_; _*_)


{------ Monus ------}
_∸_ : ℕ → ℕ → ℕ
m ∸ zero = m
zero ∸ suc n = zero
suc m ∸ suc n = m ∸ n

{------- Commutativity of addition ---------}

+-identityʳ : ∀ (m : ℕ) → m + zero ≡ m
+-identityʳ zero =
  begin
    zero + zero
  ≡⟨⟩
    zero
  ∎
+-identityʳ (suc m) =
  begin
    suc m + zero
  ≡⟨⟩
    suc (m + zero)
  ≡⟨ cong suc (+-identityʳ m) ⟩
    suc m
  ∎

+-suc : ∀ (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc zero n =
  begin
    zero + suc n
  ≡⟨⟩
    suc n
  ≡⟨⟩
    suc (zero + n)
  ∎
+-suc (suc m) n =
  begin
    suc m + suc n
  ≡⟨⟩
    suc (m + suc n)
  ≡⟨ cong suc (+-suc m n) ⟩
    suc (suc (m + n))
  ≡⟨⟩
    suc (suc m + n)
  ∎

+-comm : ∀ (m n : ℕ) → m + n ≡ n + m
+-comm m zero =
  begin
    m + zero
  ≡⟨ +-identityʳ m ⟩
    m
  ≡⟨⟩
    zero + m
  ∎
+-comm m (suc n) =
  begin
    m + suc n
  ≡⟨ +-suc m n ⟩
    suc (m + n)
  ≡⟨ cong suc (+-comm m n) ⟩
    suc (n + m)
  ≡⟨⟩
    suc n + m
  ∎

{------- subtraction is inverse addition ---------}
+-negation : ∀ (a b : ℕ) -> (a + b) ∸ b ≡ a
+-negation a zero = refl
+-negation a (suc b) =
  begin
    (a + (suc b)) ∸ (suc b)
  ≡⟨⟩
    suc (a +  b) ∸ (suc b)
  ≡⟨⟩
    (a + b) ∸ a
  ≡⟨ +-negation a b ⟩
    a
  ∎

{------- +- associativity ---------}
+-assoc : ∀ a b c : ℕ → a + ((b + c) ∸ b) ≡ (a + (b + c)) ∸ b
+-assoc a b 

{------- scalar multiplication of zero is zero ---------}
ax0 : ∀ (a n : ℕ) → (suc a) * n ≡ zero → n ≡ zero
ax0 zero n 1*n=0 =
  begin
    n
  ≡⟨⟩
    zero + n
  ≡⟨ sym (+-identityʳ n) ⟩
    n + zero
  ≡⟨⟩
    1 * n
  ≡⟨ 1*n=0 ⟩
    zero
  ∎
ax0 a n suca*n=0 =
  begin
    n
  ≡⟨⟩
    zero + n
  ≡⟨ sym +-identityʳ ⟩
    n + zero
  ≡⟨ cong (n + _) (sym (+-negation (a * n))) ⟩
    n + ((a * n) ∸ (a * n))
  ≡⟨ +-assoc n (a * n) zero ⟩
    (n + a * n) ∸ (a * n)
  ≡⟨⟩
    (suc a) * n ∸ (a * n)
  ≡⟨ cong (_ ∸ (a * n)) suca*n=0 ⟩
    0 ∸ a * n
  ≡⟨⟩
    0
  ∎



∸eq : ∀ (a x y : ℕ) → (suc a) * x ≡ (suc a) * y → x ≡ y
∸eq zero x y ax-eq-ay =
  begin
    x
  ≡⟨ sym +-identityʳ ⟩
    x + zero
  ≡⟨⟩
    1 * x
  ≡⟨ ax-eq-ay ⟩
    1 * y
  ≡⟨⟩
    y + zero
  ≡⟨ +-identityʳ ⟩
    y
  ∎
∸eq (suc a) x y ax-eq-ay =
  begin
    x
  ≡⟨ sym +-identityʳ ⟩
    x + zero
  ≡⟨ cong (x + _) (sym (+-negation a * x)) ⟩
    x + (a * x ∸ a * x)
  ≡⟨ ? ⟩
    (suc a) * x ∸ a * x
  ≡⟨ cong (_ ∸ a * x) ax-eq-ay ⟩
    (suc a) * y ∸ a * x
  ≡⟨⟩
    y + a * y ∸ a * x
  ≡⟨ ? ⟩
    y + (a * y ∸ a * x)
  ≡⟨ ? ⟩
    y + zero
  ≡⟨⟩
    y
  ∎  

