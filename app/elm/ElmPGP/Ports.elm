port module ElmPGP.Ports exposing ( encrypt, ciphertext, verify, fingerprint )

import ElmPGP.Types exposing (Options)

port encrypt : ( Options ) -> Cmd msg

port ciphertext : ( String -> msg ) -> Sub msg

port verify : ( String, String ) -> Cmd msg

port fingerprint : ( (String, String) -> msg ) -> Sub msg
