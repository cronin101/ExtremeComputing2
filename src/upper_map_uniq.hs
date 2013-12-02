import Data.Char (toUpper)
import Data.List (lines, unlines)

-- Lazily replace lines of STDIN with (line_without_tabs,uppercased_line)
-- and feed to STDOUT.
main = interact $ unlines . map (\l -> keyF l ++ "\t" ++ valueF l) . lines
  where
    keyF   = filter (/= '\t') . valueF
    valueF = map toUpper
