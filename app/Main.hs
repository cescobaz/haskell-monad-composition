module Main where

import           Pascal

import           System.Environment

main :: IO ()
main = do
    expression <- head <$> getArgs
    let (result, output) = runPascal (solve expression)
    putStrLn output
    case result of
        Right r -> putStrLn ("result: " ++ show r)
        Left err -> putStrLn ("error: " ++ err)
