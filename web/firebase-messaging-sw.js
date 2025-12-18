importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDOqBpCG6dcyADfM90PnBJMfTiAzPXoV1Q",
  authDomain: "avioflai-app-934cc.firebaseapp.com",
  projectId: "avioflai-app-934cc",
  storageBucket: "avioflai-app-934cc.appspot.com",
  messagingSenderId: "951110180167",
  appId: "1:951110180167:web:741708ee5aac580a084062"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  console.log('[SW] Background message:', payload);

  const title = payload.notification?.title || 'New Notification';
  const body = payload.notification?.body || '';

  self.registration.showNotification(title, {
    body: body,
    icon: '/icons/Icon-192.png',
  });
});
