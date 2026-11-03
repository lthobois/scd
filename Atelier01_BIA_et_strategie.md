# Atelier 1 — Qualifier les besoins et choisir une reprise

**Situation :** vous conseillez Novalys Distribution, entreprise fictive qui vend en ligne par un portail de commandes. Le portail peut tomber en panne ; la direction veut savoir en combien de temps il doit revenir, quelles données elle accepte de perdre et quelle solution de secours choisir.

**Objectif :** relier les conséquences d’une panne pour le métier aux exigences techniques, puis comparer trois offres de secours.

**Livrable :** un fichier texte `A1-bia-strategie.txt`, réutilisé dans l’atelier 2.

**Matériel :** un ordinateur avec un éditeur de texte (Bloc-notes, TextEdit, VS Code ou équivalent) et une calculatrice. Aucun compte, droit administrateur, accès Internet ni licence n’est nécessaire : toutes les données sont dans cette page.

**Contrôle :** vous travaillez seul. Chaque tâche porte une référence de la forme `A<atelier>-<partie>.<action>.<tâche>` : **A1-2.1.2** signifie atelier 1, partie 2, action 1, tâche 2. En cas de blocage, communiquez seulement cette référence au formateur.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple Novalys |
|---|---|---|
| BIA | Analyse d’impact sur l’activité : ce qui se passe pour le métier quand une activité s’arrête 1 h, 2 h, 6 h… | Après 2 h sans portail, les livraisons du jour sont menacées |
| Mode dégradé | Façon de continuer à travailler moins bien, sans l’outil habituel | Prendre les commandes par téléphone |
| Dépendance | Élément sans lequel un service ne peut pas fonctionner | Sans DNS, les clients ne trouvent plus l’adresse du portail |
| RTO | Délai maximal visé pour que le service soit de nouveau utilisable | 4 h : le portail doit refonctionner au plus tard 4 h après la panne |
| RPO | Quantité maximale de données que l’on accepte de perdre, exprimée en durée | 15 min : on accepte de perdre au plus les commandes des 15 dernières minutes |
| Point de reprise | Instant auquel correspondent les données restaurées | Une sauvegarde de 9 h 30 contient les commandes jusqu’à 9 h 30 |
| Recette | Test final par le métier qui confirme que le service fonctionne vraiment | Un gestionnaire passe une commande test de bout en bout |
| Domaine de panne | Ensemble d’éléments qu’un même incident peut arrêter en même temps | Un incendie du site A arrête tous les serveurs du site A |

Dans tout le cas Novalys, **site A** désigne le site de production actuel et **site B** le futur site de secours. Les lettres des offres de la partie 3 sont indépendantes des noms de sites.

**Question directrice :** Que faut-il reprendre, sous quel délai et avec quelles données ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A1 est une pièce du dossier de décision.

## 1. Qualifier l’activité prioritaire

### 1.1. Créer le fichier texte et relever les impacts utiles à la BIA

**Données :** le portail reçoit en moyenne 120 commandes par heure, d’une valeur moyenne de 80 €. Après deux heures d’arrêt, les livraisons du jour sont menacées ; après six heures, la situation devient intolérable pour l’entreprise. En mode dégradé, le service client peut prendre 25 commandes par heure par téléphone, mais sans pouvoir garantir que les articles sont en stock. La facturation peut attendre le lendemain. Le portail a besoin du service d’identité (connexion des comptes) et du DNS (résolution du nom du portail).

- **A1-1.1.1** — Créez `A1-bia-strategie.txt` dans un dossier local de votre choix. Copiez la trame suivante, puis enregistrez le fichier :

```text
Activité prioritaire et dépendances :
Impacts et mode dégradé :
Objectifs et calculs :
Stratégie retenue et réserve :
Preuves à demander :
```

- **A1-1.1.2** — Complétez les deux premières rubriques :
  - nommez l’activité prioritaire (une activité métier, pas un serveur) et deux dépendances techniques ;
  - indiquez la limite du mode dégradé ;
  - calculez la valeur des commandes reçues en une heure par le portail, la part que le téléphone peut absorber et la part qui reste exposée ;
  - expliquez en une phrase pourquoi cette valeur exposée n’est pas une perte certaine.

Exemple de forme : `Mode dégradé : téléphone, X commandes/h au lieu de Y, limite : …`

**Résultat attendu :** une BIA courte qui sépare l’activité (prendre les commandes), les moyens (portail, identité, DNS) et les conséquences (livraisons, chiffre d’affaires exposé). Une priorité technique (« le serveur de base de données est critique ») ne suffit pas à définir une priorité métier : c’est l’activité qui est prioritaire, les serveurs le deviennent parce qu’elle en dépend.

## 2. Mesurer l’écart aux objectifs

### 2.1. Calculer la perte de données et le délai de retour avec la convention Novalys

**Données :** le métier fixe un RTO de 4 h et un RPO de 15 min. La panne survient à 10 h 00. La sauvegarde la plus récente utilisable date de 9 h 30.

Chez Novalys, le RTO se mesure de l’instant de la panne jusqu’à la fin réussie de la recette : détection et décision sont donc comprises dans le délai. La reprise suit six étapes ; chacune commence quand la précédente est terminée.

| Ordre | Étape | Ce qui se passe | Durée estimée |
|---:|---|---|---:|
| 1 | Détection | On constate que le portail ne répond plus et on alerte | 10 min |
| 2 | Décision | La cellule de crise décide de lancer la reprise | 20 min |
| 3 | Fondations | On remet en service ce dont tout dépend : réseau, identité, DNS | 35 min |
| 4 | Base de données | On restaure la base des commandes à partir de la sauvegarde | 70 min |
| 5 | Application | On redémarre le portail et on le reconnecte à la base | 25 min |
| 6 | Recette | Le métier passe une commande test complète et valide le service | 20 min |

- **A1-2.1.1** — Dans « Objectifs et calculs », écrivez :
  - l’heure minimale que doivent atteindre les données restaurées pour respecter le RPO ;
  - la durée de données réellement perdue avec la sauvegarde de 9 h 30 ;
  - si le RPO est respecté ou non, et de combien il est dépassé le cas échéant.
- **A1-2.1.2** — Calculez la durée totale de reprise, l’heure de retour du service et la marge restante par rapport au RTO. Refaites le calcul en ajoutant 80 min d’attente d’un prestataire avant l’étape 3, puis concluez de nouveau. Enregistrez le fichier.

**Résultat attendu :** deux conclusions séparées, l’une sur les données perdues (RPO), l’autre sur le temps de retour (RTO). Contrôlez les additions et les conversions minutes/heures. Les deux objectifs sont indépendants : une restauration rapide peut perdre trop de données, et une sauvegarde très récente peut prendre trop de temps à remettre en service.

## 3. Comparer les options de reprise

### 3.1. Choisir parmi trois offres selon le RTO, le RPO et la perte du site A

**Données :** trois prestataires fictifs proposent une solution. Les valeurs sont annoncées par les prestataires ; elles n’ont pas encore été testées.

| Offre fictive | Délai de reprise annoncé | Perte de données annoncée | Protection |
|---|---:|---:|---|
| A — site froid | 10 h | jusqu’à 24 h | Sauvegarde isolée ; serveurs à reconstruire sur un autre site |
| B — site tiède | 3 h | jusqu’à 10 min | Autre site ; données copiées en continu (réplication) et sauvegardes isolées conservées |
| C — cluster local | 10 min | quasi nulle | Deux serveurs sur le même site A, gérés par les mêmes administrateurs ; pas de sauvegarde ancienne isolée |

Une **sauvegarde isolée** est stockée à part et ne peut pas être modifiée ou effacée avec les comptes de la production. Une **réplique** est une copie tenue à jour en continu : elle reçoit aussi les erreurs ou les modifications malveillantes.

- **A1-3.1.1** — Dans « Stratégie retenue et réserve », choisissez l’offre qui, d’après les valeurs annoncées, permet de reprendre après la perte complète du site A tout en respectant le RTO de 4 h et le RPO de 15 min. Écrivez pour chacune des deux autres offres la raison précise de son rejet.
- **A1-3.1.2** — Dans « Preuves à demander », listez trois preuves à obtenir avant d’accepter l’offre :
  - un test de reprise complet et chronométré ;
  - une preuve sur les données récupérées ;
  - une preuve d’indépendance vis-à-vis du site A.
  - Ajoutez la question à se poser avant d’ouvrir la réplique si l’on soupçonne une attaque.

**Résultat attendu :** un choix argumenté et conditionné à des preuves. Les chiffres annoncés ne sont pas des résultats de test. L’offre la plus rapide sur une panne de serveur n’est pas forcément la plus solide face à la perte d’un site ou à une attaque, par exemple un cluster local qui s’arrête avec le site entier.

## Contrôle final

Votre fichier contient les cinq rubriques, les calculs de la partie 2 et un choix d’offre accompagné de réserves. Si un calcul vous semble douteux, reprenez **A1-2.1.2** en convertissant toutes les durées en minutes avant d’additionner. Si vous avez choisi l’offre C, relisez le scénario : c’est le site A entier qui est perdu. Conservez le fichier pour l’atelier 2 ; aucun dépôt ni publication n’est demandé.

Bonus facultatif : la direction ramène le RTO à 1 h. Indiquez si l’offre B suffit encore et ce que la direction doit décider.
