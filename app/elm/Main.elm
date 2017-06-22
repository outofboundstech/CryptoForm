module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Identities as Identities exposing (Identity, Msg(Select), selected)
import CryptoForm.Mailman as Mailman

import ElmMime.Main as Mime
import ElmMime.Attachments as Attachments exposing (Error, File, readFiles, parseFile, Attachment, attachment, filename, mimeType)

import ElmPGP.Ports exposing (encrypt, ciphertext)

import Html exposing (Html, a, button, code, div, form, h5, input, label, li, p, span, strong, table, tbody, td, text, textarea, thead, th, tr, ul)
import Html.Attributes exposing (attribute, class, disabled, for, href, id, novalidate, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)

import Http


type alias Model =
  { base_url: String
  , identities: Identities.Model
  , name: String
  , email: String
  , subject: String
  , body: String
  , attachments: List Attachment
  }


type Msg
  = UpdateIdentities Identities.Msg
  -- Attachment handling
  | FilesSelect (List File)
  | FileData File (Result Error String)
  | FileRemove Attachment
  -- Update form fields
  | UpdateName String
  | UpdateEmail String
  | UpdateSubject String
  | UpdateBody String
  -- Staging and sending my encrypted email
  | Stage
  | Send String
  | Sent (Result Http.Error String)
  | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateIdentities a ->
      let
        ( identities, cmd ) = Identities.update a model.identities
      in
        ( { model | identities = identities }, Cmd.map UpdateIdentities cmd )

    -- Attachment Handling
    FilesSelect files ->
      model ! readFiles FileData files

    FileRemove attachment ->
      let
        attachments = List.filter ((/=) attachment) model.attachments
      in
        ( { model | attachments = attachments } , Cmd.none )

    FileData metadata (Ok str) ->
      let
        attachments = (attachment (parseFile str) metadata) :: model.attachments
      in
        ( { model | attachments = attachments }, Cmd.none )

    FileData _ (Err err) ->
      -- Implement error handling
      ( model, Cmd.none )

    -- Update form fields
    UpdateName name ->
        ( { model | name = name }, Cmd.none )

    UpdateEmail email ->
        ( { model | email = email }, Cmd.none )

    UpdateSubject subject ->
        ( { model | subject = subject }, Cmd.none )

    UpdateBody body ->
        ( { model | body = body }, Cmd.none )

    -- Staging and sending my encrypted email
    Stage ->
      let
        cmd = case (selected model.identities) of
          Just identity ->
            let
              -- Much of this needs to be configured with env-vars
              recipient = String.concat
                [ Identities.description identity
                , " <"
                , Identities.fingerprint identity
                , "@451labs.org>"
                ]
              headers =
                [ ("From", "CryptoForm <noreply@451labs.org>")
                , ("To", recipient)
                , ("Message-ID", "Placeholder-message-ID")
                , ("Subject", model.subject)
                ]
              parts =
                Mime.plaintext model.body ::
                (List.map Attachments.mime model.attachments)
              body = Mime.serialize headers parts
            in
              encrypt
                { data = body
                , publicKeys = Identities.publicKey identity
                , privateKeys = ""
                , armor = True
                }

          Nothing ->
            Cmd.none
      in
        ( model, cmd )

    Send ciphertext ->
      let
        config = Mailman.config { base_url = model.base_url , toMsg = Sent}
        payload = [ ("content", ciphertext) ]
        cmd = case (selected model.identities) of
          Just identity ->
            -- Can I send my ciphertext as a form upload instead?
            Mailman.send identity payload config
          Nothing ->
            Cmd.none
      in
        ( model, cmd )

    Sent _ ->
      ( model, Cmd.none )

    Reset ->
      ( reset model, Cmd.none )


-- VIEW functions
view : Model -> Html Msg
view model =
  form [ onSubmit Stage, novalidate True ]
    [ div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "Privacy" ] ] ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "nameInput" ] [ text "Your name" ]
        , input [ type_ "text", class "u-full-width", id "nameInput", onInput UpdateName ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "emailInput" ] [ text "Your email address" ]
        , input [ type_ "email", class "u-full-width", id "emailInput", onInput UpdateEmail ] []
        ]
      ]
    , div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "Compose" ] ] ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "identityInput" ] [ text "Addressee" ]
        , input [ type_ "text", class "u-full-width", id "identityInput" ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "verification" ] [ text "Security information" ]
        , input [ type_ "text", class "u-full-width", id "verification", disabled True ] []
        ]
      ]
    , div [ class "row" ]
      [ div [ class "twelve columns"]
        [ label [ for "subjectInput" ] [ text "Subject" ]
        , input [ type_ "text", class "u-full-width", id "subjectInput", onInput UpdateSubject ] []
        , label [ for "bodyInput" ] [ text "Compose" ]
        , textarea [ class "u-full-width", id "bodyInput", onInput UpdateBody ] []
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
        [ button [ class "button-primary", type_ "Submit", disabled (not (ready model)) ] [ text "Send" ]
        , button [ type_ "Reset", onClick Reset ] [ text "Reset" ]
        ]
      ]
    ]


identitiesView : Identities.Model -> Html Msg
identitiesView model =
  let
    description = case (selected model) of
      Just identity ->
        Identities.description identity
      Nothing ->
        ""
  in
    div [ class "form-group" ]
      [ div [ class "input-group" ]
        [ div [ class "input-group-btn" ]
          [ button [ type_ "button", class "btn btn-default btn-primary dropdown-toggle", disabled (not <| Identities.ready model), attribute "data-toggle" "dropdown", style [ ("min-width", "75px"), ("text-align", "right") ] ]
            [ text "To "
            , span [ class "caret" ] []
            ]
          , ul [ class "dropdown-menu" ]
            (List.map (\identity -> li [] [ a [ href "#", onClick <| UpdateIdentities (Select identity) ] [ text (Identities.description identity) ] ] ) (Identities.identities model))
          ]
        , input [ type_ "text", class "form-control", value description, disabled True, placeholder "Select your addressee..." ] [ ]
        ]
      ]


verifierView : Identities.Model -> Html Msg
verifierView model =
  let
    verifier = Identities.verifier model
    view = \cls fingerprint expl ->
      div [ class cls ]
        [ strong [] [ text "Fingerprint " ]
        , code [] [ text ( Identities.friendly fingerprint ) ]
        , p [] [ text expl ]
        ]
  in
    case verifier of
      Just ( fingerprint, True ) ->
        view "alert alert-success" fingerprint """
To ensure only the intended recipient can read you e-mail, check with him/her if
this is the correct key fingerprint. Some people mention their fingerprint on
business cards or in e-mail signatures. The fingerprint listed here matches the
one reported for this recipient by the server."""

      Just ( fingerprint, False ) ->
        view "alert alert-danger" fingerprint """
This fingerprint does not match the one reported for this recipient by the
server. To ensure only the intended recipient can read you e-mail, check with
him/her if this is the correct key fingerprint. Some people mention their
fingerprint on business cards or in e-mail signatures."""

      Nothing ->
        div [ class "alert hidden" ] []


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
            , Attachments.view (Attachments.customConfig
              { toMsg = FilesSelect
              , style = Attachments.customStyle [("display", "none")]
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



-- HOUSEKEEPING
ready : Model -> Bool
ready model =
  Nothing /= (selected model.identities)
  && (String.length model.name) /= 0
  && (String.length model.email) /= 0
  && (String.length model.subject) /= 0
  && (String.length model.body) /= 0


init : String -> ( Model, Cmd Msg )
init base_url =
  let
    ( identities, identities_cmd ) = Identities.init base_url
    cmd = Cmd.map UpdateIdentities identities_cmd
  in
    ( { base_url = base_url
      , identities = identities
      , name = ""
      , email = ""
      , subject = ""
      , body = ""
      , attachments = []
      } , cmd )


reset : Model -> Model
reset model =
  { base_url = model.base_url
  , identities = Identities.reset model.identities
  , name = ""
  , email = ""
  , subject = ""
  , body = ""
  , attachments = []
  }


{-| main
-}
main : Program Never Model Msg
main =
  Html.program
    { init = init "http://localhost:4000/api/"
    , view = view
    , update = update
    , subscriptions = always (Sub.batch
      [ ElmPGP.Ports.ciphertext Send
      , Sub.map UpdateIdentities Identities.subscriptions
      ])
    }
