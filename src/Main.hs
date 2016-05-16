{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified ElmBot
import qualified Network.Linklater as Slack
import qualified Network.Wai.Handler.Warp as Warp
import Data.Text (Text, pack, unpack)
import Data.Maybe (fromMaybe)
import Control.Monad (liftM)

main :: IO ()
main = Warp.run 3333 $ Slack.slashSimple handler

handler :: Maybe Slack.Command -> IO Text
handler c = liftM pack $ ElmBot.eval $ unpack $ text c

text :: Maybe Slack.Command -> Text
text c = fromMaybe "" $ c >>= Slack._commandText
