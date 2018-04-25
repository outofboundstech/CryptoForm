module ElmMime.Main exposing
  ( Part, part
  , serialize
  , plaintext
  , address
  , split, crlf)


import Char
import Random
import Time exposing (Time)


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
serialize : Time -> List (String, String) -> Multipart -> String
serialize time headers stack =
  let
    frontier = String.concat(["_=",boundary time,"=_"])
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
address : String -> String -> String
address name email =
  String.concat([ "\"", name, "\" <", email, ">"])


boundary : Time -> String
boundary time =
  Random.initialSeed (floor time)
    |> Random.step (Random.list 32 <| Random.int 0 35)
    |> Tuple.first
    |> List.map ((+) 48)
    |> List.map (\n -> if n > 57 then n+39 else n)
    |> List.map Char.fromCode
    |> String.fromList


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
