import Data.Char (toUpper)
import Data.List (lines, unlines)

-- Lazily uppercase each line of STDIN and feed to STDOUT
main = interact $ unlines . map (map toUpper) . lines
