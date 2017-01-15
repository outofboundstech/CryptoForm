module CryptoForm.Identities exposing
  ( Identity, Model, Msg(Select), update, init, reset
  , identities, progress, ready
  , selected, description, publicKey
  , fingerprint, normal, friendly, verifier
  , subscriptions )

{-| CryptoForm Identities
-}

import Http

import Json.Decode as Decode

import ElmPGP.Ports exposing (verify, fingerprint)


type alias Identity =
  { fingerprint : String
  , description : String
  , pub : String
  }


type alias Model =
  { base_url: String
  , progress: (Int, Int)
  , identities: (List Identity)
  , selected: Maybe Identity
  , verifier: Maybe ( String, Bool )
  }


type Msg
  = SetIdentities (Result Http.Error (List Identity))
  | SetPublickey Identity (Result Http.Error String)
  | Select Identity
  | Verify ( String, String )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetIdentities (Ok identities) ->
      let
        cmd = Cmd.batch (List.map (fetchPublickey model.base_url) identities)
        progress = (List.length identities, 0)
      in
        ( { model | progress = progress }, cmd )

    SetIdentities (Err _) ->
      -- Report failure to obtain identities
      ( model, Cmd.none )

    SetPublickey identity (Ok pub) ->
      let
        identities = { identity | pub = pub } :: model.identities
        (target, current) = model.progress
        progress = (target, current+1)
      in
        ( { model | identities = identities, progress = progress }, Cmd.none )

    SetPublickey _ (Err _) ->
      let
        -- Report failure to obtain public key
        (target, current) = model.progress
        progress = (target-1, current)
      in
        ( { model | progress = progress }, Cmd.none )

    Select identity ->
      let
        cmd = verify (identity.pub, identity.fingerprint)
      in
        ( { model | selected = Just identity, verifier = Nothing }, cmd )

    Verify ( remote, raw ) ->
      let
        local = normal raw
        verifier = case (selected model) of
          Just identity ->
            if remote == identity.fingerprint then
              Just ( local, local == remote )
            else
              -- Leave verifier as is...
              model.verifier
          Nothing ->
            Nothing
      in
        ( { model | verifier = verifier }, Cmd.none )


init : String -> ( Model, Cmd Msg )
init base_url =
  let
    model =
      { base_url = base_url
      , progress = (0, 0)
      , identities = []
      , selected = Nothing
      , verifier = Nothing
      }
  in
    ( model, fetchIdentities base_url )


reset : Model -> Model
reset model =
  { model | selected = Nothing, verifier = Nothing }


identities : Model -> (List Identity)
identities model =
  model.identities


progress : Model -> Float
progress model =
  let
    (target, current) = model.progress
  in
    if target > 0 then
      (toFloat current) / (toFloat target)
    else
      0.0


ready : Model -> Bool
ready model =
  let
    (target, current) = model.progress
  in
    current == target
    && current > 0


selected : Model -> Maybe Identity
selected model =
  model.selected


description : Identity ->  String
description identity =
  identity.description


publicKey : Identity -> String
publicKey identity =
  identity.pub


fingerprint : Identity -> String
fingerprint identity =
  identity.fingerprint


normal : String -> String
normal fingerprint =
  fingerprint
    |> String.toUpper
    |> String.trim


friendly : String -> String
friendly =
  String.foldr
    (\c s ->
      if 0 == rem (1+(String.length s)) 5
      then String.cons c (String.cons ' ' s)
      else String.cons c s
    ) ""


verifier : Model -> Maybe ( String, Bool )
verifier model =
  model.verifier


decodeIdentities : Decode.Decoder (List Identity)
decodeIdentities =
  Decode.at [ "keys" ] (
    Decode.list (
      Decode.map3 Identity
        ( Decode.field "fingerprint" Decode.string )
        ( Decode.field "desc" Decode.string )
        -- pub as empty string
        ( Decode.succeed "" )
    )
  )


fetchIdentities : String -> Cmd Msg
fetchIdentities base_url =
  let
    request = Http.get (base_url ++ "keys/") decodeIdentities
  in
    Http.send SetIdentities request


fetchPublickey : String -> Identity -> Cmd Msg
fetchPublickey base_url identity =
  let
    request = Http.getString (base_url ++ "keys/" ++  identity.fingerprint)
  in
    Http.send (SetPublickey identity) request


subscriptions : Sub Msg
subscriptions =
  ElmPGP.Ports.fingerprint Verify
