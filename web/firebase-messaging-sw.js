importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-storage.js");
firebase.initializeApp({
    apiKey: "AIzaSyD5qAMy9jtcQxUGQUX38ZZ9RnrZi8TXZOY",
    authDomain: "lifestyle-f0e4e.firebaseapp.com",
    projectId: "lifestyle-f0e4e",
    storageBucket: "lifestyle-f0e4e.appspot.com",
    messagingSenderId: "719786289421",
    appId: "1:719786289421:web:d96bdea27ad1c9c0f42844",
    measurementId: "G-PTGJMCT0RP"

});
const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});

