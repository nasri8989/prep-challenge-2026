create table if not exists public.games(pin text primary key, state jsonb not null, version bigint not null default 0);
alter table public.games enable row level security;
revoke all on public.games from anon, authenticated;
