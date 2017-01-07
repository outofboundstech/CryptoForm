module CryptoForm.Identities exposing ( Identity, Model, Msg, update, init, ready, progress, identities, description, fingerprint, publicKey )

{-| CryptoForm Identities
-}

import Http

import Json.Decode as Decode


type alias Identity =
  { fingerprint : String
  , description : String
  , pub : Maybe String
  }


{-| model
-}
type alias Model =
  { base_url: String
  , progress: (Int, Int)
  , identities: (List Identity)
  }


{-| Model transformations
-}
type Msg
  = SetIdentities (Result Http.Error (List Identity))
  | SetPublickey Identity (Result Http.Error String)


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetIdentities (Ok identities) ->
      let
        cmd =
          -- Prefetch public keys (this is nice and elegant)
          -- Calls fetchPublickey even if pub already set
          Cmd.batch (List.map (fetchPublickey model.base_url) identities)
        progress =
          (List.length identities, 0)
      in
        ( { model | progress = progress }, cmd )

    SetIdentities (Err _) ->
      -- Report failure to obtain identities
      ( model, Cmd.none )

    SetPublickey identity (Ok pub) ->
      let
        identities =
          { identity | pub = Just pub } :: model.identities
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


{-| init
-}
init : String -> ( Model, Cmd Msg )
init base_url =
  let
    model =
      { base_url = base_url
      , progress = (0, 0)
      , identities = []
      }
  in
    ( model, fetchIdentities base_url )


ready : Model -> Bool
ready model =
  let
    (target, current) = model.progress
  in
    current == target
    && current > 0


progress : Model -> Float
progress model =
  let
    (target, current) = model.progress
  in
    if target > 0 then
      (toFloat current) / (toFloat target)
    else
      0.0


{-| identities
-}
identities : Model -> (List Identity)
identities model =
  model.identities


-- find : Model -> String -> Maybe Identity
-- find model fingerprint =
--   let
--     reduce = \n identity ->
--       if n.fingerprint == fingerprint then
--         Just n
--       else
--         identity
--   in
--     -- Can I shortcut this recursion when found?
--     List.foldl reduce Nothing model.identities


{-| description
-}
description : Identity -> String
description identity =
  identity.description


{-| publicKey
-}
fingerprint : Identity -> String
fingerprint identity =
  identity.fingerprint


{-| publicKey
-}
publicKey : Identity -> Maybe String
publicKey identity =
  identity.pub


{-| Additional helper functions
-}
decodeIdentities : Decode.Decoder (List Identity)
decodeIdentities =
  Decode.at [ "keys" ] (
    Decode.list (
      Decode.map3 Identity
        ( Decode.field "fingerprint" Decode.string )
        ( Decode.field "desc" Decode.string )
        ( Decode.maybe ( Decode.field "pub" Decode.string ) )
    )
  )


fetchIdentities : String -> Cmd Msg
fetchIdentities base_url =
  let
    request =
      Http.get (base_url ++ "keys/") decodeIdentities
  in
    Http.send SetIdentities request


fetchPublickey : String -> Identity -> Cmd Msg
fetchPublickey base_url identity =
  let
    request =
      Http.getString (base_url ++ "keys/" ++  identity.fingerprint)
  in
    Http.send (SetPublickey identity) request
