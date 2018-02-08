module CryptoForm.Form.Reportersrespond exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import CryptoForm.Fields exposing (field, date, input, textarea)

import ElmMime.Main exposing (crlf)

import Html exposing (Html, fieldset)
import Html.Attributes exposing (placeholder, value)


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
  fieldset [ ]
    -- Personal information
    [ date "dateofBirthInput"
      ( field
        { label = "Date of Birth", msg = DateofBirth, value = model.dateofBirth }
      ) []
    , input "sexInput"
      ( field
        { label = "Sex", msg = Sex, value = model.sex }
      ) [ placeholder "Male/female" ]
    , input "phoneInput"
      ( field
        { label = "Phone", msg = Phone, value = model.phone }
      ) [ placeholder "Phone number" ]
    , input "skypeInput"
      ( field
        { label = "Skype", msg = Skype, value = model.skype }
      ) [ placeholder "Skype username" ]
    , input "nationalityInput"
      ( field
        { label = "Nationality", msg = Nationality, value = model.nationality }
      ) [ placeholder "Nationality" ]
    , input "locationInput"
      ( field
        { label = "Location", msg = Location, value = model.location }
      ) [ placeholder "Current location" ]
    , input "professionInput"
      ( field
        { label = "Profession", msg = Profession, value = model.profession }
      ) [ placeholder "Profession" ]
    , input "workplaceInput"
      ( field
        { label = "Workplace", msg = Workplace, value = model.workplace }
      ) [ placeholder "Current workplace" ]
    , input "experienceInput"
      ( field
        { label = "Experience", msg = Experience, value = model.experience }
      ) [ placeholder "Previous employers" ]
    -- Case information
    , textarea "reasonsInput"
      ( field
        { label = "Reasons", msg = Reasons, value = model.reasons }
      ) [ placeholder "Please briefly describe your reasons for applying to Reporters Respond." ]
    , textarea "evidenceInput"
      ( field
        { label = "Evidence", msg = Evidence, value = model.evidence }
      ) [ placeholder "Please provide evidence of your work as a media worker (links) or upload materials underneath this message." ]
    , textarea "situationInput"
      ( field
        { label = "Current situation", msg = Situation, value = model.situation }
      ) [ placeholder "Please describe your current situation." ]
    , textarea "needsInput"
      ( field
        { label = "Needs", msg = Needs, value = model.needs }
      ) [ placeholder "Please indicate what exactly you need. Also provide preliminary costs, if any." ]
    , textarea "supportInput"
      ( field
        { label = "Support", msg = Support, value = model.support }
      ) [ placeholder "Have you applied for support from other organsiations?" ]
    , textarea "referencesInput"
      (field
      { label = "Sources/references", msg = References, value = model.references }
      ) [ placeholder "Please provide at least 2 sources/references that can confirm your story." ]
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
