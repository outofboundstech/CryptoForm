module ElmMime.Attachments exposing
  ( view, config
  , Error, File, readFiles, parseFile
  , Attachment, attachment, filename, filesize, mimeType, size
  , mime)

import ElmMime.Main exposing (Part, part, split)

import MimeType as Mime
import FileReader as F exposing (NativeFile)

import Html exposing (Html, input)
import Html.Attributes as Attr
import Html.Events exposing (on)

import Task

import Json.Decode as Json


-- Is this an anti-pattern?
type alias Error =
  F.Error


type alias File =
  NativeFile


type Attachment =
  Attachment String NativeFile


attachment : String -> NativeFile -> Attachment
attachment contents metadata =
  Attachment contents metadata


type Config msg =
  Config
    { msg : List NativeFile -> msg
    , style : List (String, String)
    }


config : { msg : List NativeFile -> msg, style : List ( String, String ) } -> Config msg
config { msg, style } =
  Config
    { msg = msg
    , style = style
    }


-- fileInput field helper
view : Config msg -> Html msg
view (Config { msg, style }) =
  let
    onChange = on "change" (Json.map msg F.parseSelectedFiles)
  in
    input [ Attr.type_ "file", Attr.style style, onChange ] []


-- readFiles task helper
readFiles : (File -> Result Error String -> msg) -> List NativeFile-> List (Cmd msg)
readFiles msg files =
  List.map (\file -> F.readAsBase64 file.blob |> Task.attempt (msg file)) files


-- 'getter' functions for the NativeFile type
filename : Attachment -> String
filename (Attachment _ metadata) =
  metadata.name


filesize : Attachment -> Int
filesize (Attachment _ metadata) =
  metadata.size


mimeType : Attachment -> String
mimeType (Attachment _ metadata) =
  Mime.toString (Maybe.withDefault Mime.OtherMimeType metadata.mimeType)


size : Attachment -> String
size attachment =
  let
    n = filesize attachment
  in
    if n > (1024 * 1024) then
      toString (n // 1024 // 1024) ++ " MB"
    else if n > 1024 then
      toString (n // 1024) ++ " KB"
    else
      toString n ++ "  bytes"


-- additional helper functions
parseFile : String -> String
parseFile str =
  split 72 str []


mime : Attachment -> Part
mime (Attachment contents metadata) =
  let
    mimetype = mimeType (Attachment contents metadata)
    -- headers and body
    headers =
      [ ("Content-Type", String.concat([mimetype, "; name=\"", metadata.name, "\""]))
      , ("Content-Transfer-Encoding", "base64")
      , ("Content-Disposition" , String.concat(["attachment; filename=\"",metadata.name,"\""]))
      ]
    -- body = String.join crlf (split 72 attachment.contents [])
  in
    part headers contents
