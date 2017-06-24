module CryptoForm.Config exposing (..)

type alias Flags =
  { baseUrl : String
  , defaultEmail : String
  , defaultName : String
  , domain : String
  }


baseUrl : Flags -> String
baseUrl flags =
  flags.baseUrl


defaultEmail : Flags -> String
defaultEmail flags =
  flags.defaultEmail


defaultName : Flags -> String
defaultName flags =
  flags.defaultName


domain : Flags -> String
domain flags =
  flags.domain
