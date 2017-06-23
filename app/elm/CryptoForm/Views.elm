module CryptoForm.Views exposing (view)

import CryptoForm.Model exposing (Model, Msg(..), ready)
import CryptoForm.Identities as Id

import ElmMime.Attachments as Attachments exposing (Attachment)

import Html exposing (Html, button, div, form, h5, input, label, table, tbody, td, text, textarea, thead, th, tr)
import Html.Attributes exposing (class, disabled, for, id, novalidate, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)



view : Model -> Html Msg
view model =
  form [ onSubmit Stage, novalidate True ]
    [ div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "Privacy" ] ] ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "nameInput" ] [ text "Your name" ]
        , input
          [ type_ "text"
          , class "u-full-width"
          , id "nameInput"
          , value model.name
          , placeholder "Enter your name"
          , onInput UpdateName
           ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "emailInput" ] [ text "Your e-mail address" ]
        , input
          [ type_ "email"
          , class "u-full-width"
          , id "emailInput"
          , value model.email
          , placeholder "Enter your e-mail address"
          , onInput UpdateEmail
          ] []
        ]
      ]
    , div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "E-mail" ] ] ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "identityInput" ] [ text "To" ]
        , Id.view (Id.config
            { msg = Select
            , state = model.to
            , class = "u-full-width"
            , style = [] } ) model.identities
        ]
      , div [ class "six columns" ]
        [ label [ for "verification" ] [ text "Security" ]
        , input
          [ type_ "text"
          , class "u-full-width"
          , id "verification"
          , value (Maybe.withDefault "" model.fingerprint)
          , placeholder "Fingerprint verification"
          , disabled True
          ] []
        ]
      ]
    , div [ class "row" ]
      [ div [ class "twelve columns"]
        [ label [ for "subjectInput" ] [ text "Subject" ]
        , input
          [ type_ "text"
          , class "u-full-width"
          , id "subjectInput"
          , value model.subject
          , placeholder "Enter e-mail subject"
          , onInput UpdateSubject
          ] []
        , label [ for "bodyInput" ] [ text "Compose" ]
        , textarea
          [ class "u-full-width"
          , id "bodyInput"
          , value model.body
          , onInput UpdateBody
          ] []
        ]
      ]
    , div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "Attachments" ] ] ]
    , div [ class "row" ]
      [ div [ class "twelve columns" ]
        [ attachmentsView (List.reverse model.attachments)
        ]
      ]
    , div [ class "row" ]
      [ div [ class "twelve columns"]
        [ button [ type_ "submit", class "button-primary", disabled (not (ready model)) ] [ text "Send" ]
        , button [ type_ "reset", onClick Reset ] [ text "Reset" ]
        ]
      ]
    ]


attachmentsView : List Attachment -> Html Msg
attachmentsView attachments =
  let
    render = (\a ->
      tr []
        [ td [] [ text (Attachments.filename a)]
        , td [] [ text (Attachments.mimeType a)]
        , td [] [ text (Attachments.size a)]
        , td [] [ button [ onClick (FileRemove a) ] [ text "Remove" ] ]
        ]
      )
    browse =
      tr []
        [ td [] [], td [] [], td [] []
        , td []
          [ label [ class "button" ]
            [ text "Browse"
            , Attachments.view (Attachments.config
              { msg = FilesSelect
              , style = [("display", "none")]
              })
            ]
          ]
        ]
  in
    table [ class "u-full-width" ]
      [ thead []
        [ th [] [ text "Filename" ]
        , th [] [ text "Type"]
        , th [] [ text "Size" ]
        , th [] [ text "Add/Remove" ]
        ]
      , tbody [] (List.map render attachments ++ [browse])
      ]
