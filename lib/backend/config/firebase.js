const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
// You'll need to download the service account key from Firebase Console
// and place it in the config folder as 'firebase-service-account.json'

let firebaseApp = null;

try {
  // Check if Firebase is already initialized
  if (!admin.apps.length) {
    const serviceAccount = require('./firebase-service-account.json');
    
    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      // Add your Firebase project ID here
      projectId: 'skillsocket-a0759'
    });
    
    console.log('✅ Firebase Admin SDK initialized successfully');
  } else {
    firebaseApp = admin.app();
  }
} catch (error) {
  console.log('⚠️ Firebase Admin SDK not initialized:', error.message);
  console.log('📝 To enable push notifications:');
  console.log('1. Create a Firebase project');
  console.log('2. Download service account key');
  console.log('3. Place it as config/firebase-service-account.json');
  console.log('4. Update projectId in config/firebase.js');
}

module.exports = {
  admin,
  firebaseApp,
  isInitialized: () => firebaseApp !== null
};
