-- Pickleball Tournament Portal v10
-- Public homepage registration counts
-- Run this once in Supabase SQL Editor.
-- Safe: this only creates/replaces one RPC function. It does not delete any data.

create or replace function public.get_public_tournament_stats()
returns table (
  tournament_id uuid,
  registration_count bigint,
  approved_count bigint,
  paid_count bigint
)
language sql
security definer
set search_path = public
as $$
  select
    r.tournament_id,
    count(*)::bigint as registration_count,
    count(*) filter (where r.status = 'Approved')::bigint as approved_count,
    count(*) filter (where r.payment_status = 'Paid')::bigint as paid_count
  from public.registrations r
  group by r.tournament_id;
$$;

grant execute on function public.get_public_tournament_stats() to anon, authenticated;

notify pgrst, 'reload schema';
