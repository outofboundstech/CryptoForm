module CryptoForm.Mailman exposing ( Msg, send, update )


import Http

import Json.Decode as Decode
import Json.Encode as Encode


type Msg
  = Confirm (Result Http.Error String)


send : String -> List (String, String) -> Cmd Msg
send base_url kv =
  let
    payload = List.map (\(k, v) -> (k, Encode.string v)) kv
    request = Http.post (base_url ++ "mail/deliver") (Http.jsonBody (Encode.object payload)) Decode.string
  in
    Http.send Confirm request


update : Msg -> Cmd Msg
update msg =
  case msg of
    Confirm (Ok _) ->
      Cmd.none

    Confirm (Err _) ->
      Cmd.none
