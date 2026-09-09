-- Basir Accounting RLS test plan.
-- Requires a local Supabase/Postgres test runner and pgTAP.
-- This file is not executed against the remote project.

begin;

select plan(8);

-- The test harness must provision two authenticated users and two organizations
-- before the following assertions run. The concrete JWT setup belongs in the
-- local test runner, not in migrations.
select has_table('public', 'organizations', 'organizations table exists');
select has_table('public', 'organization_members', 'membership table exists');
select has_table('public', 'profiles', 'profiles table exists');
select has_table('public', 'business_settings', 'business settings table exists');
select has_column('public', 'organizations', 'id', 'organization has stable id');
select has_column('public', 'organization_members', 'role', 'membership has explicit role');
select has_column('public', 'business_settings', 'currency_code', 'settings preserve currency');
select has_function('public', 'create_organization', ARRAY['text', 'text', 'text', 'text'], 'organization bootstrap RPC exists');

select * from finish();
rollback;
