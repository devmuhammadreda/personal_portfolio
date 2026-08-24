// Seeds the `admin: true` custom claim on an existing Auth user.
//
// 1. Create the user first (Firebase Console › Authentication › Users).
// 2. Then run:
//      npm install firebase-admin --no-save
//      ADMIN_EMAIL=you@example.com node scripts/set-admin-claim.mjs
//
// `applicationDefault()` uses `gcloud auth application-default login`
// credentials, or GOOGLE_APPLICATION_CREDENTIALS pointing at a service
// account key (see README).

import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

const email = process.env.ADMIN_EMAIL;
if (!email) {
  console.error('Usage: ADMIN_EMAIL=you@example.com node scripts/set-admin-claim.mjs');
  process.exit(1);
}

initializeApp({ credential: applicationDefault() });

try {
  const user = await getAuth().getUserByEmail(email);
  await getAuth().setCustomUserClaims(user.uid, { admin: true });
  console.log(`✓ admin claim set for ${email} (uid: ${user.uid})`);
  console.log('The user must sign out and back in for the claim to refresh.');
} catch (error) {
  console.error(`✗ Failed: ${error.message}`);
  process.exit(1);
}
