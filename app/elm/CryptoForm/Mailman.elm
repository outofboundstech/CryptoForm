module CryptoForm.Mailman exposing ( send, context )


import Http

import Json.Decode as Decode
import Json.Encode as Encode

import CryptoForm.Identities exposing ( Identity, fingerprint )


type Context msg =
  Context
    { baseUrl : String
    , msg : Result Http.Error String -> msg
    }

context : { baseUrl : String, msg : Result Http.Error String -> msg } -> Context msg
context { baseUrl, msg } =
  Context { baseUrl = baseUrl, msg = msg }


send : Context msg -> List (String, String) ->  Identity -> Cmd msg
send (Context { baseUrl, msg }) values identity =
  let
    payload = List.map (\(k, v) -> (k, Encode.string v)) (("fingerprint", fingerprint identity) :: values)
    request = Http.post (baseUrl ++ "mail/deliver") (Http.jsonBody (Encode.object payload)) Decode.string
  in
    Http.send msg request
