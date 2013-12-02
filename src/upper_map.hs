import Data.Char (toUpper)
import Data.List (lines, unlines)

main = interact $ unlines . map (map toUpper) . lines
