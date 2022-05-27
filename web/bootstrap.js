// var serviceWorkerVersion = null;

// window.addEventListener("load", function (ev) {
//   // Download main.dart.js
//   _flutter.loader
//     .loadEntrypoint({
//       serviceWorker: {
//         serviceWorkerVersion: serviceWorkerVersion,
//       },
//     })
//     .then(function (engineInitializer) {
//       return engineInitializer.initializeEngine();
//     })
//     .then(function (appRunner) {
//       return appRunner.runApp();
//     });
// });

const firebaseConfig = {
  apiKey: "AIzaSyC2fwBWZv4-SlhzkS-7o7y3s1S0bxKMJxs",
  authDomain: "ginco-personal-wallet-dev.firebaseapp.com",
  projectId: "ginco-personal-wallet-dev",
  storageBucket: "ginco-personal-wallet-dev.appspot.com",
  messagingSenderId: "613660764245",
  appId: "1:613660764245:web:66c17bbfac0ee0125b0cdc",
  measurementId: "G-WV8LT2NKTM",
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
