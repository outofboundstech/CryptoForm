CryptoForm
==========

*By [451Labs](451labs.org)*

To do
* Mailman takes Identity
* Refactor fingerprint out from Main.elm (deals only with Identity)
* Get rid of pub : Maybe String (pub is always prefetched)
- Perhaps Identities can expose a 'verifier' field (String)
- When there's a fingerprint mismatch, inform the server
