module ElmPGP.Types exposing (Options)

{-| ElmPGP types
-}

{-| Encrypt string data with PGP keys; reference:
    https://github.com/openpgpjs/openpgpjs#encrypt-and-decrypt-string-data-with-pgp-keys
-}
type alias Options =
  { data: String
  , publicKeys: String
  , privateKeys: String
  , armor: Bool
  }
