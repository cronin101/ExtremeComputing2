import Data.List (lines, unlines)
import Data.List.Split (splitOn)
import Data.String.Utils (join)
import Control.Monad (liftM2)

-- Lazily read (without_tabs, uppercased) from STDIN and feed to
-- STDOUT iff the uppercased text is not the same as the previous line.
main = interact $ unlines . map snd . uniqueKeys . tups . lines
  where
    tups = map (liftM2 (,) head (join "\t" . tail) . splitOn "\t")
    uniqueKeys (t:ts) = t : unique t ts
      where
        unique _ [] = []
        unique last (tup:tups)
          | snd last == snd tup = unique last tups
          | otherwise           = tup : unique tup tups
