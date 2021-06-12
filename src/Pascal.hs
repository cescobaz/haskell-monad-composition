module Pascal where

import           Control.Monad.Trans.Class      ( lift )
import           Control.Monad.Trans.Except
import           Control.Monad.Trans.State.Lazy

import           Data.Char                      ( isDigit )
import           Data.Functor.Identity

data Memory = Memory { expressions :: [(String, Int)], computations :: Int }
    deriving ( Show, Eq )

addExpression :: (String, Int) -> Memory -> Memory
addExpression expression memory =
    memory { expressions = ((:) expression . expressions) memory }

incrementComputations :: Memory -> Memory
incrementComputations memory =
    memory { computations = ((+) 1 . computations) memory }

type PascalT m a = ExceptT String (StateT Memory m) a

 -- `run*T` run Transformation so compute the value and pop the inner `m` monad to outside, ready to be runned by an other run*T
runPascalT :: (Monad m) => PascalT m a -> Memory -> m (Either String a)
runPascalT m = evalStateT (runExceptT m)

-- close the top of composition with Identity monad
type PascalM a = PascalT Identity a

runPascal :: PascalM a -> Either String a
runPascal m = runIdentity (runPascalT m (Memory [] 0)) -- run the inside monad transformer (PascalT) then the external one Identity

solve :: String -> PascalM Int
solve input = do
    memory <- lift $ gets (lookup input . expressions)
    case memory of
        Just result -> return result
        Nothing -> do
            result <- parseNumber "" input
            lift $ modify (addExpression (input, result))
            return result

getMemory :: PascalM Memory
getMemory = lift get

parseNumber :: String -> String -> PascalM Int
parseNumber "" "" = throwE "unexpected end of input" -- I can use ExceptT monad function
parseNumber s "" = return (read s)
parseNumber s (x : xs)
    | isDigit x = parseNumber (s ++ [ x ]) xs
    | x == '+' && not (null s) = do
        r <- parseNumber "" xs
        lift $ modify incrementComputations
        return (l + r)
    | otherwise = throwE ("unexpected " ++ [ x ])
  where
    l = read s
