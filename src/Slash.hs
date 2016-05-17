{-# LANGUAGE OverloadedStrings #-}

module Slash (app, Command(..), Response(..), ResponseType(..)) where

import Network.HTTP.Types (status200)
import Network.Wai (Application, Request, responseLBS)
import Network.Wai.Parse (Param, parseRequestBody, lbsBackEnd)
import Data.Map (Map)
import Data.Maybe (fromMaybe)
import qualified Data.Map as Map
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Lazy.Char8 as LS

type CommandText = String
type ResponseText = String

data Command = 
  Command CommandText
  deriving (Show)

data SlackRequest 
  = CMD Command
  | SSLCheck
  deriving (Show)

data ResponseType 
  = InChannel 
  | Ephemeral

data Response = 
  Response ResponseText ResponseType

app :: (Command -> IO Response) -> Application
app handler request respond =
  do 
    params <- parse request
    let slackRequest = mkSlackRequest params
    respond (responseLBS status200 [] (LS.pack (show slackRequest)))

parse :: Request -> IO [Param]
parse request = 
  fst <$> parseRequestBody lbsBackEnd request

param :: Param -> [Param] -> BS.ByteString
param param params = 
  fromMaybe (snd param) (lookup (fst param) params)

sslCheck :: [Param] -> Bool
sslCheck params =
  case param ("ssl_check","0") params of
    "0" -> False
    "1" -> True

mkSlackRequest :: [Param] -> SlackRequest
mkSlackRequest params =
  if sslCheck params 
    then SSLCheck
    else CMD $ mkCommand params 

mkCommand :: [Param] -> Command
mkCommand params =
  Command $ S.unpack (param ("text","") params)
