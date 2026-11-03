# Atelier 4 — Qualifier les traces et préparer une reprise de confiance

**Situation :** la panne de Novalys pourrait être liée à une attaque. Malik et Inès vous confient les journaux d’événements de la matinée pour établir ce qui s’est réellement passé avant de décider comment rouvrir le portail.

**Objectif :** séparer les faits des hypothèses, proposer des mesures de protection immédiates et fixer les conditions d’une reprise sûre.

**Livrable :** un fichier texte `A4-investigation-reprise.txt`.

**Matériel :** un éditeur de texte. Aucun outil de sécurité, compte ni accès Internet. Les événements fictifs sont dans [evenements-soc.csv](Donnees/evenements-soc.csv) : la page Git l’affiche sous forme de tableau, et un éditeur de texte l’ouvre aussi. Si vous préférez filtrer, vous pouvez l’ouvrir dans un tableur ou, sous Windows, dans PowerShell avec `Import-Csv .\evenements-soc.csv | Format-Table`. Votre fichier `A2-crise-runbook.txt` peut vous servir.

**Heures :** les heures du CSV sont en UTC (temps universel). Pour simplifier, toutes les heures du cas Novalys, y compris celles des ateliers 1 et 2, sont exprimées dans cette même référence. Dans une enquête réelle, convertissez d’abord toutes les sources dans un même fuseau : en France en octobre, 10 h 00 heure locale correspond à 08:00 UTC.

**Contrôle :** vous travaillez seul. En cas de blocage, communiquez au formateur la référence de la tâche, par exemple **A4-1.1.2**.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple dans le CSV |
|---|---|---|
| Colonnes du CSV | `time_utc` heure, `source` système qui a écrit la trace, `actor` compte qui agit, `action`, `target` cible, `result` résultat, `context` détails | `prest-01` se connecte au `vpn` |
| `SUCCESS` / `FAIL` / `DENIED` / `UNKNOWN` | Réussi / échoué / refusé par une règle / résultat non enregistré | La suppression de sauvegarde est `DENIED` |
| `not_recorded` | L’information n’a pas été enregistrée : on ne sait pas | `mfa=not_recorded` : on ignore si la MFA a été utilisée |
| Compte de service | Compte utilisé par un programme, pas par une personne | `svc-export` |
| Rôle privilégié | Droits élevés permettant des actions sensibles | Rôle accordé à `svc-export` à 09:14 |
| Exfiltration | Sortie de données vers l’extérieur sans autorisation | Envoi de la liste clients à un tiers |
| Mesure conservatoire | Action immédiate pour limiter les dégâts sans détruire les preuves | Suspendre un compte suspect |
| Ticket de changement | Autorisation enregistrée d’une intervention prévue | `CHG-042` |

**Question directrice :** Comment détecter l’incident et décider d’une reprise fiable ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A4 est une pièce du dossier de décision.

## 1. Reconstituer les faits

### 1.1. Lire le journal et distinguer chronologie, résultat et incertitude

- **A4-1.1.1** — Créez `A4-investigation-reprise.txt` avec cette trame, puis enregistrez-le :

```text
Chronologie utile et incertitudes :
Qualification et preuves manquantes :
Mesures conservatoires :
Reprise : point retenu, écart et conditions
Plan de correction et vérification :
```

- **A4-1.1.2** — Ouvrez le CSV. Relevez les sept événements entre 09:10 et 10:00 sous la forme `heure | compte | action | résultat`. Pour chacun, notez en quelques mots le lien avec l’événement précédent. Comparez ensuite avec la maintenance de 08:30 : qu’a-t-elle que l’attribution de rôle de 09:14 n’a pas ?
- **A4-1.1.3** — Écrivez deux faits établis par le journal et deux hypothèses qu’il ne permet pas de confirmer. Expliquez pourquoi l’export de 09:18 et la connexion sortante de 09:22 ne prouvent pas qu’un tiers a reçu les données.

**Résultat attendu :** une chronologie exacte qui n’accuse aucune personne sans preuve. Le compte `prest-01` sert de fil conducteur pour l’analyse, mais il ne dit pas qui était devant l’écran : le compte peut avoir été volé.

## 2. Prioriser et préserver

### 2.1. Proposer trois mesures conservatoires avec leurs limites

- **A4-2.1.1** — Dans « Qualification et preuves manquantes », indiquez la priorité que vous donnez à l’alerte d’Inès (tentative de suppression de sauvegarde de 09:20) et pourquoi, en vous appuyant sur les événements qui l’entourent. Dans « Mesures conservatoires », proposez trois mesures :
  - une sur les comptes et accès suspects ;
  - une sur les ressources suspectes (`svc-export`, `app-01`) ;
  - une sur les sauvegardes et les journaux.
  - Pour chacune, indiquez son objectif et une limite ou une coordination nécessaire.
- **A4-2.1.2** — Listez trois preuves à rechercher en plus du CSV : la trace d’un éventuel transfert, les droits réellement obtenus et l’état des sauvegardes. Indiquez les deux questions auxquelles le CSV seul ne permet pas de répondre et qui doit être prévenu pour les données personnelles exportées. Enregistrez.

**Résultat attendu :** des mesures utiles qui ne détruisent pas de preuves et n’affirment rien au-delà des faits. Les mesures se coordonnent avec l’exploitation et l’enquête : effacer et réinstaller tout de suite le serveur suspect ferait disparaître les traces nécessaires. Ce fichier d’exercice n’autorise aucune action réelle.

## 3. Préparer le choix du point et les contrôles de retour

### 3.1. Comparer la réplique de 09:55 et la sauvegarde isolée de 09:30 au RPO de 15 minutes

**Données :** panne à 10:00. La réplique de 09:55 n’a pas été vérifiée. La sauvegarde isolée de 09:30 a été examinée par l’équipe d’enquête et retenue pour l’exercice. RTO de bout en bout : 4 h. La reprise est estimée à 180 min, mais aucun test complet ne l’a confirmé dans la situation actuelle.

- **A4-3.1.1** — Dans « Reprise », choisissez le point de restauration, calculez la perte de données et l’écart au RPO. Précisez si les 180 min sont une estimation ou une mesure. Indiquez qui doit accepter la perte de données pour le métier.
- **A4-3.1.2** — Écrivez quatre conditions à remplir avant d’ouvrir le portail aux clients :
  - une administration de confiance (comptes et postes d’administration sûrs) ;
  - la cause et les accès suspects traités ;
  - des données vérifiées et cohérentes ;
  - une recette métier réussie et une surveillance active ;
  - décrivez au moins un test qui doit être autorisé et un test qui doit être refusé.

**Résultat attendu :** une ouverture conditionnée à des preuves, avec un écart au RPO assumé. Le point retenu pour l’exercice n’est pas une garantie universelle : dans une attaque réelle, il faut vérifier à chaque fois que la sauvegarde ne contient pas les modifications de l’attaquant.

### 3.2. Clore une correction par une vérification ciblée

- **A4-3.2.1** — Dans « Plan de correction et vérification », choisissez une faiblesse constatée ou supposée. Nommez le contrôle qui permettra de confirmer qu’elle existe vraiment, puis proposez une correction, un propriétaire et la preuve qui permettra de la déclarer corrigée.
- **A4-3.2.2** — Relisez tout votre fichier : remplacez toute affirmation d’exfiltration certaine ou d’auteur identifié par le niveau de certitude réel (« possible », « non établi », « à confirmer par… »). Enregistrez.

**Résultat attendu :** un plan de correction qui distingue ce qui est constaté de ce qui est supposé. Les preuves orientent la correction et limitent les conclusions : on corrige un droit trop large constaté, on vérifie un vol de compte supposé.

## Contrôle final

Votre fichier contient une chronologie de sept événements, deux faits et deux hypothèses, trois mesures, trois preuves à rechercher, le calcul de l’écart au RPO et quatre conditions d’ouverture. Si vous avez écrit que le prestataire est l’auteur certain, reprenez **A4-1.1.3** ; si votre chronologie ne contient pas la connexion sortante de 09:22, reprenez **A4-1.1.2**. Aucun outil d’attaque ni action sur un système réel n’est demandé.

Bonus facultatif : décrivez une règle de détection automatique « attribution d’un rôle privilégié, puis export et tentative de suppression de sauvegarde », avec la fenêtre de temps retenue, les données nécessaires et une cause possible de fausse alerte.
