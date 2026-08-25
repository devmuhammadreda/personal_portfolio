-- Adds the optional visitor phone number (stored in international
-- format, e.g. +201234567890) to contact messages.
alter table public.contact_messages
  add column if not exists phone text
  check (phone is null or char_length(phone) <= 20);
