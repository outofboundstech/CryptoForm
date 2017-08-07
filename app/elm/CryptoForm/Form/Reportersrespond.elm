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
    -- Personal information
    [ input "sexInput"
      { label = "Sex"
      , value = model.sex
      , placeholder = "Sex"
      , msg = Sex
      }
    , date "dateofBirthInput"
      { label = "Date of Birth"
      , value = model.dateofBirth
      , msg = DateofBirth
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
    , input "countryInput"
      { label = "Country"
      , value = model.country
      , placeholder = "Country of residence"
      , msg = Country
      }
    , input "languagesInput"
      { label = "Languages"
      , value = model.languages
      , placeholder = "Languages"
      , msg = Languages
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
      , placeholder = "Workplace"
      , msg = Workplace
      }
    , input "mediaInput"
      { label = "Media"
      , value = model.media
      , placeholder = "Media"
      , msg = Media
      }
    -- Case information
    , textarea "persecutionInput"
      { label = "Persecution"
      , value = model.persecution
      , msg = Persecution
      }
    , textarea "reportsInput"
      { label = "Reports"
      , value = model.reports
      , msg = Reports
      }
    , textarea "evidenceInput"
      { label = "Evidence"
      , value = model.evidence
      , msg = Evidence
      }
    , textarea "situationInput"
      { label = "Situation"
      , value = model.situation
      , msg = Situation
      }
    , textarea "reasonInput"
      { label = "Reason"
      , value = model.reason
      , msg = Reason
      }
    , textarea "needInput"
      { label = "Need"
      , value = model.need
      , msg = Need
      }
    , textarea "wishlistInput"
      { label = "Wishlist"
      , value = model.wishlist
      , msg = Wishlist
      }
    , textarea "urgencyInput"
      { label = "Urgency"
      , value = model.urgency
      , msg = Urgency
      }
    , textarea "applicationsInput"
      { label = "Applications"
      , value = model.applications
      , msg = Applications
      }
    , textarea "sourcesInput"
      { label = "Sources"
      , value = model.sources
      , msg = Sources
      }
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
  , persecution = ""
  , reports = ""
  , evidence = ""
  , situation = ""
  , reason = ""
  , need = ""
  , wishlist = ""
  , urgency = ""
  , applications = ""
  , sources = ""
  }


ready : Model -> Bool
ready ( Model model ) =
  True

serialize : Model -> String
serialize ( Model model ) =
  String.concat
    -- Personal information
    [ "**Sex**", crlf, model.sex, crlf, crlf
    , "**Date of birth**", crlf, model.dateofBirth, crlf, crlf
    , "**Phone number**", crlf, model.phone, crlf, crlf
    , "**Skype username**", crlf, model.skype, crlf, crlf
    , "**Country of residence**", crlf, model.country, crlf, crlf
    , "**Languages**", crlf, model.languages, crlf, crlf
    , "**Profession**", crlf, model.profession, crlf, crlf
    , "**Workplace**", crlf, model.workplace, crlf, crlf
    , "**Media**", crlf, model.media, crlf, crlf
    -- Case information
    , "**Persection**", crlf, model.persecution, crlf, crlf
    , "**Reports**", crlf, model.reports, crlf, crlf
    , "**Evidence**", crlf, model.evidence, crlf, crlf
    , "**Situation**", crlf, model.situation, crlf, crlf
    , "**Reason**", crlf, model.reason, crlf, crlf
    , "**Need**", crlf, model.need, crlf, crlf
    , "**Wishlist**", crlf, model.wishlist, crlf, crlf
    , "**Urgency**", crlf, model.urgency, crlf, crlf
    , "**Applications**", crlf, model.applications, crlf, crlf
    , "**Sources**", crlf, model.sources, crlf, crlf
    ]
