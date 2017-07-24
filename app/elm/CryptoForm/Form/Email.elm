module CryptoForm.Form.Email exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import Html exposing (Html, div, fieldset, label, text, textarea)
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
  fieldset [ ]
    [ div [ class "pure-control-group"]
      [ label [ for "bodyInput" ] [ text "Compose" ]
      , textarea
        [ class "pure-u-1-2"
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
