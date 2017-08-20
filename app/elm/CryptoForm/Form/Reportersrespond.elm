module CryptoForm.Form.Reportersrespond exposing
  ( Model, Descriptor
  , update, view
  , init, ready
  , serialize
  )


import CryptoForm.Fields exposing (date, input, textarea)

import ElmMime.Main exposing (crlf)

import Html exposing (Html, fieldset)


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
      { label = "Date of Birth"
      , value = model.dateofBirth
      , msg = DateofBirth
      }
    , input "sexInput"
      { label = "Sex"
      , value = model.sex
      , placeholder = "Male/female"
      , msg = Sex
      }
    , input "phoneInput"
      { label = "Phone"
      , value = model.phone
      , placeholder = "Phone number"
      , msg = Phone
      }
    , input "skypeInput"
      { label = "Skype"
      , value = model.skype
      , placeholder = "Skype username"
      , msg = Skype
      }
    , input "nationalityInput"
      { label = "Nationality"
      , value = model.nationality
      , placeholder = "Nationality"
      , msg = Nationality
      }
    , input "locationInput"
      { label = "Location"
      , value = model.location
      , placeholder = "Current location"
      , msg = Location
      }
    , input "professionInput"
      { label = "Profession"
      , value = model.profession
      , placeholder = "Profession"
      , msg = Profession
      }
    , input "workplaceInput"
      { label = "Workplace"
      , value = model.workplace
      , placeholder = "Current workplace"
      , msg = Workplace
      }
    , input "experienceInput"
      { label = "Experience"
      , value = model.experience
      , placeholder = "Previous employers"
      , msg = Experience
      }
    -- Case information
    , textarea "reasonsInput"
      { label = "Reasons"
      , value = model.reasons
      , placeholder = "Please briefly describe your reasons for applying to Reporters Respond."
      , msg = Reasons
      }
    , textarea "evidenceInput"
      { label = "Evidence"
      , value = model.evidence
      , placeholder = "Please provide evidence of your work as a media worker (links) or upload materials underneath this message."
      , msg = Evidence
      }
    , textarea "situationInput"
      { label = "Current situation"
      , value = model.situation
      , placeholder = "Please describe your current situation."
      , msg = Situation
      }
    , textarea "needsInput"
      { label = "Needs"
      , value = model.needs
      , placeholder = "Please indicate what exactly you need. Also provide preliminary costs, if any."
      , msg = Needs
          }
    , textarea "supportInput"
      { label = "Support"
      , value = model.support
      , placeholder = "Have you applied for support from other organsiations?"
      , msg = Support
        }
    , textarea "referencesInput"
      { label = "Sources/references"
      , value = model.references
      , placeholder = "Please provide at least 2 sources/references that can confirm your story."
      , msg = References
      }
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
