module CryptoForm.Recipient exposing ( Model, Msg, view, update, init, blank, fingerprint, publicKey, validate, ready )

{-| CryptoForm Recipient
-}

import Html exposing (Html, div, span, button, input, ul, li, a, text)
import Html.Attributes exposing (attribute, id, type_, class, style, value, placeholder, disabled, href)
import Html.Events exposing (onClick)

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
  { identities: (List Identity)
  , to: Maybe String  -- Tracked internally by fingerprint
  }


{-| Model transformations
-}
type Msg
  = SetIdentities (Result Http.Error (List Identity))
  | SetPublickey Identity (Result Http.Error String)
  | SetAddressee Identity
  | Reset
  | NoOp


{-| view
-}
view : Model -> Html Msg
view model =
  let
    desc =
      case description model of
        Just string ->
          string
        Nothing ->
          ""

  in
    div [ class "form-group" ]
      [ div [ class "input-group" ]
          [ div [ class "input-group-btn" ]
              [ button [ type_ "button", class "btn btn-default btn-primary dropdown-toggle", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false", style [ ("min-width", "75px"), ("text-align", "right") ] ]
                  [ text "To "
                  , span [ class "caret" ] []
                  ]
              , ul [ class "dropdown-menu" ] (identitiesView model.identities)
              ]
          , input [ type_ "text", class "form-control", value desc, disabled True, placeholder "Select a recipient...", attribute "aria-label" "..." ] [ ]
          ]
      ]


identitiesView : (List Identity) -> List (Html Msg)
identitiesView identities =
  List.map (\identity -> li [] [ a [ href "#", onClick (SetAddressee identity) ] [ text identity.description ] ] ) identities


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetPublickey identity (Ok pub) ->
      -- This is where the magic takes place...
      let
        replace = \n ->
          if n.fingerprint == identity.fingerprint then
            { n | pub = Just pub }
          else
            n
        identities = List.map replace model.identities
      in
        ( { model | identities = identities }, Cmd.none )

    SetPublickey _ (Err _) ->
      -- Report failure to obtain public key
      ( model, Cmd.none )

    SetIdentities (Ok identities) ->
      ( { model | identities = identities } , Cmd.none )

    SetIdentities (Err _) ->
      -- Report failure to obtain identities/recipients
      ( model, Cmd.none )

    SetAddressee identity ->
      ( { model | to = Just identity.fingerprint }, fetchPublickey identity )

    Reset ->
      ( blank, Cmd.none )

    NoOp ->
      ( model, Cmd.none )


{-| init
-}
init : ( Model, Cmd Msg )
init =
  ( blank, fetchIdentities )


blank : Model
blank =
  { identities = [], to = Nothing }


{-| Additional helper functions
-}
fetchPublickey : Identity -> Cmd Msg
fetchPublickey identity =
  case identity.pub of
    Just _ ->
      Cmd.none

    Nothing ->
      let
        request =
          Http.getString ("http://localhost:4000/api/keys/" ++  identity.fingerprint)
      in
        Http.send (SetPublickey identity) request


fetchIdentities : Cmd Msg
fetchIdentities =
  let
    request =
      Http.get "http://localhost:4000/api/keys" decodeIdentities
  in
    Http.send SetIdentities request


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


{-| identity_
-}
identity_ : String -> (List Identity) -> Maybe Identity
identity_ fingerprint identities =
  let
    reduce = \n identity ->
      if n.fingerprint == fingerprint then
        Just n
      else
        identity
  in
    -- Can I shortcut this recursion when found?
    List.foldl reduce Nothing identities


{-| description
-}
description : Model -> Maybe String
description model =
  case model.to of
    Just fingerprint ->
      let
        result = identity_ fingerprint model.identities
      in
        case result of
          Nothing ->
            Nothing

          Just identity ->
            Just identity.description

    Nothing ->
      Nothing


{-| publicKey
-}
fingerprint : Model -> Maybe String
fingerprint model =
  model.to


{-| publicKey
-}
publicKey : Model -> Maybe String
publicKey model =
  case model.to of
    Just fingerprint ->
      let
        result = identity_ fingerprint model.identities
      in
        case result of
          Nothing ->
            Nothing

          Just identity ->
            identity.pub

    Nothing ->
      Nothing


{-| validate
-}
validate : Model -> List String
validate model =
  case publicKey model of
    Nothing ->
      [ "Please select a recipient" ]

    Just _ ->
      []


{-| ready
-}
ready : Model -> Bool
ready model =
  case validate model of
    [] ->
      True

    _ ->
      False
