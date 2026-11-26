# PrEP Challenge 2026 — PKD Jasin

A Next.js / React application with a shared Supabase Postgres state store and server-controlled scoring. All browsers poll the server approximately once per second; this is near-real-time, not WebSocket push. The server rejects late and duplicate answers; a version check prevents concurrent updates overwriting one another. Session tokens are stored locally for reconnecting on the same browser.

## Deploy (Vercel + Supabase)
1. Create a Supabase project. In SQL Editor run `schema.sql` once. The games table is server-only (RLS enabled, no public policies).
2. Copy `.env.example` to `.env.local` for local use. Set SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY and a long random HOST_PASSWORD. Never expose the service role key or commit `.env.local`.
3. Install Node.js 22 and run `npm install`, then `npm run dev`. Open http://localhost:3000. For phones on the same Wi-Fi, run `npm run dev -- --hostname 0.0.0.0` and use the computer's LAN IP instead of localhost.
4. For a public HTTPS URL, upload the project to a private GitHub repository, import into Vercel, add the three environment variables to the project, then deploy. The resulting Vercel URL is the shareable quiz link. Open it on the host computer, create a session and display the QR. Participants scan it or enter the PIN on the same URL.
5. Run a rehearsal: create a session, add 8 demo bots, join on two phones using distinct names, start, test the full 20 questions, refresh a phone mid-game, verify ranks and export CSV. Use a NEW session for the real event, without bots. Test the venue Wi-Fi and projector. Run a separate 100-client load test before relying on that capacity; the current polling and optimistic database writes may require tuning or a larger database plan. No cloud account or public deployment was available during authoring.

## Host flow
Enter host password, create room, show QR and PIN, start manually. The server sets a 20-second deadline; reveal occurs on the next poll after expiry. Host advances manually, with leaderboard breaks at 5, 10, 15. Final podium reveals third, second, first. Export the final CSV. Rankings use correct count, score, then cumulative correct response time; exact ties use nickname order. Response time includes network latency. Counts on reveal use answered participants as denominator; the report uses all joined participants, including nonresponses.

## Clinical content
20 original Malay questions, 8 easy, 8 intermediate, 4 challenging. Primary reference: Ministry of Health Malaysia, National Guidelines on HIV PrEP Program Implementation 2025 (April 2025). Each question has a page reference and official link. Have the local HIV/STI officer review the wording before an official event. The score is a knowledge snapshot, not a pre/post outcome.

## Operational notes
No participant account or health data is required. Ask staff to use non-identifying nicknames. The database persists game data until the administrator deletes it; after exporting results, delete the specific room in Supabase. Do not publish identifiable staff scores. This project does not include production rate limiting, automated retention, WebSocket streaming, a verified 100-person load test, or background music/confetti. It includes optional short transition tones and staged podium animations. Dependencies and deployed integration must be tested in the target environment. Server-side keys must remain private. No deployed URL is claimed.
