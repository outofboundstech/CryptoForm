module CryptoForm.Composer exposing ( Model, Msg, view, update, init, blank, body, subject, validate, ready )

{-| CryptoForm Composer
-}

import Html exposing (Html, div, span, label, input, textarea, text)
import Html.Attributes exposing (attribute, id, type_, for, class, value, style, placeholder)
import Html.Events exposing (onInput, targetValue)


{-| model
-}
type alias Model =
  { subject: String
  , body: String
  }


{-| Model transformations
-}
type Msg
  = SetSubject String
  | SetBody String
  | Reset
  | NoOp


{-| view
-}
view : Model -> Html Msg
view model =
  div []
    [ div [ class "form-group" ]
        [ div [ class "input-group" ]
            [ span [ id "subject-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "Subject" ]
            , input [ type_ "text", class "form-control", onInput SetSubject, value model.subject, placeholder "Subject", attribute "aria-describedby" "subject-addon" ] []
            ]
        ]
    , div [ class "form-group" ]
        [ label [ for "body-input" ] [ text "Compose" ]
        , textarea [ id "body-input", class "form-control", onInput SetBody, value model.body ] []
        ]
    ]


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetSubject text ->
      ( { model | subject = text }, Cmd.none )

    SetBody text ->
      ( { model | body = text }, Cmd.none )

    Reset ->
      ( blank, Cmd.none )

    NoOp ->
      ( model, Cmd.none )


{-| init
-}
init : ( Model, Cmd Msg )
init =
  ( blank, Cmd.none )


blank : Model
blank =
  { subject = "", body = "" }


{-| subject
-}
subject : Model -> String
subject model =
  model.subject


{-| body
-}
body : Model -> String
body model =
  model.body


{-| validate
-}
validate : Model -> List String
validate model =
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
