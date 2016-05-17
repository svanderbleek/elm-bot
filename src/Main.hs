module Main where

import qualified ElmBot
import qualified Network.Wai.Handler.Warp as Warp
import qualified Slash

main :: IO ()
main = Warp.run 3333 (Slash.app handler)

handler :: Slash.Command -> IO Slash.Response
handler (Slash.Command text) =
  do
    repl <- ElmBot.eval text
    return $ Slash.Response repl Slash.InChannel
