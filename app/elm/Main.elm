module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Identities as Id exposing
  ( Fingerprint, Identity
  , fetchIdentities, fetchPublickey)
import CryptoForm.Mailman as Mailman

import ElmMime.Main as Mime
import ElmMime.Attachments as Attachments exposing
  ( Error, File
  , readFiles, parseFile
  , Attachment, attachment
  , filename, mimeType)

import ElmPGP.Ports exposing
  (encrypt, verify)

import Html exposing (Html, button, div, form, h5, input, label, table, tbody, td, text, textarea, thead, th, tr)
import Html.Attributes exposing (class, disabled, for, id, novalidate, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)

import Http


type alias Model =
  { name: String
  , email: String
  , identities: List Identity
  , to: Maybe Identity
  , fingerprint: Maybe Fingerprint
  , subject: String
  , body: String
  , attachments: List Attachment
  }


type Msg
  = Reset
  -- Identity handling
  | SetIdentities (Result Http.Error (List Identity))
  | SetPublickey Identity (Result Http.Error String)
  | Select Fingerprint
  | Verify ( Fingerprint, Fingerprint )
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Reset ->
      reset model ! [ Cmd.none ]

    -- Identity handling
    SetIdentities (Ok identities) ->
      model ! List.map (fetchPublickey context) identities

    SetIdentities (Err _) ->
      -- Report failure to obtain identities
      model ! [ Cmd.none ]

    SetPublickey identity (Ok pub) ->
      let
        identities = (Id.setPublicKey pub identity) :: model.identities
      in
        { model | identities = identities } ! [ Cmd.none ]

    SetPublickey _ (Err _) ->
      -- Report failure to obtain public key
      model ! [ Cmd.none ]

    Select "" ->
      { model | to = Nothing } ! [ Cmd.none ]

    Select fingerprint ->
      let
        to = (Id.find fingerprint model.identities)
        cmd = case to of
          Just identity ->
            verify (Id.publicKey identity, Id.fingerprint identity)
          Nothing ->
            Cmd.none
      in
        { model | to = to, fingerprint = Nothing } ! [ cmd ]

    Verify ( remote, raw ) ->
      -- Report violation if remote and raw (normalized) don't match
      { model | fingerprint = Just (Id.prettyPrint <| Id.normalize raw) } ! [ Cmd.none ]

    -- Attachment handling
    FilesSelect files ->
      model ! readFiles FileData files

    FileRemove attachment ->
      let
        attachments = List.filter ((/=) attachment) model.attachments
      in
        { model | attachments = attachments } ! [ Cmd.none ]

    FileData metadata (Ok str) ->
      let
        attachments = (attachment (parseFile str) metadata) :: model.attachments
      in
        { model | attachments = attachments } ! [ Cmd.none ]

    FileData _ (Err err) ->
      -- Implement File IO error handling
      model ! [ Cmd.none ]

    -- Update form fields
    UpdateName name ->
      { model | name = name } ! [ Cmd.none ]

    UpdateEmail email ->
      { model | email = email } ! [ Cmd.none ]

    UpdateSubject subject ->
      { model | subject = subject } ! [ Cmd.none ]

    UpdateBody body ->
      { model | body = body } ! [ Cmd.none ]

    -- Staging and sending my encrypted email
    Stage ->
        model ! [ stage model ]

    Send ciphertext ->
      case (model.to) of
        Just identity ->
          model ! [ send ciphertext identity ]

        Nothing ->
          model ! [ Cmd.none ]

    Sent _ ->
      reset model ! [ Cmd.none ]


-- VIEW functions
view : Model -> Html Msg
view model =
  form [ onSubmit Stage, novalidate True ]
    [ div [ class "row" ] [ div [ class "twelve columns" ] [ h5 [] [ text "Privacy" ] ] ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "nameInput" ] [ text "Your name" ]
        , input [ type_ "text", class "u-full-width", id "nameInput", value model.name, onInput UpdateName ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "emailInput" ] [ text "Your e-mail address" ]
        , input [ type_ "email", class "u-full-width", id "emailInput", value model.email, onInput UpdateEmail ] []
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
        , input [ type_ "text", class "u-full-width", id "verification", value (Maybe.withDefault "" model.fingerprint), disabled True ] []
        ]
      ]
    , div [ class "row" ]
      [ div [ class "twelve columns"]
        [ label [ for "subjectInput" ] [ text "Subject" ]
        , input [ type_ "text", class "u-full-width", id "subjectInput", value model.subject, onInput UpdateSubject ] []
        , label [ for "bodyInput" ] [ text "Compose" ]
        , textarea [ class "u-full-width", id "bodyInput", value model.body, onInput UpdateBody ] []
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

-- staging and sending helper functions
stage : Model -> Cmd Msg
stage model =
  case (model.to) of
    Just identity ->
      let
        -- Much of this needs to be configured with flags
        headers =
          [ ("From", "CryptoForm <noreply@451labs.org>")
          , ("To", String.concat
              [ Id.description identity
              , " <"
              , Id.fingerprint identity
              , "@451labs.org>"

              ])
          , ("Message-ID", "Placeholder-message-ID")
          , ("Subject", model.subject)
          ]
        parts =
          Mime.plaintext model.body ::
          (List.map Attachments.mime model.attachments)
      in
        encrypt
          { data = Mime.serialize headers parts
          , publicKeys = Id.publicKey identity
          , privateKeys = ""
          , armor = True
          }

    Nothing ->
      Cmd.none


send : String -> Identity -> Cmd Msg
send ciphertext to =
  let
    config = Mailman.config { baseUrl = baseUrl , msg = Sent}
    payload = [ ("content", ciphertext) ]
  in
    -- Can I send my ciphertext as a form upload instead?
    Mailman.send config payload to


-- Housekeeping
ready : Model -> Bool
ready model =
  Nothing /= (model.to)
  && (String.length model.name) /= 0
  && (String.length model.email) /= 0
  && (String.length model.subject) /= 0
  && (String.length model.body) /= 0


init : Id.Context Msg -> ( Model, Cmd Msg )
init base_url =
  { name = ""
  , email = ""
  , identities = []
  , to = Nothing
  , fingerprint = Nothing
  , subject = ""
  , body = ""
  , attachments = []
  } ! [ fetchIdentities context ]


reset : Model -> Model
reset model =
  { model
  | name = ""
  , email = ""
  , to = Nothing
  , fingerprint = Nothing
  , subject = ""
  , body = ""
  , attachments = []
  }


context : Id.Context Msg
context =
  Id.context
    { baseUrl = baseUrl
    , idsMsg = SetIdentities
    , keyMsg = SetPublickey
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ ElmPGP.Ports.ciphertext Send
    , ElmPGP.Ports.fingerprint Verify
    ]


-- Pass in as a flag
baseUrl : String
baseUrl =
  "http://localhost:4000/api/"


{-| main
-}
main : Program Never Model Msg
main =
  Html.program
    { init = init context
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
