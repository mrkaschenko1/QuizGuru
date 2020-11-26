const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendToEnTopic = functions.database.ref('/tests/{testId}')
    .onCreate((snapshot, context) => {
       functions.logger.log("Hello from info. Here's an object:", context);
       const test = snapshot.val();
       payload = {
             notification: {
               title: 'New Test!',
               body: `${test.title} is ready to be passed`,
               icon: 'your-icon-url',
               click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
             }
           };

       return admin.messaging().sendToTopic('tests', payload);
    });