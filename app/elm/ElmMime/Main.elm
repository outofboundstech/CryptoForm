module ElmMime.Main exposing (Part, Multipart, serialize, plaintext)

type alias Part =
  { headers: List (String, String)
  , body: String
  }

type alias Multipart = List Part

-- Serializers

serialize : List (String, String) -> Multipart -> String
serialize headers stack =
  let
    frontier = boundary
    bounds = String.concat [crlf,"--",frontier,crlf]
  in
    -- Optimize the string building/expansion; perhaps using foldl or foldr
    String.concat
      [ serializeHeaders
          [ ("MIME-Version", "1.0")
          , ("Content-Type", "multipart/mixed; boundary=\""++frontier++"\"")
          ], crlf
      , serializeHeaders headers, crlf, crlf
      , "This is a message with multiple parts in MIME format."
      , bounds
      , stack
          |> List.map (\part -> serializePart part)
          |> String.join bounds, crlf
      , String.concat["--",frontier,"--",crlf]
      ]

serializePart : Part -> String
serializePart part =
  String.concat
    [ serializeHeaders part.headers, crlf, crlf
    , part.body
    ]

serializeHeaders : List (String, String) -> String
serializeHeaders headers =
  headers
    |> List.map (\(header, value) -> String.join ": " [header, value])
    |> String.join crlf

-- Part constructors

plaintext : String -> Part
plaintext body =
  { headers = [("Content-Type", "text/plain")]
  , body = body
  }

-- Helpers functions

boundary : String
boundary =
  -- Stubbing the frontier function
  "4aUk7ggZLF9i6VUhHtrBCTP3AqArp8MH"

crlf : String
crlf =
  "\r\n"
