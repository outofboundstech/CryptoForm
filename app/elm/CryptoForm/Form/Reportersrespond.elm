module CryptoForm.Form.Reportersrespond exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import Html exposing (Html, div, fieldset, input, label, text)
import Html.Attributes exposing (class, id, for, placeholder, type_, value)
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
  fieldset [ ]
    [ div [ class "pure-control-group" ]
      [ label [ for "sexInput" ] [ text "Sex" ]
      , input
        [ class "pure-u-1-2"
        , id "sexInput"
        , type_ "text"
        , value model.sex
        , placeholder "Sex"
        , onInput Sex
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "dateofBirthInput" ] [ text "Date of birth" ]
      , input
        [ class "pure-u-1-2"
        , id "dateofBirthInput"
        , type_ "date"
        , value model.dateofBirth
        , onInput DateofBirth
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "phoneInput" ] [ text "Phone" ]
      , input
        [ class "pure-u-1-2"
        , id "phoneInput"
        , type_ "text"
        , value model.phone
        , placeholder "Phone number"
        , onInput Phone
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "skypeInput" ] [ text "Skype" ]
      , input
        [ class "pure-u-1-2"
        , id "skypeInput"
        , type_ "text"
        , value model.skype
        , placeholder "Skype username"
        , onInput Skype
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "countryInput" ] [ text "Country" ]
      , input
        [ class "pure-u-1-2"
        , id "countryInput"
        , type_ "text"
        , value model.country
        , placeholder "Country of residence"
        , onInput Country
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "languagesInput" ] [ text "Languages" ]
      , input
        [ class "pure-u-1-2"
        , id "languagesInput"
        , type_ "text"
        , value model.languages
        , placeholder "Language"
        , onInput Languages
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "professionInput" ] [ text "Profession" ]
      , input
        [ class "pure-u-1-2"
        , id "professionInput"
        , type_ "text"
        , value model.profession
        , placeholder "Profession"
        , onInput Profession
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "workplaceInput" ] [ text "Workplace" ]
      , input
        [ class "pure-u-1-2"
        , id "workplaceInput"
        , type_ "text"
        , value model.workplace
        , placeholder "Workplace"
        , onInput Workplace
        ] [ ]
      ]
    , div [ class "pure-control-group" ]
      [ label [ for "mediaInput" ] [ text "Media" ]
      , input
        [ class "pure-u-1-2"
        , id "mediaInput"
        , type_ "text"
        , value model.media
        , placeholder "Media"
        , onInput Media
        ] [ ]
      ]
    ]

init : Model
init = Model
  -- Personal information
  { sex = ""
  , dateofBirth = ""
  , phone = ""
  , skype = ""
  , country = ""
  , languages = ""
  , profession = ""
  , workplace = ""
  , media = ""
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
