module CryptoForm.Model exposing (Model, Msg(..), init, update, ready)

import CryptoForm.Config as Config exposing (Flags)

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

import Http


type alias Model =
  { config: Flags
  , name: String
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
      model ! List.map (fetchPublickey <| context model.config) identities

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
          model ! [ send model.config ciphertext identity ]

        Nothing ->
          model ! [ Cmd.none ]

    Sent _ ->
      reset model ! [ Cmd.none ]


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


send : Flags -> String -> Identity -> Cmd Msg
send config ciphertext to =
  let
    context = Mailman.context { baseUrl = config.baseUrl, msg = Sent}
    payload = [ ("content", ciphertext) ]
  in
    -- Can I send my ciphertext as a form upload instead?
    Mailman.send context payload to


-- Contexts
context : Flags -> Id.Context Msg
context config =
  Id.context
    { baseUrl = Config.baseUrl config
    , idsMsg = SetIdentities
    , keyMsg = SetPublickey
    }



-- Model helper function
init : Flags -> ( Model, Cmd Msg )
init flags =
  { config = flags
  , name = ""
  , email = ""
  , identities = []
  , to = Nothing
  , fingerprint = Nothing
  , subject = ""
  , body = ""
  , attachments = []
  } ! [ fetchIdentities (context flags) ]


ready : Model -> Bool
ready model =
  Nothing /= (model.to)
  && (String.length model.name) /= 0
  && (String.length model.email) /= 0
  && (String.length model.subject) /= 0
  && (String.length model.body) /= 0


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
