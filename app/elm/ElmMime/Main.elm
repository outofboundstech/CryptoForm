module ElmMime.Main exposing (Model, Part, serialize)

{-| ElmMime models mime email as (1) a cursor and (2) a stack of parts. The
    cursor models the current part of the multipart mime message and has noy yet
    been pushed onto the stack. Operations on the cursor include SetHeader and
    UpdateBody. Operations on the stack include Push.
-}


type alias Part =
  { headers: List (String, String)
  , body: String
  }

type alias Model =
  { cursor: Part
  , stack: List Part
  }

type Msg
  = SetHeader (String, String)
  | UpdateBody String
  | Push Part

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetHeader header ->
      let
        curr = model.cursor
        next = { curr | headers = header :: curr.headers }
      in
        ( { model | cursor = next }, Cmd.none )

    UpdateBody body ->
      let
        curr = model.cursor
        next = { curr | body = body }
      in
        ( { model | cursor = next }, Cmd.none )

    Push part ->
      ( { model | stack = part :: model.stack }, Cmd.none )

serialize : Model -> String
serialize model =
  let
    stack = model.cursor :: model.stack
    frontier = mimeFrontier
  in
    List.foldr (\p str -> frontier ++ (String.trim <| serializePart p) ++ str)
      frontier stack

serializePart : Part -> String
serializePart part =
  serializeHeaders part.headers ++ "\n\n" ++ part.body

serializeHeaders : List (String, String) -> String
serializeHeaders headers =
  -- I don't trim my header k and v here...
  List.foldr (\(k, v) str -> (String.join ": " [k, v]) ++ "\n" ++ str)
    "" headers

-- Defaults

mimeHeaders : List (String, String)
mimeHeaders =
  [ ("Mime-Version", "1.0")
  ]

plaintext : Part
plaintext =
  { headers = [("Content-Type", "text/plain")]
  , body = ""
  }


-- Helpers functions

mimeFrontier : String
mimeFrontier =
  -- Stubbing the frontier function
  "\n\n4aUk7ggZLF9i6VUhHtrBCTP3AqArp8MH\n"
