module CryptoForm.Mailman exposing ( Msg, send, update )


import Http

import Json.Decode as Decode
import Json.Encode as Encode

import CryptoForm.Identities exposing ( Identity, fingerprint )


type Msg
  = Confirm (Result Http.Error String)


send : Identity -> List (String, String) -> String -> Cmd Msg
send identity values base_url =
  let
    payload = List.map (\(k, v) -> (k, Encode.string v)) (("fingerprint", fingerprint identity) :: values)
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
