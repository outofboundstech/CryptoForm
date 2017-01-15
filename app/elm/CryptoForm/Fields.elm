module CryptoForm.Fields exposing ( input, textarea )

import Html exposing (Html, div, span, text)
import Html.Attributes exposing ( class, placeholder, style, type_, value)
import Html.Events exposing (onInput)


input : String -> String -> String -> (String -> msg) -> Html msg
input title description val msg =
  div [ class "form-group" ]
    [ div [ class "input-group" ]
      [ span [ class "input-group-addon", style [ ("min-width", "75px"), ("text-align", "right") ] ] [ text title ]
      , Html.input [ type_ "text", class "form-control", onInput msg, value val, placeholder description ] []
      ]
    ]


textarea : String -> (String -> msg) -> Html msg
textarea val msg =
  div [ class "form-group" ]
  [ Html.textarea [ class "form-control", onInput msg, value val ] []
  ]
