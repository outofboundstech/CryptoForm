module ElmMime.Main exposing
  ( Part, part
  , serialize
  , plaintext
  , split, crlf)


type Part =
  Part
    { headers: List (String, String)
    , body: String
    }


part : List (String, String) -> String -> Part
part headers body =
  Part
    { headers = headers
    , body = body
    }


type alias Multipart = List Part


-- serializers
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
serializePart (Part { headers, body }) =
  String.concat
    [ serializeHeaders headers, crlf, crlf
    , body
    ]


serializeHeaders : List (String, String) -> String
serializeHeaders headers =
  headers
    |> List.map (\(header, value) -> String.join ": " [header, value])
    |> String.join crlf


-- Part constructors
plaintext : String -> Part
plaintext body =
  Part
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


split : Int -> String -> List String -> String
split n str acc=
  case (String.length str) > n of
    False ->
       -- Is it better to reverse...
      String.join crlf <| List.reverse (str :: acc)
    True ->
      let
        left = String.left n str
        right = String.dropLeft n str
      in
        -- or append instead of cons? (depends on internal implementation of list)
        split n right (left :: acc)
        -- This blows the stack
        -- left :: (split n right)
