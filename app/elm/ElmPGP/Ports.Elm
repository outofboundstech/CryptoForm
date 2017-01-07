port module ElmPGP.Ports exposing ( encrypt, ciphertext )

import ElmPGP.Types exposing (Options)

port encrypt : ( Options ) -> Cmd msg

port ciphertext : ( String -> msg ) -> Sub msg
