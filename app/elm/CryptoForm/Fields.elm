module CryptoForm.Fields exposing
  ( field, date, input, textarea
  )


import Html exposing (Html)
import Html.Attributes as Attr exposing (attribute)
import Html.Events exposing (onInput)

-- type Attributes = List attribute


type Config msg =
  Config
  { label : String
  , msg : String -> msg
  , value : String
  }


field : { label: String, msg : String -> msg, value : String } -> Config msg
field { label, msg, value } =
  Config
    { label = label
    , msg = msg
    , value = value}

generic : String -> String -> Config msg -> List (Html.Attribute msg) -> Html msg
generic type_ ident (Config { label, msg, value }) attrs =
  Html.div [ Attr.class "form-group row" ]
    [ Html.label [ Attr.for ident, Attr.class "col-sm-2 col-form-label" ] [ Html.text label ]
    , Html.div [ Attr.class "col-sm-10" ]
      [ Html.input
        ( attrs ++
          [ Attr.id ident
          , Attr.class "form-control"
          , Attr.type_ type_
          , Attr.value value
          , onInput msg
          ]
        ) [ ]
      ]
    ]

date : (String -> Config msg -> List (Html.Attribute msg) -> Html msg)
date = generic "date"


input : (String -> Config msg -> List (Html.Attribute msg) -> Html msg)
input = generic "text"


textarea : String -> Config msg -> List (Html.Attribute msg) -> Html msg
textarea ident (Config { label, msg, value }) attrs =
  Html.div [ Attr.class "form-group row" ]
    [ Html.label [ Attr.for ident, Attr.class "col-sm-2 col-form-label" ] [ Html.text label ]
    , Html.div [ Attr.class "col-sm-10" ]
      [ Html.textarea
        ( attrs ++
          [ Attr.id ident
          , Attr.class "form-control"
          , Attr.value value
          , Attr.rows 5
          , onInput msg
          ]
        ) [ ]
      ]
    ]
