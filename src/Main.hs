module Main where

import qualified ElmBot
import qualified Network.Wai.Handler.Warp as Warp
import qualified Slash
import System.Environment as Env

main :: IO ()
main = 
  do
    port <- getArgs
    Warp.run (read . head $ port) (Slash.app handler)

handler :: Slash.Command -> IO Slash.Response
handler (Slash.Command text) =
  do
    repl <- ElmBot.eval text
    return $ Slash.Response repl Slash.InChannel
