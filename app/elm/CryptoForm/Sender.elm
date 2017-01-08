module CryptoForm.Sender exposing ( Model, Msg, view, update, ready, init, reset, name, email, from )


import Html exposing (Html, div, fieldset, input, span, text)
import Html.Attributes exposing ( class, id, placeholder, style, type_, value)
import Html.Events exposing (onInput)


{-| model
-}
type alias Model =
  { name : String
  , email : String
  }


{-| Model transformations
-}
type Msg
  = UpdateName String
  | UpdateEmail String


{-| view
-}
view : Model -> Html Msg
view  model =
  fieldset []
    [ div [ class "form-group" ]
      [ div [ class "input-group" ]
        [ span [ id "from-name-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "Name" ]
        , input [ type_ "text", class "form-control", onInput UpdateName, value model.name, placeholder "Your name" ] []
        ]
      ]
    , div [ class "form-group" ]
      [ div [ class "input-group" ]
        [ span [ id "from-email-addon", class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text "From" ]
        , input [ type_ "email", class "form-control", onInput UpdateEmail, value model.email, placeholder "Your e-mail address" ] []
        ]
      ]
    ]


{-| update
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateName string ->
        ( { model | name = string }, Cmd.none )

    UpdateEmail string ->
      ( { model | email = string }, Cmd.none )


{-| ready
-}
ready : Model -> Bool
ready model =
  String.length model.name > 0
  -- Check email is a correct email address
  && String.length model.email > 0


{-| init
-}
init : ( Model, Cmd Msg )
init =
    ( reset, Cmd.none )


{-| reset
-}
reset : Model
reset =
  { name = ""
  , email = ""
  }


{-| name
-}
name : Model -> String
name model =
  model.name


{-| email
-}
email : Model -> String
email model =
  model.email


{-| from
-}
from : Model -> String
from model =
  -- Mail Example <mail@example.com>
  model.name
  ++ " <"
  ++ model.email
  ++ ">"
