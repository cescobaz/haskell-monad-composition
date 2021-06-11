module Pascal where

import           Data.Char
import           Data.Maybe ( isJust )

data Operation = Add | Subtract | Divide | Multiply

operationKList :: [(Char, Operation)]
operationKList =
    [ ('+', Add), ('-', Subtract), ('/', Divide), ('*', Multiply) ]

isOperation :: Char -> Bool
isOperation c = isJust (lookup c operationKList)

charToOperation :: Char -> PascalM Operation
charToOperation c =
    maybe (Left (c : " is not a operation")) return (lookup c operationKList)

data Sign = Plus | Minus

signKList :: [(Char, Sign)]
signKList = [ ('+', Plus), ('-', Minus) ]

isSign :: Char -> Bool
isSign c = isJust (lookup c signKList)

charToSign :: Char -> PascalM Sign
charToSign c = maybe (Left (c : " is not a sign")) return (lookup c signKList)

data Exp = Number Sign Int | Op Operation Exp Exp

type PascalM a = Either String a

solve :: String -> PascalM Int
solve input = compute <$> parse input

parse :: String -> PascalM Exp
parse (x : y : xs)
    | isSign x && isDigit y = charToSign x >>= flip parseNumber (y : xs)
parse (y : xs)
    | isDigit y = parseNumber Plus (y : xs)

parseNumber :: Sign -> String -> PascalM Exp
parseNumber sign = parseNumber' sign ""

parseNumber' :: Sign -> String -> String -> PascalM Exp
parseNumber' sign "" "" = Left "parseNumber': unexpected end of input"
parseNumber' sign s "" = return (Number sign (read s))
parseNumber' sign s input@(x : xs)
    | isDigit x = parseNumber' sign (s ++ [ x ]) xs
    | otherwise = parse input

compute :: Exp -> Int
compute (Number sign n) = n

