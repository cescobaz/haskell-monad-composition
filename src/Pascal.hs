module Pascal where

import           Data.Char
import           Data.Maybe ( isJust )

data Exp = Number Int | Sum Exp Exp

type PascalM a = Either String a

solve :: String -> PascalM Int
solve input = compute <$> parse input

parse :: String -> PascalM Exp
parse = parseNumber

parseNumber :: String -> PascalM Exp
parseNumber = parseNumber' ""

parseNumber' :: String -> String -> PascalM Exp
parseNumber' "" "" = Left "unexpected end of input"
parseNumber' s "" = return (Number (read s))
parseNumber' s input@(x : xs)
    | isDigit x = parseNumber' (s ++ [ x ]) xs
    | x == '+' = do
        r <- parse xs
        return (Sum l r)
    | otherwise = Left ("unexpected " ++ [ x ])
  where
    l = Number (read s)

compute :: Exp -> Int
compute (Number n) = n
compute (Sum l r) = compute l + compute r
