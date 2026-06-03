-- ============================================================
--  AI Agent Marketplace — Supabase Schema
--  Run this in your Supabase project: SQL Editor → New Query
-- ============================================================

-- ── USE CASES ───────────────────────────────────────────────
create table if not exists use_cases (
  id          text primary key,               -- e.g. 'tc-gen'
  name        text not null,
  short_desc  text not null,                  -- card description
  tagline     text not null,                  -- drawer full description
  status      text not null default 'planned',-- active | planned | exploring | pipeline
  color       text not null default '#2E308E',
  group_id    text not null,                  -- p1 | p2 | p3 | dsr | mom | sprint | defect
  output_desc text not null,                  -- "What this produces"
  agent_ids   text[] not null default '{}',   -- ordered array of agent IDs
  shared_ids  text[] not null default '{}',   -- agent IDs that are shared
  sort_order  integer not null default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── AGENTS ──────────────────────────────────────────────────
create table if not exists agents (
  id          text primary key,               -- e.g. 'jira-connector'
  name        text not null,
  short_desc  text not null,
  tagline     text not null,
  color       text not null default '#2E308E',
  group_id    text not null,                  -- core | p1 | p2 | p3 | other
  inputs      text[] not null default '{}',
  outputs     text[] not null default '{}',
  confirmed   boolean not null default false,
  sort_order  integer not null default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── AGENT STEPS ─────────────────────────────────────────────
create table if not exists agent_steps (
  id          bigint generated always as identity primary key,
  agent_id    text not null references agents(id) on delete cascade,
  step_number text not null,                  -- '1', '2', '★' etc.
  step_name   text not null,
  step_desc   text not null,
  is_special  boolean not null default false, -- true for ★ steps
  sort_order  integer not null default 0
);

-- ── ROW LEVEL SECURITY ──────────────────────────────────────
-- Allow public read (marketplace frontend)
alter table use_cases  enable row level security;
alter table agents     enable row level security;
alter table agent_steps enable row level security;

create policy "public read use_cases"   on use_cases   for select using (true);
create policy "public read agents"      on agents      for select using (true);
create policy "public read agent_steps" on agent_steps for select using (true);

-- Only authenticated users (your admin panel) can write
create policy "auth write use_cases"   on use_cases   for all using (auth.role() = 'authenticated');
create policy "auth write agents"      on agents      for all using (auth.role() = 'authenticated');
create policy "auth write agent_steps" on agent_steps for all using (auth.role() = 'authenticated');

-- ── UPDATED_AT TRIGGER ──────────────────────────────────────
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger use_cases_updated_at  before update on use_cases  for each row execute function set_updated_at();
create trigger agents_updated_at     before update on agents     for each row execute function set_updated_at();

-- ============================================================
--  Done. Now go to Authentication → Users in Supabase and
--  create your admin user, then run seed.sql to load data.
-- ============================================================
