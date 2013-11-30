import Data.Char (toUpper)
import Data.List (lines, unlines)
import Data.Hash.MD5

main = interact $ unlines . map (\l -> keyF l ++ "\t" ++ valueF l) . lines
  where
    keyF   = md5s . Str . valueF
    valueF = map toUpper
