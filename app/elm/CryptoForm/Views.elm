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
    [ fieldset [ if model.config.showSecurity then class "form-group" else class "d-none" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "Security" ]
        , div [ class "col-sm-12" ]
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
    , fieldset [ if model.config.showFrom then class "form-group" else class "d-none"]
      [ div [ class "row" ]
        [ legend [ class "col-sm-12" ] [ text "Basic info" ]
        , div [ class "col-sm-6"]
          [ label [ for "fromInput" ] [ text "From" ]
          , input
            [ type_ "text"
            , class "form-control"
            , name "fromInput"
            , id "fromInput"
            , value model.name
            , placeholder "required"
            , onInput UpdateName
            , disabled model.anonymous
            ] []
          ]
        , div [ class "col-sm-6" ]
          [ label [ for "emailInput" ] [ text "E-mail address" ]
          ,  input
            [ type_ "email"
            , class "form-control"
            , name "emailInput"
            , id "emailInput"
            , value model.email
            , placeholder "required"
            , onInput UpdateEmail
            , disabled model.anonymous
            ] []
          ]
        ]
      ]
    , fieldset [ if model.config.showTo then class "form-group" else class "d-none" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "" ]
        , div [ class "col-sm-6" ]
          [ label [ for "" ] [ text "To" ]
          , Id.view (Id.config
            { msg = Select
            , state = model.to
            , class = "form-control custom-select"
            -- , id = "toInput"
            , style = [] } ) model.identities
          ]
        , div [ class "col-sm-6" ]
          [ label [ for "verification" ] [ text "Fingerprint" ]
          , input
            [ type_ "text"
            , class "form-control-plaintext text-muted w-100"
            , name "verification"
            , id "verification"
            , value (Maybe.withDefault "" model.fingerprint)
            , placeholder "Confirm fingerprint to ensure integrity"
            , readonly True
            ] []
          ]
        ]
      ]
    , fieldset [ if model.config.showSubject then class "form-group" else class "d-none" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "" ]
        , div [ class "col-sm-12" ]
          [ label [ for "subjectInput" ] [ text "Subject" ]
          , input
            [ type_ "text"
            , class "form-control"
            , name "subjectInput"
            , id "subjectInput"
            , value model.subject
            , placeholder "required"
            , onInput UpdateSubject
            ] []
          ]
        ]
      ]
    , formview model
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "Attachments" ]
        , div [ class "col-sm-12" ]
          [ attachmentsView (List.reverse model.attachments)
          ]
        ]
      ]
    , fieldset [ class "form-group" ]
      [ div [ class "row" ]
        [ legend [ class "col-sm-2" ] [ text "" ]
        , div [ class "col-sm-12" ]
          [ button
            [ type_ "submit"
            , class "btn btn-primary mx-1"
            , disabled (not (ready model))
            ] [ text "Send" ]
          , button
            [ type_ "reset"
            , class "btn btn-danger mx-1"
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
            [ text "Choose file"
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
