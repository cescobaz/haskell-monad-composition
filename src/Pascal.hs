module Pascal where

import           Data.Char
import           Data.Maybe ( isJust )

type PascalM a = Either String a

solve :: String -> PascalM Int
solve = parseNumber ""

parseNumber :: String -> String -> PascalM Int
parseNumber "" "" = Left "unexpected end of input"
parseNumber s "" = return (read s)
parseNumber s input@(x : xs)
    | isDigit x = parseNumber (s ++ [ x ]) xs
    | x == '+' = do
        r <- parseNumber "" xs
        return (l + r)
    | otherwise = Left ("unexpected " ++ [ x ])
  where
    l = read s
