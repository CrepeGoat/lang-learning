module MAC where
import Clash.Prelude
import Clash.Explicit.Testbench

ma acc (x, y) = acc + x * y

macT acc (x, y) = (acc', o)
  where
    acc' = ma acc (x, y)
    o    = acc
-- macT acc inp = (ma acc inp, acc)

mac inp = mealy macT 0 inp

topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (Signed 9, Signed 9)
  -> Signal System (Signed 9)
topEntity = exposeClockResetEnable mac

testBench :: Signal System Bool
testBench = done
  where
    testInput    = stimuliGenerator clk rst $(listToVecTH [(1,1) :: (Signed 9,Signed 9),(2,2),(3,3),(4,4)])
    expectOutput = outputVerifier' clk rst $(listToVecTH [0 :: Signed 9,1,5,14,14,14,14])
    done         = expectOutput (topEntity clk rst en testInput)
    en           = enableGen
    clk          = tbSystemClockGen (not <$> done)
    rst          = systemResetGen
