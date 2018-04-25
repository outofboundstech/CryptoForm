module CryptoForm.Config exposing (..)

type alias Flags =
  { anonymous : Bool
  , baseUrl : String
  , defaultEmail : String
  , defaultName : String
  , defaultSubject : String
  , domain : String
  , private : Bool
  , showAttachments: Bool
  , showFrom: Bool
  , showSecurity : Bool
  , showSubject : Bool
  , showTo : Bool
  }
