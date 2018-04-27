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
      [ div [ class "col-sm-6"]
        [ label [ for "phoneInput" ] [ text "Phone Number" ]
        , input
          [ id "phoneInput"
          , class "form-control"
          , type_ "text"
          , value model.phone
          , onInput Phone
          ] [ ]
        ]
      , div [ class "col-sm-6" ]
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
      [ div [ class "col-sm-6"]
        [ label [ for "dateofBirthInput" ] [ text "Date of Birth" ]
        , input
          [ id "dateofBirthInput"
          , class "form-control"
          , type_ "date"
          , value model.dateofBirth
          , onInput DateofBirth
          ] [ ]
        ]
      , div [ class "col-sm-6" ]
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
      [ div [ class "col-sm-6"]
        [ label [ for "nationalityInput" ] [ text "Nationality" ]
        , input
          [ id "nationalityInput"
          , class "form-control"
          , type_ "text"
          , value model.nationality
          , onInput Nationality
          ] [ ]
        ]
      , div [ class "col-sm-6" ]
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
      [ div [ class "col-sm-6"]
        [ label [ for "professionInput" ] [ text "Profession" ]
        , input
          [ id "professionInput"
          , class "form-control"
          , type_ "text"
          , value model.profession
          , onInput Profession
          ] [ ]
        ]
      , div [ class "col-sm-6" ]
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
      [ div [ class "col-sm-12"]
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
      [ div [ class "col-sm-12"]
        [ label [ for "evidenceInput" ] [ text "Provide evidence of your work as a media worker (links) or upload material underneath" ]
        , textarea
          [ id "experienceInput"
          , class "form-control"
          , value model.evidence
          , onInput Evidence
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-sm-12" ] [ text "Application details" ]
      , div [ class "col-sm-12" ]
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
      [ div [ class "col-sm-12"]
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
      [ div [ class "col-sm-12"]
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
      [ div [ class "col-sm-12"]
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
    [ "**Phone number**", crlf, model.phone, crlf, crlf
    , "**Skype username**", crlf, model.skype, crlf, crlf
    , "**Date of birth**", crlf, model.dateofBirth, crlf, crlf
    , "**Male/female**", crlf, model.sex, crlf, crlf
    , "**Nationality**", crlf, model.nationality, crlf, crlf
    , "**Current location**", crlf, model.location, crlf, crlf
    , "**Profession**", crlf, model.profession, crlf, crlf
    , "**Workplace**", crlf, model.workplace, crlf, crlf
    , "**List of previous employers**", crlf, model.experience, crlf, crlf
    , "**Evidence of work as a media worker**", crlf, model.evidence, crlf, crlf
    -- Case information
    , "**Reasons for applying**", crlf, model.reasons, crlf, crlf
    , "**What he/she needs and why (incl. budget)**", crlf, model.needs, crlf, crlf
    , "**Has applied for support from other organisations?**", crlf, model.support, crlf, crlf
    , "**At least two references that can confirm the story**", crlf, model.references, crlf, crlf
    ]
