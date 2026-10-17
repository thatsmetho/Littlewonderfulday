# Parent sign-in and cloud settings setup

The app now has an optional Supabase client integration. Until you complete the setup below, it stays in device-only mode; the local Parent PIN and localStorage routines continue to work.

## 1. Create a Supabase project
Create a project at https://supabase.com/dashboard. In **SQL Editor**, run the contents of [schema.sql](./schema.sql). The table stores one JSON settings document per authenticated parent. Row Level Security restricts each row to its owner.

## 2. Add the public client configuration
In Supabase **Project Settings → API** (or the project's Connect dialog), copy the **Project URL** and the **publishable key** (older projects may call it the anon key). In `index.html`, set:
- `SUPABASE_URL` to the Project URL
- `SUPABASE_ANON_KEY` to the publishable/anon key

These are browser-client values. **Never** use the service-role key in the HTML or GitHub repository. The repository is public, so treat all committed code as public.

## 3. Configure sign-in providers
In **Authentication → Sign In / Providers**, enable and configure Google, Azure (Microsoft), and Apple. Each provider needs its own developer-console credentials and the exact callback URL shown by Supabase. Add the deployed GitHub Pages URL to Supabase's allowed redirect URLs.

Yahoo is requested through Supabase's custom OIDC provider mechanism. Configure a custom provider with the slug `yahoo` and the Yahoo-issued client details in Supabase first. Yahoo is not guaranteed to work merely by clicking the button; it depends on provider availability, app registration and callback configuration.

## 4. Test
Deploy the commit, open the app, hard-refresh (Ctrl+F5), and open Parent area. Try one configured provider. After sign-in, the app can save to cloud manually, restore an existing cloud copy, and automatically sync subsequent settings changes. Use **Save to cloud** once for an initial backup. The local Parent PIN is deliberately excluded from cloud payloads and remains device-specific.

## Important limitations
- The app is a static GitHub Pages site. OAuth and cloud saving require the Supabase project and provider setup above; commits alone cannot create those third-party credentials.
- Cloud payloads include family routines and child profile settings, which may contain sensitive information. Only enable cloud sync if you want that data stored in your Supabase project. Review the project region and access controls before using it with real family data.
- Cloud sync code is committed, but has not been browser-tested against a configured Supabase project. Until configuration and provider setup are complete, use device-only mode.
- Browser-local settings are not automatically merged with an existing cloud copy. Choose **Restore cloud settings** only when you intend to replace this device's current settings with the saved cloud version.
