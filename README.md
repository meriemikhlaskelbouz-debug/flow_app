# Flow

Flow is a Flutter application using Firebase Authentication and Cloud Firestore.

## Shared Firebase project

All team members must use the existing Firebase project `flow-mob-app-cb6c6`.
The Android application ID is `com.example.flow_app`; keep it identical on every
developer machine and in the registered Android app in Firebase Console.

Each developer must sign in with their own Google account and have access
granted by a Firebase project administrator before configuring or running the
app. Enable the Authentication providers the app will use and create the
Firestore database in this same project. Do not create a separate project.

Install the Firebase CLI and FlutterFire CLI if needed:

```shell
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

After cloning, authenticate with your own authorized Google account:

```shell
flutter pub get
firebase login
flutterfire configure --project=flow-mob-app-cb6c6
flutter run
```

Keep the generated `lib/firebase_options.dart` and
`android/app/google-services.json` in version control. They contain Firebase
client configuration, not service-account private keys. Do not commit
service-account keys, private certificates, or environment files containing
secrets.

## Firestore user documents

User documents are stored at `users/{uid}`, where `{uid}` is the Firebase
Authentication UID:

```text
users/
  {uid}/
    uid: String
    email: String
    username: String
    isPremium: Boolean
    createdAt: Timestamp
```

After successful registration, the application should create the matching
document with `uid` equal to the Auth UID, `isPremium` set to `false`, and
`createdAt` set using a server timestamp. Never store passwords in Firestore;
Firebase Authentication manages them.

The rules in `firestore.rules` allow an authenticated user to read only their
own document, create their own document with `isPremium: false`, and update
only `email` and `username`. They prevent client-side changes to `uid`,
`createdAt`, and `isPremium`. Collection listing and deletion are denied.
Premium status must be managed by trusted server-side code using the Firebase
Admin SDK; Admin SDK access bypasses Firestore rules. These rules do not enforce
username uniqueness.

To publish rule changes to the shared project, an authorized team member can
run:

```shell
firebase deploy --only firestore:rules
```

Coordinate deployments with the team because rules apply to the shared
database. Authentication and Firestore connectivity have not been tested here.
