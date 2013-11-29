import System.IO (getContents)
import Data.Char (toUpper)
import Data.List (lines, unlines)
import Data.Hash.MD5
import Control.Monad

main = interact $ unlines . map (ap ((++) . md5s . Str) (('\t' :) . map toUpper)) . lines
