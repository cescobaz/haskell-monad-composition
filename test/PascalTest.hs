module PascalTest ( test ) where

import qualified Pascal

import           Test.HUnit.Base hiding ( test )

test :: Test
test = TestList [ justNumber, simpleSum, doubleSum, doubleSubstract ]

justNumber :: Test
justNumber = TestLabel "justNumber" $ TestCase $ do
    Pascal.solve "0" @?= Right 0
    Pascal.solve "1" @?= Right 1
    Pascal.solve "4" @?= Right 4
    Pascal.solve "42" @?= Right 42
    Pascal.solve "420" @?= Right 420
    Pascal.solve "0420" @?= Right 420

simpleSum :: Test
simpleSum = TestLabel "simpleSum" $ TestCase $ do
    Pascal.solve "1+1" @?= Right 2
    Pascal.solve "1+0" @?= Right 1
    Pascal.solve "0+1" @?= Right 1
    Pascal.solve "3+5" @?= Right 8

doubleSum :: Test
doubleSum = TestLabel "doubleSum" $ TestCase $ do
    Pascal.solve "1+1+1" @?= Right 3
    Pascal.solve "1+0+1" @?= Right 2
    Pascal.solve "0+1+3" @?= Right 4
    Pascal.solve "3+5+10" @?= Right 18

doubleSubstract :: Test
doubleSubstract = TestLabel "doubleSubstract" $ TestCase $ do
    Pascal.solve "1-1-1" @?= Right (-1)
    Pascal.solve "1-0-1" @?= Right 0
    Pascal.solve "0-1-3" @?= Right (-4)
    Pascal.solve "3-5-10" @?= Right (-12)
