import qualified PascalTest

import           Test.HUnit.Base ( Test(..) )
import           Test.HUnit.Text ( runTestTTAndExit )

main :: IO ()
main = runTestTTAndExit $ TestList [ PascalTest.test ]
