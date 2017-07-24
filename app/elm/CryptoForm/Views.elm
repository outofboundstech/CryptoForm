module CryptoForm.Views exposing (view)

import CryptoForm.Model exposing (Model, Msg(..), formview, ready)
import CryptoForm.Identities as Id

import ElmMime.Attachments as Attachments exposing (Attachment)

import Html exposing (Html, button, div, fieldset, form, h2, h5, hr, input, label, p, span, strong, table, tbody, td, text, textarea, thead, th, tr)
import Html.Attributes exposing (checked, class, disabled, for, id, novalidate, placeholder, readonly, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)



view : Model -> Html Msg
view model =
  form [ class "pure-form pure-form-aligned", onSubmit (Stage Nothing), novalidate True ]
    [ fieldset [ ]
      [ div [ class "pure-controls" ]
        [ label [ for "privacy", class "pure-checkbox" ]
          [ input
            [ type_ "checkbox"
            , checked True
            , id "privacy"
            , disabled True
            ] [ ]
          , text " Private by default"
          ]
        , span [ class "pure-form-message-inline" ] [ text """
Your e-mail and its attachments will be encrypted.""" ]
        ]
      , div [ class "pure-controls" ]
        [ label [ for "anonimity", class "pure-checkbox" ]
          [ input
            [ type_ "checkbox"
            , checked model.anonymous
            , id "anonimity"
            , onCheck UpdateAnonimity
            ] [ ]
          , text " Anonymous"
          ]
        , span [ class "pure-form-message-inline" ] [ text """
Hide your identity from everyone, including the addressee.""" ]
        ]
      ]
    , fieldset [ ]
      [ div [ class "pure-control-group" ]
        [ label [ for "nameInput" ] [ text "Name" ]
        , input
          [ type_ "text"
          , class "pure-u-1-2"
          , id "nameInput"
          , value model.name
          , placeholder "Your name"
          , onInput UpdateName
          , disabled model.anonymous
          ] []
        ]
      , div [ class "pure-control-group" ]
        [ label [ for "emailInput" ] [ text "E-mail" ]
        , input
          [ type_ "email"
          , class "pure-u-1-2"
          , id "emailInput"
          , value model.email
          , placeholder "Your e-mail address"
          , onInput UpdateEmail
          , disabled model.anonymous
          ] []
        ]
      ]
    , fieldset [ ]
      [ div [ class "pure-control-group" ]
        [ label [ for "identityInput" ] [ text "To" ]
        , Id.view (Id.config
            { msg = Select
            , state = model.to
            , class = "pure-u-1-2"
            , style = [] } ) model.identities
        ]
      , div [ class "pure-control-group" ]
        [ label [ for "verification" ] [ text "Fingerprint" ]
        , input
          [ type_ "text"
          , class "pure-u-1-2"
          , id "verification"
          , value (Maybe.withDefault "" model.fingerprint)
          , placeholder "Confirm fingerprint to ensure integrity"
          , readonly True
          ] []
        ]
      ]
    , fieldset [ ]
      [ div [ class "pure-control-group"]
        [ label [ for "subjectInput" ] [ text "Subject" ]
        , input
          [ type_ "text"
          , class "pure-u-1-2"
          , id "subjectInput"
          , value model.subject
          , placeholder "Subject"
          , onInput UpdateSubject
          ] []
        ]
      ]
    , formview model
    , fieldset [ ]
      [ div [ class "pure-controls" ]
        [ attachmentsView (List.reverse model.attachments)
        ]
      ]
    , fieldset [ ]
      [ div [ class "pure-controls pure-button-group" ]
        [ button [ type_ "submit", class "pure-button pure-button-primary", disabled (not (ready model)) ] [ text "Send" ]
        , button [ type_ "reset", class "pure-button button-error", onClick Reset ] [ text "Reset" ]
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
        , td [] [ button [ class "pure-button button-error", onClick (FileRemove a) ] [ text "Remove" ] ]
        ]
      )
    browse =
      tr []
        [ td [] [], td [] [], td [] []
        , td []
          [ label [ class "pure-button pure-button-primary" ]
            [ text "Browse"
            , Attachments.view (Attachments.config
              { msg = FilesSelect
              , style = [("display", "none")]
              })
            ]
          ]
        ]
  in
    table [ class "pure-table pure-table-horizontal" ]
      [ thead []
        [ tr []
          [ th [] [ text "Filename" ]
          , th [] [ text "Type"]
          , th [] [ text "Size" ]
          , th [] [ text "Add/Remove" ]
          ]
        ]
      , tbody [] (List.map render attachments ++ [browse])
      ]
