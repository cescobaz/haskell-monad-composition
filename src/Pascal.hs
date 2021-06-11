module Pascal where

import           Data.Char

data Operation = Add | Subtract | Divide | Multiply

data Sign = Plus | Minus

type PascalM a = Either String a

solve :: String -> PascalM Int
solve exp = solve' exp >>= \(_, result) -> return result

solve' :: String -> PascalM (String, Int)
solve' exp = do
    (exp', sign) <- parseSign exp
    (exp'', number) <- parseNumber exp'
    return (exp'', number)

parseSign :: String -> PascalM (String, Sign)
parseSign ('+' : xs) = return (xs, Plus)
parseSign ('-' : xs) = return (xs, Minus)
parseSign exp = return (exp, Plus)

parseOperation :: String -> PascalM (String, Operation)
parseOperation ('+' : xs) = return (xs, Add)
parseOperation ('-' : xs) = return (xs, Subtract)
parseOperation ('/' : xs) = return (xs, Divide)
parseOperation ('*' : xs) = return (xs, Multiply)
parseOperation _ = Left "unabel to parseOperation"

parseNumber :: String -> PascalM (String, Int)
parseNumber = parseNumber' ""

parseNumber' :: String -> String -> PascalM (String, Int)
parseNumber' "" "" = Left "parseNumber': end of input"
parseNumber' s "" = return ("", read s)
parseNumber' s exp@(x : xs)
    | isDigit x = parseNumber' (s ++ [ x ]) xs
    | otherwise = return (exp, read s)
