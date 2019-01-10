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
  | Social String
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
  , social : String
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
    Social val ->
      Model { model | social = val }
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
      [ div [ class "col-sm"]
        [ label [ for "phoneInput" ] [ text "Phone number" ]
        , input
          [ id "phoneInput"
          , class "form-control"
          , type_ "text"
          , value model.phone
          , onInput Phone
          ] [ ]
        ]
      , div [ class "col-sm" ]
        [ label [ for "socialInput" ] [ text "Social media (Twitter, Facebook, etc.)" ]
        , input
          [ id "socialInput"
          , class "form-control"
          , type_ "text"
          , value model.social
          , onInput Social
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "dateofBirthInput" ] [ text "Date of Birth" ]
        , input
          [ id "dateofBirthInput"
          , class "form-control"
          , type_ "date"
          , value model.dateofBirth
          , placeholder "dd/mm/yyyy"
          , onInput DateofBirth
          ] [ ]
        ]
      , div [ class "col-sm" ]
        [ label [ for "sexInput" ] [ text "Gender (male, female, other...)" ]
        , input
          [ id "sexInput"
          , class "form-control"
          , type_ "text"
          , value model.sex
          , placeholder "required"
          , onInput Sex
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "nationalityInput" ] [ text "Nationality" ]
        , input
          [ id "nationalityInput"
          , class "form-control"
          , type_ "text"
          , value model.nationality
          , placeholder "required"
          , onInput Nationality
          ] [ ]
        ]
      , div [ class "col-sm" ]
        [ label [ for "locationInput" ] [ text "Current location" ]
        , input
          [ id "locationInput"
          , class "form-control"
          , type_ "text"
          , value model.location
          , placeholder "required"
          , onInput Location
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "professionInput" ] [ text "Profession" ]
        , input
          [ id "professionInput"
          , class "form-control"
          , type_ "text"
          , value model.profession
          , placeholder "required"
          , onInput Profession
          ] [ ]
        ]
      , div [ class "col-sm" ]
        [ label [ for "workplaceInput" ] [ text "Workplace" ]
        , input
          [ id "workplaceInput"
          , class "form-control"
          , type_ "text"
          , value model.workplace
          , placeholder "required"
          , onInput Workplace
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "experienceInput" ] [ text "List of previous employers" ]
        , textarea
          [ id "experienceInput"
          , class "form-control"
          , value model.experience
          , placeholder "required"
          , onInput Experience
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "evidenceInput" ] [ text "Provide evidence of your work as a media worker (links) or upload material underneath" ]
        , textarea
          [ id "experienceInput"
          , class "form-control"
          , value model.evidence
          , placeholder "required"
          , onInput Evidence
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ legend [ class "col-12" ] [ text "Application details" ]
      , div [ class "col-sm" ]
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
          , placeholder "required"
          , onInput Reasons
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "needsInput" ] [ text "Please tell us what you need and why. Also provide a budget." ]
        , textarea
          [ id "needsInput"
          , class "form-control"
          , value model.needs
          , placeholder "required"
          , onInput Needs
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "supportInput" ] [ text "Have you applied for support from other organisations? If yes, which ones?" ]
        , textarea
          [ id "supportInput"
          , class "form-control"
          , value model.support
          , placeholder "required"
          , onInput Support
          ] [ ]
        ]
      ]
    ]
  , fieldset [ class "form-group" ]
    [ div [ class "row" ]
      [ div [ class "col-sm"]
        [ label [ for "referencesInput" ] [ text "Please provide at least two references that can confirm your story. Include contact details if possible." ]
        , textarea
          [ id "referencesInput"
          , class "form-control"
          , value model.references
          , placeholder "required"
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
  , social = ""
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
  && (String.length model.dateofBirth) /= 0
  && (String.length model.sex) /= 0
  && (String.length model.nationality) /= 0
  && (String.length model.location) /= 0
  && (String.length model.profession) /= 0
  && (String.length model.workplace) /= 0
  && (String.length model.experience) /= 0
  && (String.length model.reasons) /= 0
  && (String.length model.evidence) /= 0
  && (String.length model.needs) /= 0
  && (String.length model.support) /= 0
  && (String.length model.references) /= 0


serialize : Model -> String
serialize ( Model model ) =
  String.concat
    -- Personal information
    [ "**Phone number**", crlf, model.phone, crlf, crlf
    , "**Social media (Twitter, Facebook, etc.)**", crlf, model.social, crlf, crlf
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
