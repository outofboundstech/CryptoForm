module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Identities as Identities exposing (Identity, Msg(Select), selected)

import CryptoForm.Mailman as Mailman

import CryptoForm.Sender as Sender
import CryptoForm.Email as Email

import ElmPGP.Ports exposing (encrypt, ciphertext)

import Html exposing (Html, a, button, code, div, form, hr, input, li, p, section, span, strong, text, ul)
import Html.Attributes exposing ( attribute, class, disabled, for, href, id, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)


type alias Model =
  { base_url: String
  , identities: Identities.Model
  , sender: Sender.Model
  , email: Email.Model
  }


type Msg
  = UpdateIdentities Identities.Msg
  | UpdateSender Sender.Msg
  | UpdateEmail Email.Msg
  | Stage
  | Send String
  | Mailman Mailman.Msg
  | Reset


view : Model -> Html Msg
view model =
  form []
    [ sectionView "Tell us about yourself" []
      [ Html.map UpdateSender (Sender.view model.sender) ]
    , sectionView "Compose your email" []
      [ identitiesView model.identities
      , verifierView model.identities
      , Html.map UpdateEmail (Email.view model.email)
      ]
    , div [ class "btn-toolbar" ]
      [ button [ class "btn btn-lg btn-primary", onClick Stage, disabled (not (ready model)) ] [ text "Send" ]
      , button [ class "btn btn-lg btn-danger", onClick Reset ] [ text "Reset" ]
      ]
    ]


sectionView : String -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
sectionView title attr dom =
  section attr (
    [ hr [] []
    , p [] [ strong [] [ text title ] ]
    ] ++ dom )


identitiesView : Identities.Model -> Html Msg
identitiesView model =
  let
    description = case (selected model) of
      Just identity ->
        Identities.description identity
      Nothing ->
        ""
  in
    div [ class "form-group"]
      [ div [ class "input-group" ]
        [ div [ class "input-group-btn" ]
          [ button [ type_ "button", class "btn btn-default btn-primary dropdown-toggle", disabled (not <| Identities.ready model), attribute "data-toggle" "dropdown", style [ ("min-width", "75px"), ("text-align", "right") ] ]
            [ text "To "
            , span [ class "caret" ] []
            ]
          , ul [ class "dropdown-menu" ]
            (List.map (\identity -> li [] [ a [ href "#", onClick <| UpdateIdentities (Select identity) ] [ text (Identities.description identity) ] ] ) (Identities.identities model))
          ]
        , input [ type_ "text", class "form-control", value description, disabled True, placeholder "Select your addressee..." ] [ ]
        ]
      ]


verifierView : Identities.Model -> Html Msg
verifierView model =
  let
    verifier = Identities.verifier model
    view = \cls fingerprint expl ->
      div [ class cls ]
        [ strong [] [ text "Fingerprint: " ]
        , code [] [ text ( Identities.friendly fingerprint ) ]
        , p [] [ text expl ]
        ]
  in
    case verifier of
      Just ( fingerprint, True ) ->
        view "alert alert-success" fingerprint """
To ensure only the intended recipient can read you e-mail, check with him/her if
this is the correct key fingerprint. Some people mention their fingerprint on
business cards or in email signatures. The fingerprint listed here matches the
one reported for this recipient by the server."""

      Just ( fingerprint, False ) ->
        view "alert alert-danger" fingerprint """
This fingerprint does not match the one reported for this recipient by the
server. To ensure only the intended recipient can read you e-mail, check with
him/her if this is the correct key fingerprint. Some people mention their
fingerprint on business cards or in email signatures."""

      Nothing ->
        div [ class "alert hidden" ] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateIdentities a ->
      let
        ( identities, cmd ) = Identities.update a model.identities
      in
        ( { model | identities = identities }, Cmd.map UpdateIdentities cmd )

    UpdateSender a ->
      let
        ( sender, cmd ) = Sender.update a model.sender
      in
        ( { model | sender = sender }, Cmd.map UpdateSender cmd )

    UpdateEmail a ->
      let
        ( email, cmd ) = Email.update a model.email
      in
        ( { model | email = email}, Cmd.map UpdateEmail cmd )

    Stage ->
      let
        cmd = case (selected model.identities) of
          Just identity ->
            encrypt
              { data = Email.body model.email
              , publicKeys = Identities.publicKey identity
              , privateKeys = ""
              , armor = True
              }
          Nothing ->
            Cmd.none
      in
        ( model, cmd )

    Send ciphertext ->
      let
        payload =
          [ ("from", Sender.from model.sender)
          , ("subject", Email.subject model.email)
          , ("text", ciphertext)
          ]
        cmd = case (selected model.identities) of
          Just identity ->
            Mailman.send identity payload model.base_url
          Nothing ->
            Cmd.none
      in
        ( model, Cmd.map Mailman cmd )

    Mailman a ->
      let
        cmd = Mailman.update a
      in
        ( model, Cmd.map Mailman cmd )

    Reset ->
      ( reset model, Cmd.none )


ready : Model -> Bool
ready model =
  Nothing /= (selected model.identities)
  && Sender.ready model.sender
  && Email.ready model.email


init : String -> ( Model, Cmd Msg )
init base_url =
  let
    ( identities, identities_cmd ) = Identities.init base_url
    ( sender, sender_cmd ) = Sender.init
    ( email, email_cmd ) = Email.init
    cmd = Cmd.batch
      [ Cmd.map UpdateIdentities identities_cmd
      , Cmd.map UpdateSender sender_cmd
      , Cmd.map UpdateEmail email_cmd
      ]
  in
    ( { base_url = base_url
      , identities = identities
      , sender = sender
      , email = email
      } , cmd )


reset : Model -> Model
reset model =
  { base_url = model.base_url
  , identities = Identities.reset model.identities
  , sender = Sender.reset
  , email = Email.reset
  }


{-| main
-}
main : Program Never Model Msg
main =
  Html.program
    { init = init "http://localhost:4000/api/"
    , view = view
    , update = update
    , subscriptions = always (Sub.batch
      [ ElmPGP.Ports.ciphertext Send
      , Sub.map UpdateIdentities Identities.subscriptions
      ])
    }
