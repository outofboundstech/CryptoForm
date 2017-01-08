module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Identities as Identities
import CryptoForm.Identities exposing (Identity)

import CryptoForm.Mailman as Mailman

import ElmPGP.Ports exposing (encrypt, ciphertext)

import Html exposing (Html, a, button, div, form, hr, input, label, li, p, span, strong, text, textarea, ul)
import Html.Attributes exposing (attribute, class, disabled, for, href, id, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)


{-| model
-}
type alias Model =
  { base_url: String
  , identities: Identities.Model
  , from: (String, String)
  , to: Maybe Identity
  , subject: String
  , body: String
  }


{-| Model transformations
-}
type Msg
  = UpdateIdentities Identities.Msg
  | UpdateFromName String
  | UpdateFromEmail String
  | UpdateTo Identity
  | UpdateSubject String
  | UpdateBody String
  | Stage
  | Send String
  | Mailman Mailman.Msg
  | Reset


{-| view
-}
view : Model -> Html Msg
view model =
  let
    (from, email) = model.from
  in
    form []
      [ p []
        [ strong [] [ text "About yourself" ]
        ]
      , div [ class "form-group" ]
        [ div [ class "input-group" ]
          [ span [ id "from-name-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "Name" ]
          , input [ type_ "text", class "form-control", onInput UpdateFromName, value from, placeholder "Your name", attribute "aria-describedby" "from-name-addon" ] []
          ]
        ]
      , div [ class "form-group" ]
        [ div [ class "input-group" ]
          [ span [ id "from-email-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "From" ]
          , input [ type_ "email", class "form-control", onInput UpdateFromEmail, value email, placeholder "Your e-mail address", attribute "aria-describedby" "from-email-addon" ] []
          ]
        ]
      , hr [] []
      , p []
        [ strong [] [ text "Compose" ]
        ]
      , div [ class "form-group" ] [ identitiesView model ]
      , div [ class "form-group" ]
        [ div [ class "input-group" ]
          [ span [ id "subject-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "Subject" ]
          , input [ type_ "text", class "form-control", onInput UpdateSubject, value model.subject, placeholder "Subject", attribute "aria-describedby" "subject-addon" ] []
          ]
        ]
      , div [ class "form-group" ]
        [ label [ for "body-input" ] [ text "Message" ]
        , textarea [ id "body-input", class "form-control", onInput UpdateBody, value model.body ] []
        ]
      , div [ class "btn-toolbar", attribute "role" "group", attribute "aria-label" "Form controls" ]
        [ button [ class "btn btn-lg btn-primary", onClick Stage, disabled (not (ready model)) ] [ text "Send" ]
        , button [ class "btn btn-lg btn-danger", onClick Reset ] [ text "Reset" ]
        ]
      ]


identitiesView : Model -> Html Msg
identitiesView model =
  let
    loading =
      not (Identities.ready model.identities)
    identities =
      Identities.identities model.identities
    description =
      case model.to of
        Just identity ->
          Identities.description identity

        Nothing ->
          ""

  in
    div [ class "input-group" ]
      [ div [ class "input-group-btn" ]
        [ button [ type_ "button", class "btn btn-default btn-primary dropdown-toggle", disabled loading, attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false", style [ ("min-width", "75px"), ("text-align", "right") ] ]
          [ text "To "
          , span [ class "caret" ] []
          ]
        , ul [ class "dropdown-menu" ]
        (List.map (\identity -> li [] [ a [ href "#", onClick (UpdateTo identity) ] [ text identity.description ] ] ) identities)
        ]
      , input [ type_ "text", class "form-control", value description, disabled True, placeholder "Select a recipient...", attribute "aria-label" "..." ] [ ]
      ]



{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateIdentities a ->
      let
        ( identities, cmd ) =
          Identities.update a model.identities
      in
        ( { model | identities = identities }
        , Cmd.map UpdateIdentities cmd
        )

    UpdateFromName string ->
      let
        (_, email) = model.from
      in
        ( { model | from = (string, email) }, Cmd.none )

    UpdateFromEmail string ->
      let
        (name, _) = model.from
      in
        ( { model | from = (name, string) }, Cmd.none )

    UpdateTo identity ->
      ( { model | to = Just identity }, Cmd.none )

    UpdateSubject string ->
      ( { model | subject = string }, Cmd.none )

    UpdateBody string ->
      ( { model | body = string }, Cmd.none )

    Stage ->
      let
        cmd =
          case (Maybe.andThen Identities.publicKey model.to) of
            Just pub ->
              encrypt
                { data = model.body
                , publicKeys = pub
                , privateKeys = ""
                , armor = True
                }

            Nothing ->
              Cmd.none
      in
        ( model, cmd )

    Send ciphertext ->
      let
        cmd =
          case model.to of
            Just identity ->
              Mailman.send model.base_url
                [ ("fingerprint",  Identities.fingerprint identity)
                , ("subject", model.subject)
                , ("text", ciphertext)
                ]
            Nothing ->
              -- This shouldn't happen
              Cmd.none
      in
        ( model, Cmd.map Mailman cmd )

    Mailman a ->
      let
        cmd =
          Mailman.update a
      in
        ( model, Cmd.map Mailman cmd )

    Reset ->
      ( blank model, Cmd.none )


{-| ready
-}
ready : Model -> Bool
ready model =
  not (model.to == Nothing)
  && String.length model.subject > 0
  && String.length model.body > 0


{-| init
-}
init : String -> ( Model, Cmd Msg )
init base_url =
  let
    ( identities, cmd ) =
      Identities.init base_url
  in
    ( { base_url = base_url
      , identities = identities
      , from = ("", "")
      , to = Nothing
      , subject = ""
      , body = ""
      } , Cmd.map UpdateIdentities cmd )


blank : Model -> Model
blank model =
  { base_url = model.base_url
  , identities = model.identities
  , from = ("", "")
  , to = Nothing
  , subject = ""
  , body = ""
  }


{-| main
-}
main : Program Never Model Msg
main =
  Html.program
    { init = init "http://localhost:4000/api/"
    , view = view
    , update = update
    , subscriptions = always <| ElmPGP.Ports.ciphertext Send
    }
