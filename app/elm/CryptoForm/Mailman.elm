module CryptoForm.Mailman exposing ( send, config )


import Http

import Json.Decode as Decode
import Json.Encode as Encode

import CryptoForm.Identities exposing ( Identity, fingerprint )


type Config msg =
  Config
    { baseUrl : String
    , msg : Result Http.Error String -> msg
    }

config : { baseUrl : String, msg : Result Http.Error String -> msg } -> Config msg
config { baseUrl, msg } =
  Config { baseUrl = baseUrl, msg = msg }


send : Config msg -> List (String, String) ->  Identity -> Cmd msg
send (Config { baseUrl, msg }) values identity =
  let
    payload = List.map (\(k, v) -> (k, Encode.string v)) (("fingerprint", fingerprint identity) :: values)
    request = Http.post (baseUrl ++ "mail/deliver") (Http.jsonBody (Encode.object payload)) Decode.string
  in
    Http.send msg request
