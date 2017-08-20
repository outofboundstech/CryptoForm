module CryptoForm.Fields exposing
  ( date, input, textarea
  )


import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (onInput)


date : String ->
    { label : String
    , value : String
    , msg : String -> msg
    } ->
  Html msg
date ident { label, value, msg } =
  Html.div [ Attr.class "pure-control-group" ]
    [ Html.label [ Attr.for ident ] [ Html.text label ]
    , Html.input
      [ Attr.id ident
      , Attr.class "pure-u-1-2"
      , Attr.type_ "date"
      , Attr.value value
      , onInput msg
      ] [ ]
    ]


input : String ->
    { label : String
    , value : String
    , placeholder : String
    , msg : String -> msg
    } ->
  Html msg
input ident { label, value, placeholder, msg } =
  Html.div [ Attr.class "pure-control-group" ]
    [ Html.label [ Attr.for ident ] [ Html.text label ]
    , Html.input
      [ Attr.id ident
      , Attr.class "pure-u-1-2"
      , Attr.type_ "text"
      , Attr.value value
      , Attr.placeholder placeholder
      , onInput msg
      ] [ ]
    ]


textarea : String ->
    { label : String
    , value : String
    , placeholder : String
    , msg : String -> msg
    } ->
  Html msg
textarea ident { label, value, placeholder, msg } =
  Html.div [ Attr.class "pure-control-group" ]
    [ Html.label [ Attr.for ident ] [ Html.text label ]
    , Html.textarea
      [ Attr.id ident
      , Attr.class "pure-u-1-2"
      , Attr.value value
      , Attr.rows 5
      , Attr.placeholder placeholder
      , onInput msg
      ] [ ]
    ]
