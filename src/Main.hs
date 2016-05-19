module Main where

import qualified ElmBot
import qualified Network.Wai.Handler.Warp as Warp
import qualified Slash
import Slash (Command(..), Response(..), ResponseType(..))
import qualified System.Environment as Sys

main :: IO ()
main = 
  do
    args <- Sys.getArgs
    let port = read . head $ args
    Warp.run port (Slash.app handler)

handler :: Command -> IO Response
handler (Command text) =
  do
    text' <- ElmBot.eval text
    return $ Response text' InChannel
