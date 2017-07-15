module CryptoForm.Form.Email exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import Html exposing (Html, div, label, text, textarea)
import Html.Attributes exposing (class, for, id, value)
import Html.Events exposing (onInput)


type Descriptor
  = Body String


type Model =
  Model
    { body : String
    }


update : Descriptor -> Model -> Model
update desc ( Model { body } )  =
  case desc of
    Body val ->
      Model { body = val }


view : Model -> Html Descriptor
view ( Model { body } ) =
  div [ class "row" ]
    [ div [ class "twelve columns"]
      [ label [ for "bodyInput" ] [ text "Compose" ]
      , textarea
        [ class "u-full-width"
        , id "bodyInput"
        , value body
        , onInput Body
        ] []
      ]
    ]


init : Model
init =
  Model { body = "" }


ready : Model -> Bool
ready ( Model { body } ) =
  (String.length body) /= 0


serialize : Model -> String
serialize ( Model { body }) =
  body
