module ElmMime.Main exposing (Part, Multipart, serialize, plaintext)

{-| ElmMime models mime email as (1) a cursor and (2) a stack of parts. The
    cursor models the current part of the multipart mime message and has noy yet
    been pushed onto the stack. Operations on the cursor include SetHeader and
    UpdateBody. Operations on the stack include Push.
-}


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
    bounds = "\r\n--"++frontier++"\r\n"
  in
    -- Add in Mime headers
    -- Optimize the string building/expansion; perhaps using foldl or foldr
    String.concat
      [ serializeHeaders
          [ ("MIME-Version", "1.0")
          , ("Content-Type", "multipart/mixed; boundary="++frontier)
          ]
      , serializeHeaders headers
      , "\r\n\r\nThis is a message with multiple parts in MIME format."
      , bounds
      , stack
          |> List.map (\part -> serializePart part)
          |> String.join bounds
      , "\r\n--"++frontier++"--\r\n"
      ]

serializePart : Part -> String
serializePart part =
  String.concat
    [ serializeHeaders part.headers
    , "\r\n\r\n"
    , part.body
    ]

serializeHeaders : List (String, String) -> String
serializeHeaders headers =
  headers
    |> List.map (\(header, value) -> String.join ": " [header, value])
    |> String.join "\r\n"

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
