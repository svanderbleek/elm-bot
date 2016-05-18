{-# LANGUAGE OverloadedStrings #-}

module Slash (app, Command(..), Response(..), ResponseType(..)) where

import Network.HTTP.Types (status200)
import Network.Wai (Application, Request, responseLBS)
import Network.Wai.Parse (Param, parseRequestBody, lbsBackEnd)
import Data.Maybe (fromMaybe)
import Data.Aeson (ToJSON(..), object, (.=), encode)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Lazy.Char8 as LS

type Handler = (Command -> IO Response)
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
  | SSLChecked

data Response = 
  Response ResponseText ResponseType

instance ToJSON ResponseType where
  toJSON InChannel = "in_channel"
  toJSON Ephemeral = "ephemeral"

instance ToJSON Response where
  toJSON (Response text responseType) =
    object 
    [ "text" .= text
    , "response_type" .= responseType ]

app :: Handler -> Application
app handler request respond =
  do 
    params <- parse request
    let request' = mkRequest params
    response <- mkResponse handler request'
    respond $ responseLBS status200 [] (toLBS response)

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

mkCommand :: [Param] -> Command
mkCommand params =
  Command $ S.unpack (param ("text","") params)

mkRequest :: [Param] -> SlackRequest
mkRequest params =
  if sslCheck params 
    then SSLCheck
    else CMD $ mkCommand params 

mkResponse :: Handler -> SlackRequest -> IO Response
mkResponse handler request =
  case request of
    SSLCheck -> return $ Response mempty SSLChecked
    (CMD command) -> handler command

toLBS :: Response -> LS.ByteString
toLBS response@(Response text responseType) = 
  case responseType of 
    SSLChecked -> LS.pack text
    _ -> encode response
