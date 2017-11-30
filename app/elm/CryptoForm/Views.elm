module CryptoForm.Views exposing (view)

import CryptoForm.Model exposing (Model, Msg(..), formview, ready)
import CryptoForm.Identities as Id

import ElmMime.Attachments as Attachments exposing (Attachment)

import Html exposing (Html, button, div, fieldset, form, h2, h5, hr, input, label, legend, p, small, span, strong, table, tbody, td, text, textarea, thead, th, tr)
import Html.Attributes exposing (attribute, checked, class, disabled, for, id, name, novalidate, placeholder, readonly, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)



view : Model -> Html Msg
view model =
  form [ onSubmit (Stage Nothing), novalidate True ]
    [ fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "Security" ]
        , div [ class "col-sm-10" ]
          [ div [ class "form-check" ]
            [ label [ class "form-check-label" ]
              [ input
                [ type_ "checkbox"
                , class "form-check-input"
                , checked True
                , name "privacy"
                , id "privacy"
                , disabled True
                ] [ ]
                , text " Private by default"
                , small [ class "text-muted" ] [ text " Your e-mail and its attachments will be encrypted." ]
              ]
            ]
          , div [ class "form-check" ]
            [ label [ class "form-check-label" ]
              [ input
                [ type_ "checkbox"
                , class "form-check-input"
                , name "anonimity"
                , id "anonimity"
                , checked model.anonymous
                , onCheck UpdateAnonimity
                ] [ ]
                , text " Anonymous"
                , small [ class "text-muted" ] [ text " Hide your identity from everyone, including the addressee." ]
              ]
            ]
          ]
        ]
      ]
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "From" ]
        , div [ class "col-sm-5"]
          [ input
            [ type_ "text"
            , class "form-control"
            , name "nameInput"
            , id "nameInput"
            , value model.name
            , placeholder "Your name"
            , onInput UpdateName
            , disabled model.anonymous
            ] []
          ]
        , div [ class "col-sm-5" ]
          [ input
            [ type_ "email"
            , class "form-control"
            , name "emailInput"
            , id "emailInput"
            , value model.email
            , placeholder "Your e-mail address"
            , onInput UpdateEmail
            , disabled model.anonymous
            ] []
          ]
        ]
      ]
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "To" ]
        , div [ class "col-sm-5" ]
          [ Id.view (Id.config
            { msg = Select
            , state = model.to
            , class = "form-control custom-select"
            , style = [] } ) model.identities
          ]
        , div [ class "col-sm-5" ]
          [ input
            [ type_ "text"
            , class "form-control is-valid"
            , name "verification"
            , id "verification"
            , value (Maybe.withDefault "" model.fingerprint)
            , placeholder "Confirm fingerprint to ensure integrity"
            , readonly True
            , attribute "data-toggle" "tooltip"
            , attribute "title" "Tooltip content"
            ] []
          ]
        ]
      ]
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "Compose" ]
        , div [ class "col-sm-10" ]
          [ input
            [ type_ "text"
            , class "form-control"
            , name "subjectInput"
            , id "subjectInput"
            , value model.subject
            , placeholder "Subject"
            , onInput UpdateSubject
            ] []
          ]
        ]
      , formview model
      ]
    -- , formview model
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "Attachments" ]
        , div [ class "col-sm-10" ]
          [ attachmentsView (List.reverse model.attachments)
          ]
        ]
      ]
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "" ]
        , div [ class "col-sm-10" ]
          [ button
            [ type_ "submit"
            , class "btn btn-primary btn-lg mx-1"
            , disabled (not (ready model))
            ] [ text "Send" ]
          , button
            [ type_ "reset"
            , class "btn btn-danger btn-lg mx-1"
            , onClick Reset
            ] [ text "Reset" ]
          ]
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
        , td [] [ button [ class "btn btn-danger", onClick (FileRemove a) ] [ text "Remove" ] ]
        ]
      )
    browse =
      tr []
        [ td [] [], td [] [], td [] []
        , td []
          [ label [ class "btn btn-primary" ]
            [ text "Browse"
            , Attachments.view (Attachments.config
              { msg = FilesSelect
              , style = [("display", "none")]
              })
            ]
          ]
        ]
  in
    table [ class "table" ]
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
