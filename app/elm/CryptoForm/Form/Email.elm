module CryptoForm.Form.Email exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import Html exposing (Html, div, fieldset, label, text, textarea)
import Html.Attributes exposing (class, for, id, name, value)
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
    [ div [ class "form-group row"]
      [ label
        [ for "bodyInput"
        , class "col-sm-2"
        ] [ text "" ]
      , div [ class "col-sm-10" ]
        [ textarea
          [ class "form-control"
          , name "bodyInput"
          , id "bodyInput"
          , value body
          , onInput Body
          ] []
        ]
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
