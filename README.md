# Réservation RM Bingerville

Lien de réservation de la Résidence Meublée Bingerville : le client choisit son logement, son quartier,
sa formule et ses dates, paie avec Wave ou Orange Money, puis télécharge son reçu.

Adresse prévue : https://reservation-rmbingerville.vercel.app

## Contenu

```
index.html   La page de réservation (tout est dans ce fichier : style, textes, tarifs, liens de paiement)
images/      Logo, logos Wave et Orange Money, mascotte, icône de l'onglet
```

## Où changer quoi (dans index.html)

- **Tarifs** : liste `FORFAITS`
- **Quartiers** : liste `QUARTIERS`
- **Numéro WhatsApp** : `WHATSAPP` (format international sans + ni espaces)
- **Liens de paiement** : liens `payWave` et `payOM`

## Étapes du projet

1. Mise en ligne sur Vercel
2. Base Supabase : enregistrement des réservations
3. Espace privé : calendrier, statistiques, disponibilités
4. Application mobile avec notifications
