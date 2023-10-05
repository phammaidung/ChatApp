const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore

  .document("chat_room/{chatRoomId}/chat/{chatId}")
  .onCreate(async (snapshot) => {
    const notification = snapshot.data();

    // Get the user's device token from Firestore
    const userRef = admin
      .firestore()
      .collection("users")
      .doc(notification.userId);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    const deviceToken = userData["deviceToken"];

    // Create the notification payload
    const payload = {
      notification: {
        title: notification["username"],
        body: notification["message"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    return admin.messaging().sendToDevice(deviceToken, payload);
    // // Return this function's promise, so this ensures the firebase function
    // // will keep running, until the notification is scheduled.
    // return admin.messaging().sendToTopic("chat", {
    //   // Sending a notification message.
    //   notification: {
    //     title: snapshot.data()["username"],
    //     body: snapshot.data()["message"],
    //     clickAction: "FLUTTER_NOTIFICATION_CLICK",
    //   },
    // });
  });

exports.myFunctionTopicChat = functions.firestore

  .document("chat_room/{chatRoomId}/chat/{chatId}")
  .onCreate((snapshot, context) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
    return admin.messaging().sendToTopic("chat", {
      // Sending a notification message.
      notification: {
        title: snapshot.data()["username"],
        body: snapshot.data()["message"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });
