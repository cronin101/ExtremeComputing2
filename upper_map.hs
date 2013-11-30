import Data.Char (toUpper)
import Data.List (lines, unlines)

main = interact $ unlines . map (\l -> keyF l ++ "\t" ++ valueF l) . lines
  where
    keyF   = filter (/= '\t') . valueF
    valueF = map toUpper
