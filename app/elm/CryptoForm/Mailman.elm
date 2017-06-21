module CryptoForm.Mailman exposing ( send, config )


import Http

import Json.Decode as Decode
import Json.Encode as Encode

import CryptoForm.Identities exposing ( Identity, fingerprint )


type Config msg =
  Config
    { base_url : String
    , toMsg : Result Http.Error String -> msg
    }

config : { base_url : String, toMsg : Result Http.Error String -> msg } -> Config msg
config { base_url, toMsg } =
  Config { base_url = base_url, toMsg = toMsg }


send : Identity -> List (String, String) -> Config msg -> Cmd msg
send identity values (Config { base_url, toMsg }) =
  let
    payload = List.map (\(k, v) -> (k, Encode.string v)) (("fingerprint", fingerprint identity) :: values)
    request = Http.post (base_url ++ "mail/deliver") (Http.jsonBody (Encode.object payload)) Decode.string
  in
    Http.send toMsg request
