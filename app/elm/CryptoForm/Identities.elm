module CryptoForm.Identities exposing
  ( view
  , Fingerprint, Identity
  , Context, context
  , Config, config
  , fetchIdentities, fetchPublickey
  , find, description, fingerprint, publicKey, setPublicKey, default
  , normalize, prettyPrint
  )

{-| CryptoForm Identities
-}

import Html exposing (Html, select, option, text)
import Html.Attributes as Attr
import Html.Events exposing (on, targetValue)

import Http


import Json.Decode as Decode
-- import Json.Encode as Encode


type alias Fingerprint = String


type Identity =
  Identity
    { fingerprint : Fingerprint
    , desc : String
    , pub : String
    , default : Bool
    }


identity : Fingerprint -> String -> String -> Bool -> Identity
identity fingerprint desc pub default =
  Identity
    { fingerprint = fingerprint
    , desc = desc
    , pub = pub
    , default = default
    }


type Context msg =
  Context
    { baseUrl : String
    , idsMsg : Result Http.Error (List Identity) -> msg
    , keyMsg : Identity -> Result Http.Error String -> msg
    }


context
  : { baseUrl : String
    , idsMsg : Result Http.Error (List Identity) -> msg
    , keyMsg : Identity -> Result Http.Error String -> msg
    }
  -> Context msg
context { baseUrl, idsMsg, keyMsg } =
  Context
    { baseUrl = baseUrl
    , idsMsg = idsMsg
    , keyMsg = keyMsg
    }


type Config msg =
  Config
    { msg : Fingerprint -> msg
    , state : Maybe Identity
    , class : String
    , style : List (String, String)
    }


config : { msg : Fingerprint -> msg, state : Maybe Identity, class : String , style : List (String, String) } -> Config msg
config { msg, state, class, style } =
  Config
    { msg = msg
    , state = state
    , class = class
    , style = style
    }


view : Config msg -> List Identity -> Html msg
view ( Config { msg, state, class, style } ) identities =
  let
    event = on "change" (Decode.map msg targetValue)
    options = List.map (\id ->
      option [ Attr.value (fingerprint id), Attr.selected (state == Just id)]
        [ text (description id)
        ]
      ) identities
  in
    select [ event, Attr.class class, Attr.style style ]
      ( option [ Attr.value "", Attr.selected (Nothing == state) ]
        [ text "-- Please select --" ] :: options
      )


-- API client functionality
fetchIdentities : Context msg -> Cmd msg
fetchIdentities ( Context { baseUrl, idsMsg } ) =
  let
    request = Http.get (baseUrl ++ "keys/") decodeIdentities
  in
    Http.send idsMsg request


fetchPublickey : Context msg -> Identity -> Cmd msg
fetchPublickey ( Context { baseUrl, keyMsg } ) identity =
  let
    request = Http.getString (baseUrl ++ "keys/" ++ (fingerprint identity))
  in
    Http.send (keyMsg identity) request


-- reportViolation : Context msg -> Identity -> String -> Cmd msg
-- reportViolation ( Context {} ) identity local =
--   let
--     values =
--       [ ("message", "Fingerprint mismatch")
--       , ("server_id", remote)
--       , ("fingerprint", fingerprint identity)
--       , ("info", description identity)
--       , ("pub", publicKey identity)
--       , ("description", """
-- The local PGP library (OpenPGP.js v2.3.5) returned a different fingerprint for
-- this identity than the fingerprint reported by the server (server_id).""")
--       ]
--     payload = List.map (\(k, v) -> (k, Encode.string v)) values
--     request = Http.post (model.base_url ++ "keys/report") (Http.jsonBody (Encode.object payload)) Decode.string
--   in
--     Http.send _ request


-- Decoders
decodeIdentities : Decode.Decoder (List Identity)
decodeIdentities =
  Decode.at [ "keys" ] (
    Decode.list (
      Decode.map4 identity
        ( Decode.field "fingerprint" Decode.string )
        ( Decode.field "desc" Decode.string )
        ( Decode.succeed "" ) -- pub as empty string
        ( Decode.field "default" Decode.bool )
    )
  )


-- find Identity by Fingerprint
find : Fingerprint -> List Identity -> Maybe Identity
find match identities =
  case (List.head identities) of
    Nothing ->
      Nothing

    Just ( identity ) ->
      if (fingerprint identity) == match then
        Just identity
      else
        find match (Maybe.withDefault [] <| List.tail identities)


-- 'getter' functions for Identity type
default : Identity -> Bool
default ( Identity { default } ) =
  default


description : Identity ->  String
description ( Identity { desc } ) =
  desc


fingerprint : Identity -> Fingerprint
fingerprint ( Identity { fingerprint } ) =
  fingerprint


publicKey : Identity -> String
publicKey ( Identity { pub } ) =
  pub


setPublicKey : String -> Identity -> Identity
setPublicKey pub ( Identity identity ) =
  Identity { identity | pub = pub }


-- Additional fingerprint helper functions
normalize : Fingerprint -> String
normalize fingerprint =
  fingerprint
    |> String.toUpper
    |> String.trim


prettyPrint : Fingerprint -> String
prettyPrint =
  String.foldr
    (\c s ->
      if 0 == rem (1+(String.length s)) 5
      then String.cons c (String.cons ' ' s)
      else String.cons c s
    ) ""
