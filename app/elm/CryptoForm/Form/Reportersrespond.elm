module CryptoForm.Form.Reportersrespond exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


-- import CryptoForm.Fields exposing (field, date, input, textarea)

import ElmMime.Main exposing (crlf)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Descriptor
  -- Personal information (name and email handled by parent)
  = DateofBirth String
  | Sex String
  | Phone String
  | Skype String
  | Nationality String
  | Location String
  | Profession String
  | Workplace String
  | Experience String
  -- Case information
  | Reasons String
  | Evidence String
  | Situation String
  | Needs String
  | Support String
  | References String



type Model = Model
  -- Personal information
  { dateofBirth : String
  , sex : String
  , phone : String
  , skype : String
  , nationality : String
  , location : String
  , profession : String
  , workplace : String
  , experience : String
  -- Case information
  , reasons : String
  , evidence : String
  , situation : String
  , needs : String
  , support : String
  , references : String
  }


update : Descriptor -> Model -> Model
update desc (Model model) =
  case desc of
    -- Personal information
    DateofBirth val ->
      Model { model | dateofBirth = val }
    Sex val ->
      Model { model | sex = val }
    Phone val ->
      Model { model | phone = val }
    Skype val ->
      Model { model | skype = val }
    Nationality val ->
      Model { model | nationality = val }
    Location val ->
      Model { model | location = val }
    Profession val ->
      Model { model | profession = val }
    Workplace val ->
      Model { model | workplace = val }
    Experience val ->
      Model { model | experience = val }
    -- Case information
    Reasons val ->
      Model { model | reasons = val }
    Evidence val ->
      Model { model | evidence = val }
    Situation val ->
      Model { model | situation = val }
    Needs val ->
      Model { model | needs = val }
    Support val ->
      Model { model | support = val }
    References val ->
      Model { model | references = val }


view : Model -> Html Descriptor
view ( Model model ) =
  div [ ]
  [ fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-5"]
        [ label [ for "phoneInput" ] [ text "Phone Number" ]
        , input
          [ id "phoneInput"
          , class "form-control"
          , type_ "text"
          , value model.phone
          , onInput Phone
          ] [ ]
        ]
      , div [ class "col-sm-5" ]
        [ label [ for "skypeInput" ] [ text "Skype username" ]
        , input
          [ id "skypeInput"
          , class "form-control"
          , type_ "text"
          , value model.skype
          , onInput Skype
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-5"]
        [ label [ for "dateofBirthInput" ] [ text "Date of Birth" ]
        , input
          [ id "dateofBirthInput"
          , class "form-control"
          , type_ "date"
          , value model.dateofBirth
          , onInput DateofBirth
          ] [ ]
        ]
      , div [ class "col-sm-5" ]
        [ label [ for "sexInput" ] [ text "Male/female" ]
        , input
          [ id "sexInput"
          , class "form-control"
          , type_ "text"
          , value model.sex
          , onInput Sex
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-5"]
        [ label [ for "nationalityInput" ] [ text "Nationality" ]
        , input
          [ id "nationalityInput"
          , class "form-control"
          , type_ "text"
          , value model.nationality
          , onInput Nationality
          ] [ ]
        ]
      , div [ class "col-sm-5" ]
        [ label [ for "locationInput" ] [ text "Current location" ]
        , input
          [ id "locationInput"
          , class "form-control"
          , type_ "text"
          , value model.location
          , onInput Location
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-5"]
        [ label [ for "professionInput" ] [ text "Profession" ]
        , input
          [ id "professionInput"
          , class "form-control"
          , type_ "text"
          , value model.profession
          , onInput Profession
          ] [ ]
        ]
      , div [ class "col-sm-5" ]
        [ label [ for "workplaceInput" ] [ text "Workplace" ]
        , input
          [ id "workplaceInput"
          , class "form-control"
          , type_ "text"
          , value model.workplace
          , onInput Workplace
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-10"]
        [ label [ for "experienceInput" ] [ text "List of previous employers" ]
        , textarea
          [ id "experienceInput"
          , class "form-control"
          , value model.experience
          , onInput Experience
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ ]
      , div [ class "col-sm-10"]
        [ label [ for "evidenceInput" ] [ text "Provide evidence of your work as a media worker (links) or upload material underneath" ]
        , textarea
          [ id "experienceInput"
          , class "form-control"
          , value model.experience
          , onInput Experience
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ text "Application" ]
      , div [ class "col-sm-10"]
        [ label [ for "reasonsInput" ]
          [ text "What are your reasons for applying to reporters Respond?"
          , ul [ ]
            [ li [ ] [ text "Describe the events that resulted in your current situation" ]
            , li [ ] [ text "Describe your current situation in some detail" ]
            ]
          ]
        , textarea
          [ id "reasonsInput"
          , class "form-control"
          , value model.reasons
          , onInput Reasons
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ text "" ]
      , div [ class "col-sm-10"]
        [ label [ for "needsInput" ] [ text "Please tell us what you need and why. Also provide a budget." ]
        , textarea
          [ id "needsInput"
          , class "form-control"
          , value model.needs
          , onInput Needs
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ text "" ]
      , div [ class "col-sm-10"]
        [ label [ for "supportInput" ] [ text "Have you applied for support from other organisations? If yes, which ones?" ]
        , textarea
          [ id "supportInput"
          , class "form-control"
          , value model.support
          , onInput Support
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-2" ] [ text "" ]
      , div [ class "col-sm-10"]
        [ label [ for "referencesInput" ] [ text "Please provide at least two references that can confirm your story. Include contact details if possible." ]
        , textarea
          [ id "referencesInput"
          , class "form-control"
          , value model.references
          , onInput References
          ] [ ]
        ]
      ]
    ]
  ]

    -- , textarea "reasonsInput"
    --   ( field
    --     { label = "Reasons", msg = Reasons, value = model.reasons }
    --   ) [ placeholder "Please briefly describe your reasons for applying to Reporters Respond." ]
    -- , textarea "evidenceInput"
    --   ( field
    --     { label = "Evidence", msg = Evidence, value = model.evidence }
    --   ) [ placeholder "Please provide evidence of your work as a media worker (links) or upload materials underneath this message." ]
    -- , textarea "situationInput"
    --   ( field
    --     { label = "Current situation", msg = Situation, value = model.situation }
    --   ) [ placeholder "Please describe your current situation." ]
    -- , textarea "needsInput"
    --   ( field
    --     { label = "Needs", msg = Needs, value = model.needs }
    --   ) [ placeholder "Please indicate what exactly you need. Also provide preliminary costs, if any." ]
    -- , textarea "supportInput"
    --   ( field
    --     { label = "Support", msg = Support, value = model.support }
    --   ) [ placeholder "Have you applied for support from other organsiations?" ]
    -- , textarea "referencesInput"
    --   (field
    --   { label = "Sources/references", msg = References, value = model.references }
    --   ) [ placeholder "Please provide at least 2 sources/references that can confirm your story." ]
    -- ]


init : Model
init = Model
  -- Personal information
  { dateofBirth = ""
  , sex = ""
  , phone = ""
  , skype = ""
  , nationality = ""
  , location = ""
  , profession = ""
  , workplace = ""
  , experience = ""
  -- Case information
  , reasons = ""
  , evidence = ""
  , situation = ""
  , needs = ""
  , support = ""
  , references = ""
  }


ready : Model -> Bool
ready ( Model model ) =
  True


serialize : Model -> String
serialize ( Model model ) =
  String.concat
    -- Personal information
    [ "**Date of birth**", crlf, model.dateofBirth, crlf, crlf
    , "**Sex**", crlf, model.sex, crlf, crlf
    , "**Phone number**", crlf, model.phone, crlf, crlf
    , "**Skype username**", crlf, model.skype, crlf, crlf
    , "**Nationality**", crlf, model.nationality, crlf, crlf
    , "**Current location**", crlf, model.location, crlf, crlf
    , "**Profession**", crlf, model.profession, crlf, crlf
    , "**Workplace**", crlf, model.workplace, crlf, crlf
    , "**Experience**", crlf, model.experience, crlf, crlf
    -- Case information
    , "**Reasons for applying**", crlf, model.reasons, crlf, crlf
    , "**Evidence**", crlf, model.evidence, crlf, crlf
    , "**Current situation**", crlf, model.situation, crlf, crlf
    , "**Needs**", crlf, model.needs, crlf, crlf
    , "**Support/other applications**", crlf, model.support, crlf, crlf
    , "**Sources/references**", crlf, model.references, crlf, crlf
    ]
