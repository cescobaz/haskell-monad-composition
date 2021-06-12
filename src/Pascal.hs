module Pascal where

import           Control.Monad.Trans.Except

import           Data.Char                  ( isDigit )
import           Data.Functor.Identity

type PascalT m a = ExceptT String m a

 -- `run*T` run Transformation so compute the value and pop the inner `m` monad to outside, ready to be runned by an other run*T
runPascalT :: (Monad m) => PascalT m a -> m (Either String a)
runPascalT = runExceptT

-- close the top of composition with Identity monad
type PascalM a = PascalT Identity a

runPascal :: PascalM a -> Either String a
runPascal = runIdentity . runPascalT -- run the inside monad transformer (PascalT) then the external one Identity

solve :: String -> PascalM Int
solve = parseNumber ""

parseNumber :: String -> String -> PascalM Int
parseNumber "" "" = throwE "unexpected end of input"
parseNumber s "" = return (read s)
parseNumber s (x : xs)
    | isDigit x = parseNumber (s ++ [ x ]) xs
    | x == '+' && not (null s) = do
        r <- parseNumber "" xs
        return (l + r)
    | otherwise = throwE ("unexpected " ++ [ x ])
  where
    l = read s
