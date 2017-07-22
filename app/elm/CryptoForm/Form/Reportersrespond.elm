module CryptoForm.Form.Reportersrespond exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, id, for, type_, value)
import Html.Events exposing (onInput)


type Descriptor
  -- Personal information (name and email handled by parent)
  = Sex String
  | DateofBirth String
  | Phone String
  | Skype String
  | Country String
  | Languages String
  | Profession String
  | Workplace String
  | Media String
  -- Case information
  | Persecution String
  | Reports String
  | Evidence String
  | Situation String
  | Reason String
  | Need String
  | Wishlist String
  | Urgency String
  | Applications String
  | Sources String



type Model = Model
  -- Personal information
  { sex : String
  , dateofBirth : String
  , phone : String
  , skype : String
  , country : String
  , languages : String
  , profession : String
  , workplace : String
  , media : String
  -- Case information
  , persecution : String
  , reports : String
  , evidence : String
  , situation : String
  , reason : String
  , need : String
  , wishlist : String
  , urgency : String
  , applications : String
  , sources : String
  }


update : Descriptor -> Model -> Model
update desc (Model model) =
  case desc of
    -- Personal information
    Sex val ->
      Model { model | sex = val }
    DateofBirth val ->
      Model { model | dateofBirth = val }
    Phone val ->
      Model { model | phone = val }
    Skype val ->
      Model { model | skype = val }
    Country val ->
      Model { model | country = val }
    Languages val ->
      Model { model | languages = val }
    Profession val ->
      Model { model | profession = val }
    Workplace val ->
      Model { model | workplace = val }
    Media val ->
      Model { model | media = val }
    -- Case information
    Persecution val ->
      Model { model | persecution = val }
    Reports val ->
      Model { model | reports = val }
    Evidence val ->
      Model { model | evidence = val }
    Situation val ->
      Model { model | situation = val }
    Reason val ->
      Model { model | reason = val }
    Need val ->
      Model { model | need = val }
    Wishlist val ->
      Model { model | wishlist = val }
    Urgency val ->
      Model { model | urgency = val }
    Applications val ->
      Model { model | applications = val }
    Sources val ->
      Model { model | sources = val }


view : Model -> Html Descriptor
view ( Model model ) =
  div [] [
    div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "sexInput" ] [ text "Sex" ]
        , input
          [ class "u-full-width"
          , id "sexInput"
          , type_ "text"
          , value model.sex
          , onInput Sex
          ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "dateofBirthInput" ] [ text "Date of birth" ]
        , input
          [ class "u-full-width"
          , id "dateofBirthInput"
          , type_ "date"
          , value model.dateofBirth
          , onInput DateofBirth
          ] []
        ]
      ]
    , div [ class "row" ]
      [ div [ class "six columns" ]
        [ label [ for "phoneInput" ] [ text "Phone number" ]
        , input
          [ class "u-full-width"
          , id "phoneInput"
          , type_ "text"
          , value model.phone
          , onInput Phone
          ] []
        ]
      , div [ class "six columns" ]
        [ label [ for "skypeInput" ] [ text "Skype username" ]
        , input
          [ class "u-full-width"
          , id "skypeInput"
          , type_ "text"
          , value model.skype
          , onInput Skype
          ] []
        ]
      ]
    ]

init : Model
init = Model
  -- Personal information
  { sex = "male"
  , dateofBirth = "1980-01-01"
  , phone = "06 1234 5678"
  , skype = "skype_username"
  , country = "country"
  , languages = "English, Dutch"
  , profession = "Profession"
  , workplace = "Workplace"
  , media = "Media 1, newsroom 2"
  -- Case information
  , persecution = "Persecution"
  , reports = "Reports"
  , evidence = "Evidence"
  , situation = "Situation"
  , reason = "Reason"
  , need = "Need"
  , wishlist = "Wishlist"
  , urgency = "Urgency"
  , applications = "Application"
  , sources = "Sources"
  }


ready : Model -> Bool
ready ( Model model ) =
  True

serialize : Model -> String
serialize model =
  "Hello, World!"
