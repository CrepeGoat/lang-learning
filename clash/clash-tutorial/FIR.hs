module FIR where
import Clash.Prelude

g a b c = (b1,b2,i2)
  where
    (i1,b1) = unbundle (mealy f 0 (bundle (a,b)))
    (i2,b2) = unbundle (mealy f 3 (bundle (c,i1)))
