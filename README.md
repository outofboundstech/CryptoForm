CryptoForm
==========

*By [451Labs](451labs.org)*

To do
* Refactor CryptoForm.Identities, ElmMime.Attachments as pure components / pure view functions instead of stateful components:
  * https://medium.com/elm-shorts/a-reusable-dropdown-in-elm-part-1-d7ac2d106f13
  * https://guide.elm-lang.org/reuse/more.html
* Refactor Elm source
* Improve reporting of fingerprint mismatch (esp. server side)
* Implement Native support for OpenPGP.js and base64 encoding
* Implement form validation
* Generalize to arbitrary form fields
* Interact with common key servers
* Optimize Javascript string manipulation
* Metadata scrubbing options on the client
