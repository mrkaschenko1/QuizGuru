const functions = require('firebase-functions');

export const sendToTopic = functions.firestore
  .document('tests/{testId}')
  .onCreate(async snapshot => {
    const test = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Test!',
        body: `${test.title} is ready to be passed`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic('tests', payload);
  });