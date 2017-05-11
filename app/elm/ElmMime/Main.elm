module ElmMime.Main exposing (Model, Part, serialize)

{-| ElmMime types, model, model manipulation
-}


type alias Part =
  { headers: List (String, String)
  , body: String
  }

type alias Model = List Part

add_header : Part -> (String, String) -> Part
add_header part header =
  { part | headers = header :: part.headers}

set_body : Part -> String -> Part
set_body part body =
  { part | body = body }

add_part : Model -> Part -> Model
add_part model part = part :: model

serialize : Model -> String
serialize model =
  "Hello, World!"
