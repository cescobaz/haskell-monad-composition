module PascalTest ( test ) where

import qualified Pascal

import           Test.HUnit.Base hiding ( test )

test :: Test
test = TestList [ justNumber
                , simpleSum
                , doubleSum
                , malformedInput
                , concatComputations
                , checkMemory
                , checkWriter
                ]

justNumber :: Test
justNumber = TestLabel "justNumber" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve "0") @?= Right 0
    (fst . Pascal.runPascal) (Pascal.solve "1") @?= Right 1
    (fst . Pascal.runPascal) (Pascal.solve "4") @?= Right 4
    (fst . Pascal.runPascal) (Pascal.solve "42") @?= Right 42
    (fst . Pascal.runPascal) (Pascal.solve "420") @?= Right 420
    (fst . Pascal.runPascal) (Pascal.solve "0420") @?= Right 420

simpleSum :: Test
simpleSum = TestLabel "simpleSum" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve "1+1") @?= Right 2
    (fst . Pascal.runPascal) (Pascal.solve "1+0") @?= Right 1
    (fst . Pascal.runPascal) (Pascal.solve "0+1") @?= Right 1
    (fst . Pascal.runPascal) (Pascal.solve "3+5") @?= Right 8

doubleSum :: Test
doubleSum = TestLabel "doubleSum" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve "1+1+1") @?= Right 3
    (fst . Pascal.runPascal) (Pascal.solve "1+0+1") @?= Right 2
    (fst . Pascal.runPascal) (Pascal.solve "0+1+3") @?= Right 4
    (fst . Pascal.runPascal) (Pascal.solve "3+5+10") @?= Right 18
    (fst . Pascal.runPascal) (Pascal.solve "3+5+10+220") @?= Right 238

malformedInput :: Test
malformedInput = TestLabel "malformedInput" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve "")
        @?= Left "unexpected end of input"
    (fst . Pascal.runPascal) (Pascal.solve "x") @?= Left "unexpected x"
    (fst . Pascal.runPascal) (Pascal.solve "+2") @?= Left "unexpected +"
    (fst . Pascal.runPascal) (Pascal.solve "+") @?= Left "unexpected +"
    (fst . Pascal.runPascal) (Pascal.solve "1+0+1+")
        @?= Left "unexpected end of input"
    (fst . Pascal.runPascal) (Pascal.solve "0+1+3+")
        @?= Left "unexpected end of input"
    (fst . Pascal.runPascal) (Pascal.solve "3+5+10a") @?= Left "unexpected a"

concatComputations :: Test
concatComputations = TestLabel "concatComputations" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve "1+1+1" >> Pascal.solve "1+0+1")
        @?= Right 2

checkMemory :: Test
checkMemory = TestLabel "checkMemory" $ TestCase $ do
    (fst . Pascal.runPascal) (Pascal.solve expression'
                              >> Pascal.solve expression''
                              >> Pascal.solve expression'' >> Pascal.getMemory)
        @?= Right (Pascal.Memory [ (expression'', 2), (expression', 3) ] 4)
  where
    expression' = "1+1+1"

    expression'' = "1+0+1"

checkWriter :: Test
checkWriter = TestLabel "checkWriter" $ TestCase $ do
    (snd . Pascal.runPascal) (Pascal.solve expression'
                              >> Pascal.solve expression''
                              >> Pascal.solve expression'')
        @?= ":reading memory:parsing expression " ++ expression'
        ++ ":reading memory:parsing expression " ++ expression''
        ++ ":reading memory:using memory for expression " ++ expression''
  where
    expression' = "1+1+1"

    expression'' = "1+0+1"
