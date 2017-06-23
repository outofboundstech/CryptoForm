module Main exposing (main)

{-| This is an obligatory comment

# Basics
@docs main
-}

import CryptoForm.Config exposing (Flags)
import CryptoForm.Model exposing (Model, Msg(..), init, update)
import CryptoForm.Views exposing (view)

import ElmPGP.Ports

import Html


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ ElmPGP.Ports.ciphertext Send
    , ElmPGP.Ports.fingerprint Verify
    ]


{-| main
-}
main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
