import Data.List (lines, unlines)
import Data.List.Split (splitOn)
import Data.String.Utils (join)

main = interact $ unlines . map dropKey . lines
  where
    dropKey = join "\t" . tail . splitOn "\t"
