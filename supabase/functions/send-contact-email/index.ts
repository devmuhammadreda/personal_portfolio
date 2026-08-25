// Sends a notification email via Resend whenever a new contact message
// is inserted into `contact_messages`. Triggered by a Supabase Database
// Webhook (Dashboard → Database → Webhooks → insert on contact_messages).
//
// Required secrets — set with:
//   supabase secrets set RESEND_API_KEY=... CONTACT_NOTIFICATION_EMAIL=you@example.com
//   supabase secrets set RESEND_FROM_EMAIL="Portfolio <portfolio@yourdomain.com>"
//
//   RESEND_API_KEY             API key from https://resend.com/api-keys
//   CONTACT_NOTIFICATION_EMAIL Your inbox that receives the notifications
//   RESEND_FROM_EMAIL          Verified sender identity (defaults to the
//                              Resend sandbox sender for testing)
// Optional:
//   WEBHOOK_SECRET             Shared secret; must be sent by the webhook
//                              in the `x-webhook-secret` header.

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const NOTIFICATION_EMAIL = Deno.env.get("CONTACT_NOTIFICATION_EMAIL");
const FROM_EMAIL =
  Deno.env.get("RESEND_FROM_EMAIL") ?? "Portfolio <onboarding@resend.dev>";
const WEBHOOK_SECRET = Deno.env.get("WEBHOOK_SECRET");

interface DatabaseWebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: {
    id: string;
    name: string;
    email: string;
    phone?: string | null;
    message: string;
  };
}

const escapeHtml = (value: string): string =>
  value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");

const json = (body: unknown, status = 200): Response =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method !== "POST") return json({ error: "method not allowed" }, 405);
  if (!RESEND_API_KEY || !NOTIFICATION_EMAIL) {
    console.error("Missing RESEND_API_KEY or CONTACT_NOTIFICATION_EMAIL");
    return json({ error: "function not configured" }, 500);
  }
  if (WEBHOOK_SECRET && req.headers.get("x-webhook-secret") !== WEBHOOK_SECRET) {
    return json({ error: "forbidden" }, 403);
  }

  let payload: DatabaseWebhookPayload;
  try {
    payload = await req.json();
  } catch {
    return json({ error: "invalid payload" }, 400);
  }

  // Only new inserts notify — updates (mark-as-read) and deletes are silent.
  if (payload.type !== "INSERT") {
    return json({ skipped: `ignored event type ${payload.type}` });
  }

  const { name, email, message, phone } = payload.record;
  const safeName = escapeHtml(name || "Someone");
  const safeEmail = escapeHtml(email || "");
  const safePhone = phone ? escapeHtml(phone) : "";
  const safeMessage = escapeHtml(message || "").replace(/\n/g, "<br>");

  const resendResponse = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: FROM_EMAIL,
      to: [NOTIFICATION_EMAIL],
      reply_to: email,
      subject: `New portfolio message from ${name}`,
      html: `
        <h2>New contact message</h2>
        <p><strong>From:</strong> ${safeName} (<a href="mailto:${safeEmail}">${safeEmail}</a>)</p>
        ${phone ? `<p><strong>Phone:</strong> <a href="tel:${safePhone}">${safePhone}</a></p>` : ""}
        <hr />
        <p>${safeMessage}</p>
      `,
    }),
  });

  if (!resendResponse.ok) {
    const detail = await resendResponse.text();
    console.error(`Resend failed (${resendResponse.status}): ${detail}`);
    return json({ error: "email delivery failed" }, 502);
  }

  return json({ delivered: true });
});
