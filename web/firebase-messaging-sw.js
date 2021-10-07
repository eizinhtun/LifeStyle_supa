importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-storage.js");
firebase.initializeApp({
        apiKey: "AIzaSyBWlbheVA4PN-acHACHWm2_yh17S9OEPVI",
        authDomain: "epcapp-df336.firebaseapp.com",
        projectId: "epcapp-df336",
        storageBucket: "epcapp-df336.appspot.com",
        messagingSenderId: "106900086927",
        appId: "1:106900086927:web:3be091cdec18d85e0b50fa"

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

