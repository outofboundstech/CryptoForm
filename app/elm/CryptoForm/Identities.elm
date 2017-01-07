module CryptoForm.Identities exposing ( Identity, Model, Msg, update, init, identities, description, fingerprint, publicKey )

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
      -- Prefetch public keys
      let
        prefetch = Cmd.batch (List.map (fetchPublickey model.base_url) identities)
      in
        ( { model | identities = identities } , prefetch )

    SetIdentities (Err _) ->
      -- Report failure
      ( model, Cmd.none )

    SetPublickey identity (Ok pub) ->
      let
        replace = \n ->
          if n.fingerprint == identity.fingerprint then
            { n | pub = Just pub }
          else
            n
        -- Can I shortcut this recursion when found?
        identities = List.map replace model.identities
      in
        ( { model | identities = identities }, Cmd.none )

    SetPublickey _ (Err _) ->
      -- Report failure to obtain public key
      ( model, Cmd.none )


{-| init
-}
init : String -> ( Model, Cmd Msg )
init base_url =
  let
    model =
      { base_url = base_url
      , identities = []
      }
  in
    ( model, fetchIdentities base_url )


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
  case identity.pub of
    Just _ ->
      Cmd.none

    Nothing ->
      let
        request =
          Http.getString (base_url ++ "keys/" ++  identity.fingerprint)
      in
        Http.send (SetPublickey identity) request
