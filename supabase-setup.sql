-- شغّل هذا في Supabase > محرر SQL مرة واحدة (يمكن إعادة تشغيله بأمان)
create table if not exists public.progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.progress enable row level security;

grant select, insert, update on public.progress to authenticated;
revoke all on public.progress from anon;

drop policy if exists "own progress select" on public.progress;
drop policy if exists "own progress insert" on public.progress;
drop policy if exists "own progress update" on public.progress;

create policy "own progress select" on public.progress
  for select to authenticated using (auth.uid() = user_id);
create policy "own progress insert" on public.progress
  for insert to authenticated with check (auth.uid() = user_id);
create policy "own progress update" on public.progress
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
