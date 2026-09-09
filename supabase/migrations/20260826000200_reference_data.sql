-- Basir Accounting: first reference-data slice for Web repositories.
-- Review artifact only. Depends on 20260826000100_organization_governance.sql.

begin;

create table public.accounts (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  id text not null check (char_length(trim(id)) between 1 and 160),
  code text not null check (char_length(trim(code)) between 1 and 64),
  name_ar text not null check (char_length(trim(name_ar)) between 1 and 250),
  name_en text not null check (char_length(trim(name_en)) between 1 and 250),
  account_type text not null,
  account_nature text not null,
  balance numeric(20,6) not null default 0,
  sub_type text not null default '',
  ifrs18_category text,
  is_parent boolean not null default false,
  parent_id text,
  is_active boolean not null default true,
  is_system boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (organization_id, id),
  unique (organization_id, code),
  constraint accounts_parent_in_same_organization
    foreign key (organization_id, parent_id)
    references public.accounts (organization_id, id)
    deferrable initially immediate,
  constraint accounts_parent_not_self
    check (parent_id is null or parent_id <> id)
);

create table public.financial_years (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  id text not null check (char_length(trim(id)) between 1 and 160),
  name text not null check (char_length(trim(name)) between 1 and 250),
  start_date date not null,
  end_date date not null,
  is_closed boolean not null default false,
  closed_at timestamptz,
  closed_by uuid references auth.users(id) on delete set null,
  locked_period_ids jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (organization_id, id),
  unique (organization_id, name),
  constraint financial_year_date_range check (start_date <= end_date),
  constraint financial_year_closed_metadata check (
    (is_closed = false and closed_at is null)
    or (is_closed = true and closed_at is not null)
  ),
  constraint financial_year_locked_periods_array check (jsonb_typeof(locked_period_ids) = 'array')
);

create table public.customers (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  id text not null check (char_length(trim(id)) between 1 and 160),
  name_ar text not null check (char_length(trim(name_ar)) between 1 and 250),
  name_en text not null check (char_length(trim(name_en)) between 1 and 250),
  tax_number text,
  phone text,
  email text,
  address text,
  notes text,
  credit_limit numeric(20,6) not null default 0 check (credit_limit >= 0),
  balance numeric(20,6) not null default 0,
  receivable_account_id text,
  created_by uuid references auth.users(id) on delete set null,
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (organization_id, id),
  constraint customer_receivable_account_in_same_organization
    foreign key (organization_id, receivable_account_id)
    references public.accounts (organization_id, id)
    deferrable initially immediate
);

create table public.vendors (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  id text not null check (char_length(trim(id)) between 1 and 160),
  name_ar text not null check (char_length(trim(name_ar)) between 1 and 250),
  name_en text not null check (char_length(trim(name_en)) between 1 and 250),
  phone text,
  email text,
  address text,
  notes text,
  payable_account_id text,
  vat_number text,
  registration_number text,
  balance numeric(20,6) not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  primary key (organization_id, id),
  constraint vendor_payable_account_in_same_organization
    foreign key (organization_id, payable_account_id)
    references public.accounts (organization_id, id)
    deferrable initially immediate
);

create index accounts_active_by_organization_idx
  on public.accounts (organization_id, is_active, code)
  where deleted_at is null;
create index accounts_parent_idx
  on public.accounts (organization_id, parent_id)
  where parent_id is not null and deleted_at is null;
create index financial_years_active_range_idx
  on public.financial_years (organization_id, start_date, end_date)
  where deleted_at is null;
create index customers_name_idx
  on public.customers (organization_id, name_ar, name_en)
  where deleted_at is null;
create index customers_tax_number_idx
  on public.customers (organization_id, tax_number)
  where tax_number is not null and deleted_at is null;
create index vendors_name_idx
  on public.vendors (organization_id, name_ar, name_en)
  where deleted_at is null;

create trigger accounts_set_updated_at
before update on public.accounts
for each row execute function app_private.set_updated_at();
create trigger financial_years_set_updated_at
before update on public.financial_years
for each row execute function app_private.set_updated_at();
create trigger customers_set_updated_at
before update on public.customers
for each row execute function app_private.set_updated_at();
create trigger vendors_set_updated_at
before update on public.vendors
for each row execute function app_private.set_updated_at();

alter table public.accounts enable row level security;
alter table public.financial_years enable row level security;
alter table public.customers enable row level security;
alter table public.vendors enable row level security;

create policy accounts_select_for_members
on public.accounts for select to authenticated
using (public.is_organization_member(organization_id));
create policy accounts_manage_for_accounting_roles
on public.accounts for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]));

create policy financial_years_select_for_members
on public.financial_years for select to authenticated
using (public.is_organization_member(organization_id));
create policy financial_years_manage_for_accounting_roles
on public.financial_years for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant']::public.organization_role[]));

create policy customers_select_for_members
on public.customers for select to authenticated
using (public.is_organization_member(organization_id));
create policy customers_manage_for_operational_roles
on public.customers for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant', 'operator']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant', 'operator']::public.organization_role[]));

create policy vendors_select_for_members
on public.vendors for select to authenticated
using (public.is_organization_member(organization_id));
create policy vendors_manage_for_operational_roles
on public.vendors for all to authenticated
using (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant', 'operator']::public.organization_role[]))
with check (public.has_organization_role(organization_id, array['owner', 'admin', 'accountant', 'operator']::public.organization_role[]));

revoke all on public.accounts, public.financial_years, public.customers, public.vendors from anon;
grant select, insert, update, delete on public.accounts, public.financial_years, public.customers, public.vendors to authenticated;

comment on table public.accounts is 'Tenant-scoped chart of accounts; text IDs are preserved per organization.';
comment on table public.financial_years is 'Tenant-scoped fiscal periods; ledger posting rules arrive in a later migration.';
comment on table public.customers is 'Tenant-scoped customer master data with numeric monetary values.';
comment on table public.vendors is 'Tenant-scoped vendor master data with numeric monetary values.';

commit;
