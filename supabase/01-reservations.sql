-- ============================================================
--  Résidence Meublée Bingerville : tableau des réservations
--  À coller dans Supabase > SQL Editor, puis « Run ».
-- ============================================================

create table public.reservations (
  id                 uuid primary key default gen_random_uuid(),
  reference          text not null check (reference ~ '^RMB-[0-9]{6}-[A-Z0-9]{4}$'),
  nom                text not null check (char_length(nom) between 2 and 100),
  whatsapp           text not null check (char_length(whatsapp) between 8 and 30),
  logement           text not null check (logement in ('Studio', 'Deux pièces')),
  quartier           text not null check (char_length(quartier) between 2 and 60),
  formule            text not null check (formule in ('2 heures', 'Demi-journée', '24 heures', 'Nuitée')),
  quantite           int  not null default 1 check (quantite between 1 and 30),
  arrivee            timestamptz not null,
  depart             timestamptz not null,
  personnes          int  not null check (personnes between 1 and 10),
  montant            int  not null check (montant > 0),
  moyen_paiement     text not null check (moyen_paiement in ('Wave', 'Orange Money')),
  numero_transaction text not null check (char_length(numero_transaction) between 4 and 60),
  statut             text not null default 'En attente de vérification'
                     check (statut in ('En attente de vérification', 'Confirmée', 'Refusée')),
  cree_le            timestamptz not null default now(),
  constraint reservations_reference_unique unique (reference),
  constraint reservations_depart_apres_arrivee check (depart > arrivee)
);

-- Un numéro de transaction ne peut servir qu'une seule fois
-- (sans tenir compte des majuscules ni des espaces).
create unique index reservations_transaction_unique
  on public.reservations (upper(regexp_replace(numero_transaction, '\s', '', 'g')));

create index reservations_arrivee_idx on public.reservations (arrivee);

-- Sécurité : la page publique peut seulement AJOUTER une réservation.
-- Elle ne peut ni lire, ni modifier, ni supprimer, ni choisir le statut.
alter table public.reservations enable row level security;
revoke all on public.reservations from anon, authenticated;
grant insert (reference, nom, whatsapp, logement, quartier, formule, quantite,
              arrivee, depart, personnes, montant, moyen_paiement, numero_transaction)
  on public.reservations to anon;

create policy "La page publique ajoute seulement des réservations en attente"
  on public.reservations for insert to anon
  with check (statut = 'En attente de vérification');
