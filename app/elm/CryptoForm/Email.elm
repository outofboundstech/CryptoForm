module CryptoForm.Email exposing (Model, Msg, view, update, ready, init, reset, subject, body)

import Html exposing (Html, div, fieldset, input, label, span, text, textarea)
import Html.Attributes exposing (class, for, id, placeholder, style, type_, value)
import Html.Events exposing (onInput)


{-| model
-}
type alias Model =
  { subject: String
  , body: String
  }


{-| Model transformations
-}
type Msg
  = UpdateSubject String
  | UpdateBody String


{-| view
-}
view : Model -> Html Msg
view model =
  fieldset []
    [ div [ class "form-group" ]
      [ div [ class "input-group" ]
        [ span [ id "subject-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "Subject" ]
        , input [ type_ "text", class "form-control", onInput UpdateSubject, value model.subject, placeholder "Subject" ] []
        ]
      ]
    , div [ class "form-group" ]
      [ textarea [ id "body-input", class "form-control", onInput UpdateBody, value model.body ] []
      ]
    ]


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateSubject string ->
      ( { model | subject = string }, Cmd.none )

    UpdateBody string ->
      ( { model | body = string }, Cmd.none )


{-| ready
-}
ready : Model -> Bool
ready model =
  String.length model.subject > 0
  && String.length model.body > 0


{-| init
-}
init : ( Model, Cmd Msg )
init =
    ( reset, Cmd.none )


{-| reset
-}
reset : Model
reset =
  { subject = ""
  , body = ""
  }


{-| subject
-}
subject : Model -> String
subject model =
  model.subject


{-| email
-}
body : Model -> String
body model =
  model.body
