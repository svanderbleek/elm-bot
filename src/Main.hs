module Main where

import qualified System.IO.Silently as Sys
import qualified Environment as Env
import qualified Eval.Code as Elm

main :: IO ()
main = eval "1" >>= print

eval :: String -> IO String
eval s = fst <$> Sys.capture (run s)

run :: String -> IO ()
run s = Env.run (Env.empty "elm-make" "node") (Elm.eval (Nothing, s))
