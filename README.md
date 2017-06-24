# CryptoForm

*A product of [451Labs](http://451labs.org) by [Out of Bounds Technology](http://outofbounds.technology).*

__Client-side PGP/Mime e-mail form__ Users compose e-mail in the browsers and select the addressee from a dropdown. CryptoForm supports email attachments using the Mime format and implements the PGP/Mime standard described in [RFC 3156](https://tools.ietf.org/html/rfc3156).

E-mail adddresses of addressees are never exposed to the "world". CryptoForm pulls public keys and accompanying metadata from a server. This server also transfers (using SMTP) the encrypted email content on the client's behalf. CryptoForm currently support the API exposed by [keyserv](https://www.github.com/outofboundstech/keyserv). Support for HKP key servers and [Keybase](https://keybase.io) is on the roadmap.

CryptoForm relies on [OpenPGP.js](https://openpgpjs.org/) for cryptography. All cryptographic operations take place on the client (in the browser). Neither the e-mail body nor any attachments ever leave the user's computer unencrypted.

---

## No License

I'm still working out which license is the best fit for CryptoForm. Do you have advice for me on how to [choose a license](https://choosealicense.com/)? Please [get in touch](https://github.com/outofboundstech/CryptoForm/issues/1). In the meantime, read up on the '[no license](https://choosealicense.com/no-license/)' license.

---

## Libraries

CryptoForm relies on (and includes) the following libraries:

### Javascript

* [OpenPGP.js](https://openpgpjs.org/) OpenPGP JavaScript Implementation
* [base64.js](https://github.com/beatgammit/base64-js) Base64 encoding/decoding in pure JS
* [elm-mimetype](https://github.com/danyx23/elm-mimetype/) Library to model common mime types in elm
* [file-reader](https://github.com/simonh1000/file-reader) Elm native bindings for HTML5 FileReader API
* [elm](http://elm-lang.org/) A delightful language for reliable webapps

### CSS

* [Skeleton](http://getskeleton.com/) A dead simple, responsive boilerplate

---

*CryptoForm &copy; [Out of Bounds – Exceptional Technology](http://outofbounds.technology) 2017.*
