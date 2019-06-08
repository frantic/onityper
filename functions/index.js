const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.appendLines = functions.https.onRequest(async (request, response) => {
  for (const line of request.body) {
    await admin.database().ref('/lines').push({line});
  }
  response.send(`${request.body.length} lines appended\n`);
});
