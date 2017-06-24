module CryptoForm.Config exposing (Flags, baseUrl)

type alias Flags =
  { baseUrl : String
  }


baseUrl : Flags -> String
baseUrl flags =
  flags.baseUrl
