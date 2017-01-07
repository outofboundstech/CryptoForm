module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Composer as Composer
import CryptoForm.Recipient as Recipient

import ElmPGP.Ports exposing (encrypt, ciphertext)

import Html exposing (Html, form, div, button, text)
import Html.Attributes exposing (attribute, class, disabled)
import Html.Events exposing (onClick)

import Http

import Json.Decode as Decode
import Json.Encode as Encode


{-| model
-}
type alias Model =
  { recipient: Recipient.Model
  , composer: Composer.Model
  }


{-| Model transformations
-}
type Msg
  = UpdateRecipient Recipient.Msg
  | UpdateComposer Composer.Msg
  | Reset
  | Stage
  | SetCiphertext String
  | Send String
  | Confirm (Result Http.Error String)
  | NoOp


{-| view
-}
view : Model -> Html Msg
view model =
  form []
    [ Html.map UpdateRecipient (Recipient.view model.recipient)
    , Html.map UpdateComposer (Composer.view model.composer)
    , div [ class "btn-toolbar", attribute "role" "group", attribute "aria-label" "Form controls" ]
        [ button [ class "btn btn-lg btn-primary", onClick Stage, disabled (not (ready model)) ] [ text "Send" ]
        , button [ class "btn btn-lg btn-danger", onClick Reset ] [ text "Reset" ]
        ]
    ]


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateRecipient a ->
      let
        ( recipient, cmd ) = Recipient.update a model.recipient
      in
        ( { model | recipient = recipient }
        , Cmd.map UpdateRecipient cmd
        )

    UpdateComposer a ->
      let
        ( composer, cmd ) = Composer.update a model.composer
      in
        ( { model | composer = composer }
        , Cmd.map UpdateComposer cmd
        )

    Reset ->
      ( blank, Cmd.none )

    Stage ->
      let
        -- I may not have to do this check if the form is correctly validated
        pub =
          case (Recipient.publicKey model.recipient) of
            Just key ->
              key
            Nothing ->
              ""  -- Need to throw an error

        payload =
          { data = Composer.body model.composer
          , publicKeys = pub
          , privateKeys = ""
          , armor = True
          }
      in
        ( model, encrypt payload )

    SetCiphertext ciphertext ->
      -- This is noop; just chain the (Send ciphertext) Msg
      update (Send ciphertext) model

    Send ciphertext ->
      let
        -- I may not have to do this check if the form is correctly validated
        fingerprint =
          case Recipient.fingerprint model.recipient of
            Just fingerprint_ ->
              fingerprint_
            Nothing ->
              ""  -- Need to throw an error

        payload = Encode.object
          [ ( "fingerprint", Encode.string fingerprint )
          , ( "subject", Encode.string (Composer.subject model.composer) )
          , ( "text", Encode.string ciphertext )
          ]
        request = Http.post "http://localhost:4000/api/mail/deliver" (Http.jsonBody payload) Decode.string
      in
        ( model, Http.send Confirm request )

    Confirm (Ok _) ->
      ( model, Cmd.none )

    Confirm (Err _) ->
      ( model, Cmd.none )

    NoOp ->
      ( model, Cmd.none )


{-| init
-}
init : ( Model, Cmd Msg )
init =
  let
    ( recipient, left_ ) = Recipient.init
    ( composer, right_ ) = Composer.init
  in
    ( { recipient = recipient, composer = composer }
    , Cmd.batch
      [ Cmd.map UpdateRecipient left_
      , Cmd.map UpdateComposer right_
      ]
    )


blank : Model
blank =
  { recipient = Recipient.blank, composer = Composer.blank }


{-| ready
-}
ready : Model -> Bool
ready model =
  Recipient.ready model.recipient && Composer.ready model.composer


{-| main
-}
main : Program Never Model Msg
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = always <| ElmPGP.Ports.ciphertext SetCiphertext
  }
