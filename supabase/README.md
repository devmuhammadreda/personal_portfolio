# Contact messages — backend setup

One-time setup so the portfolio contact form saves messages to Supabase
and emails you a notification via Resend.

## 1. Create the table

Run the SQL in `migrations/20260825000000_contact_messages.sql` in the
Supabase Dashboard (SQL Editor). It creates `contact_messages` with RLS:
visitors can only INSERT, your signed-in admin account can read/update/delete.

If you use a staging table prefix (`staging_`), create the same table with
that prefix. Then apply `20260825000001_add_phone_to_contact_messages.sql`
for the optional phone column.

## 2. Deploy the email edge function

```bash
supabase functions deploy send-contact-email
```

Set your secrets:

```bash
supabase secrets set \
  RESEND_API_KEY=re_xxxxxxxxxxxx \
  CONTACT_NOTIFICATION_EMAIL=you@example.com \
  "RESEND_FROM_EMAIL=Portfolio <portfolio@yourdomain.com>"
```

- `RESEND_API_KEY` — free API key from https://resend.com/api-keys
  (free tier: 3,000 emails/month).
- `CONTACT_NOTIFICATION_EMAIL` — the inbox that receives notifications.
- `RESEND_FROM_EMAIL` — optional while testing; without a verified domain it
  defaults to Resend's sandbox sender (`onboarding@resend.dev`), which can
  only deliver to your own Resend account's email. Add and verify a domain in
  Resend for production sending to any address.
- `WEBHOOK_SECRET` — optional shared secret (recommended); if set, add an
  HTTP header `x-webhook-secret: <same value>` on the webhook in step 3.

## 3. Trigger the function on new messages

Supabase Dashboard → **Database → Webhooks → Create webhook**:

- Table: `contact_messages`, Events: **Insert**
- Method: POST, URL: your deployed function URL
  `https://<project-ref>.supabase.co/functions/v1/send-contact-email`
- (If using `WEBHOOK_SECRET`) add header `x-webhook-secret`

That's it — every submitted form row triggers one notification email.
The message is stored first, so even if Resend is down nothing is lost;
the admin inbox always shows every message.
