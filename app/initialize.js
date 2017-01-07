document.addEventListener('DOMContentLoaded', function() {
  var openpgp = window.openpgp; // use as CommonJS, AMD, ES6 module or via window.openpgp

  openpgp.initWorker({ path:'openpgp.worker.min.js' }); // set the relative web worker path

  // openpgp.config.aead_protect = true; // activate fast AES-GCM mode (not yet OpenPGP standard)

  var node = document.getElementById('root');

  var app = Elm.Main.embed(node);

  app.ports.encrypt.subscribe(function(data) {

    // Transform armored keys to OpenPGP internal format
    options = {
      publicKeys : openpgp.key.readArmored(data.publicKeys).keys,
      privateKeys :  openpgp.key.readArmored(data.privateKeys).keys,
      data : data.data,
      armor : data.armor
    };

    // console.log(options);

    // Encrypt with options
    openpgp.encrypt(options).then(function(payload) {

      // console.log(payload);
      app.ports.ciphertext.send(payload.data);

    });
  });
});
