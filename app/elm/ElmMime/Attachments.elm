module ElmMime.Attachments exposing (Attachment, Model, Msg(FileSelect, FileRemove), update, onChange, filename, mimeType, mime)

import ElmMime.Main exposing (Part, crlf)

import MimeType as Mime
import FileReader exposing (..)

import Html.Events exposing (on)

import Task

import Json.Decode as Json


type alias Attachment =
  { contents : String
  , metadata : NativeFile
  }


type alias Model =
  List Attachment


type Msg
  = FileSelect (List NativeFile)
  | FileData NativeFile (Result Error String)
  | FileRemove Attachment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FileSelect files ->
      let
        cmd = case List.head files of
          Just file ->
            readFile file

          Nothing ->
            Cmd.none
      in
        ( model , cmd )

    FileRemove attachment ->
      ( List.filter ((/=) attachment) model , Cmd.none )

    FileData file (Ok str) ->
      let
        contents = String.join crlf (split 72 str)
      in
        ( {contents = contents, metadata = file} :: model, Cmd.none )

    FileData _ (Err err) ->
      ( model, Cmd.none )


-- TASKS
readFile : NativeFile -> Cmd Msg
readFile file =
    readAsBase64 file.blob
        |> Task.attempt (FileData file)


-- ACTIONS
-- onChange : (List NativeFile -> value) -> Html.Attribute value
onChange action =
  on
    "change"
    (Json.map action parseSelectedFiles)


filename : Attachment -> String
filename attachment =
  attachment.metadata.name


mimeType : Attachment -> String
mimeType attachment =
  Mime.toString (Maybe.withDefault Mime.OtherMimeType attachment.metadata.mimeType)


mime : Attachment -> Part
mime attachment =
  let
    filename = attachment.metadata.name
    mimetype = Mime.toString (Maybe.withDefault Mime.OtherMimeType attachment.metadata.mimeType)
    -- headers and body
    headers =
      [ ("Content-Type", String.concat([mimetype, "; name=\"", filename, "\""]))
      , ("Content-Transfer-Encoding", "base64")
      , ("Content-Disposition" , String.concat(["attachment; filename=\"",filename,"\""]))
      ]
    body = String.join crlf (split 72 attachment.contents)
  in
    { headers = headers, body = body }


split : Int -> String -> List String
split n str =
  case (String.length str) > n of
    False ->
      [str]
    True ->
      let
        left = String.left n str
        right = String.dropLeft n str
      in
      left :: (split n right)
