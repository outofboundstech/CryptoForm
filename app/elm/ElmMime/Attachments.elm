module ElmMime.Attachments exposing
  ( view
  , config, customConfig, customStyle
  , File, readFiles, parseFile
  , Attachment, attachment, filename, mimeType
  , mime)

import ElmMime.Main exposing (Part, part, split)

import MimeType as Mime
import FileReader exposing (..)

import Html exposing (Html, input)
import Html.Attributes as Attr
import Html.Events exposing (on)

import Task

import Json.Decode as Json


type alias File =
  NativeFile


type Attachment =
  Attachment String NativeFile


attachment : String -> NativeFile -> Attachment
attachment contents metadata =
  Attachment contents metadata


type Config msg =
  Config
    { toMsg : List NativeFile -> msg
    , style : Style
    }


config : { toMsg : List NativeFile -> msg } -> Config msg
config { toMsg } =
  Config
    { toMsg = toMsg
    , style = defaultStyle
    }


customConfig: { toMsg : List NativeFile -> msg, style : Style } -> Config msg
customConfig { toMsg, style } =
  Config
    { toMsg = toMsg
    , style = style
    }


type alias Style =
  { style : List (String, String)
  }


defaultStyle : Style
defaultStyle =
  { style = [] }


customStyle : List (String, String) -> Style
customStyle style =
  { style = style }


-- fileInput field helper
view : Config msg -> Html msg
view (Config { toMsg, style }) =
  let
    onChange = on "change" (Json.map toMsg parseSelectedFiles)
  in
    input [ Attr.type_ "file", Attr.style style.style, onChange ] []


-- readFiles task helper
readFiles : (File -> Result Error String -> msg) -> List NativeFile-> List (Cmd msg)
readFiles msg files =
  List.map (\file -> readAsBase64 file.blob |> Task.attempt (msg file)) files


-- 'getter' functions for the NativeFile type
filename : Attachment -> String
filename (Attachment contents metadata) =
  metadata.name


mimeType : Attachment -> String
mimeType (Attachment contents metadata) =
  Mime.toString (Maybe.withDefault Mime.OtherMimeType metadata.mimeType)


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
