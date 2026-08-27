-- Basir Accounting: organizational governance and tenant isolation.
-- Local review artifact only. Do not apply this migration without explicit approval.
--
-- Design principles:
--   1. Every accounting row is scoped by organization_id.
--   2. Browser access is protected by RLS, never by client-side filtering.
--   3. Initial organization membership is created atomically through one RPC.
--   4. Timestamps are maintained in PostgreSQL, not trusted from the client.

begin;

create extension if not exists pgcrypto with schema extensions;

create schema if not exists app_private;
revoke all on schema app_private from public;

create type public.organization_role as enum (
  'owner',
  'admin',
  'accountant',
  'auditor',
  'operator',
  'viewer'
);

create table public.organizations (
  id uuid primary key default extensions.gen_random_uuid(),
  legal_name text not null check (char_length(trim(legal_name)) between 2 and 250),
  display_name text not null check (char_length(trim(display_name)) between 2 and 250),
  country_code text not null default 'SA' check (country_code ~ '^[A-Z]{2}$'),
  currency_code text not null default 'SAR' check (currency_code ~ '^[A-Z]{3}$'),
  timezone text not null default 'Asia/Riyadh',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.organization_members (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.organization_role not null default 'viewer',
  joined_at timestamptz not null default now(),
  primary key (organization_id, user_id)
);

create or replace function app_private.prevent_last_organization_owner_removal()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if old.role = 'owner' and (
    tg_op = 'DELETE'
    or (tg_op = 'UPDATE' and new.role <> 'owner')
  ) then
    if not exists (
      select 1
      from public.organization_members membership
      where membership.organization_id = old.organization_id
        and membership.user_id <> old.user_id
        and membership.role = 'owner'
    ) then
      raise exception 'An organization must retain at least one owner';
    end if;
  end if;
  return coalesce(new, old);
end;
$$;

create trigger organization_members_retain_owner
before delete or update of role on public.organization_members
for each row execute function app_private.prevent_last_organization_owner_removal();

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  default_organization_id uuid references public.organizations(id) on delete set null,
  display_name text,
  avatar_url text,
  phone_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.business_settings (
  organization_id uuid primary key references public.organizations(id) on delete cascade,
  company_name text not null check (char_length(trim(company_name)) between 2 and 250),
  tax_number text,
  address text,
  logo_url text,
  default_tax_rate numeric(7,6) not null default 0.150000 check (default_tax_rate between 0 and 1),
  currency_code text not null default 'SAR' check (currency_code ~ '^[A-Z]{3}$'),
  currency_symbol text not null default 'ر.س',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function app_private.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger organizations_set_updated_at
before update on public.organizations
for each row execute function app_private.set_updated_at();

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function app_private.set_updated_at();

create trigger business_settings_set_updated_at
before update on public.business_settings
for each row execute function app_private.set_updated_at();

create or replace function public.is_organization_member(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.organization_members membership
    where membership.organization_id = target_organization_id
      and membership.user_id = (select auth.uid())
  );
$$;

create or replace function public.has_organization_role(
  target_organization_id uuid,
  allowed_roles public.organization_role[]
)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.organization_members membership
    where membership.organization_id = target_organization_id
      and membership.user_id = (select auth.uid())
      and membership.role = any(allowed_roles)
  );
$$;

-- Creates a tenant and makes the authenticated caller its owner atomically.
-- This is the only browser-accessible path for creating first membership.
create or replace function public.create_organization(
  legal_name_input text,
  display_name_input text,
  country_code_input text default 'SA',
  currency_code_input text default 'SAR'
)
returns public.organizations
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  created_organization public.organizations;
  caller_id uuid := (select auth.uid());
begin
  if caller_id is null then
    raise exception 'Authentication is required to create an organization';
  end if;

  insert into public.organizations (
    legal_name,
    display_name,
    country_code,
    currency_code
  )
  values (
    legal_name_input,
    display_name_input,
    upper(country_code_input),
    upper(currency_code_input)
  )
  returning * into created_organization;

  insert into public.organization_members (organization_id, user_id, role)
  values (created_organization.id, caller_id, 'owner');

  insert into public.profiles (id, default_organization_id)
  values (caller_id, created_organization.id)
  on conflict (id) do update
    set default_organization_id = excluded.default_organization_id;

  insert into public.business_settings (
    organization_id,
    company_name,
    currency_code
  )
  values (
    created_organization.id,
    created_organization.legal_name,
    created_organization.currency_code
  );

  return created_organization;
end;
$$;

revoke all on function public.is_organization_member(uuid) from public;
revoke all on function public.has_organization_role(uuid, public.organization_role[]) from public;
grant execute on function public.is_organization_member(uuid) to authenticated;
grant execute on function public.has_organization_role(uuid, public.organization_role[]) to authenticated;
grant execute on function public.create_organization(text, text, text, text) to authenticated;

alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.profiles enable row level security;
alter table public.business_settings enable row level security;

create policy organizations_select_for_members
on public.organizations for select to authenticated
using (public.is_organization_member(id));

create policy organization_members_select_for_members
on public.organization_members for select to authenticated
using (public.is_organization_member(organization_id));

create policy organization_members_manage_for_owners
on public.organization_members for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin']::public.organization_role[]));

create policy profiles_select_own
on public.profiles for select to authenticated
using ((select auth.uid()) = id);

create policy profiles_update_own
on public.profiles for update to authenticated
using ((select auth.uid()) = id)
with check (
  (select auth.uid()) = id
  and (
    default_organization_id is null
    or public.is_organization_member(default_organization_id)
  )
);

create policy business_settings_select_for_members
on public.business_settings for select to authenticated
using (public.is_organization_member(organization_id));

create policy business_settings_manage_for_admins
on public.business_settings for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]));

revoke all on public.organizations, public.organization_members, public.profiles, public.business_settings from anon;
grant select on public.organizations, public.organization_members, public.profiles, public.business_settings to authenticated;
grant insert, update, delete on public.organization_members, public.business_settings to authenticated;
grant update on public.profiles to authenticated;

comment on function public.create_organization(text, text, text, text) is
  'Creates an organization, owner membership, initial profile linkage, and default settings atomically.';

commit;
