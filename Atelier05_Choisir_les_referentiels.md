# Atelier 5 — Choisir les référentiels et préparer une vue utile

**Situation :** Novalys monte un dossier d’architecture pour son plan de reprise. Plusieurs équipes ont des besoins différents, et chacune cite un référentiel. Vous devez choisir lesquels utiliser, puis décrire une vue qui fait apparaître les dépendances de la reprise.

**Objectif :** choisir chaque cadre selon la question qu’il aide à résoudre, puis produire une vue qui révèle les défauts de la reprise.

**Livrable :** un fichier texte `A5-referentiels-vue.txt`, réutilisé dans l’atelier 6.

**Matériel :** un éditeur de texte. Aucun outil de modélisation, compte ni accès Internet. Gardez consultables le [module 5](../Programme/Modules/Module05_Referentiels_architecture.md) et le [glossaire](../Programme/Glossaire.md) : ils décrivent chaque référentiel. Si vous n’avez pas les fichiers des ateliers précédents, retenez : RTO 4 h, RPO 15 min, identité disponible uniquement sur le site A.

**Contrôle :** vous travaillez seul. En cas de blocage, communiquez au formateur la référence de la tâche, par exemple **A5-2.1.2**.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple Novalys |
|---|---|---|
| Cadre (framework) | Ensemble de méthodes et de bonnes pratiques à adapter | TOGAF pour conduire une transformation |
| Norme | Document publié par un organisme de normalisation, parfois certifiable | ISO/IEC 27001 |
| Langage ou notation | Règles de dessin partagées | BPMN pour dessiner un processus |
| Vue | Représentation du système qui répond à la préoccupation d’une partie prenante | Ce dont Hugo a besoin pour que le portail revienne en 4 h |
| Partie prenante | Personne ou groupe concerné par le système | Hugo, responsable métier commandes |
| Préoccupation | Question que la partie prenante se pose | « Pourrai-je reprendre les commandes en 4 h ? » |
| Conventions de représentation | Règles de lecture de la vue | `X → Y` signifie « X a besoin de Y pour fonctionner » |
| SPOF | Point unique de défaillance : un élément dont la panne arrête tout le service | Identité présente seulement sur le site A |

**Question directrice :** Quels référentiels aident à structurer les choix ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A5 est une pièce du dossier de décision.

## 1. Associer chaque besoin à une réponse

### 1.1. Créer le fichier et choisir le référentiel adapté à chaque besoin

**Besoins exprimés :**

- a. L’équipe processus veut dessiner les étapes du traitement d’une commande, y compris le cas de refus.
- b. L’exploitation veut organiser la gestion des incidents et des changements.
- c. L’architecte veut organiser la description de l’architecture par partie prenante et par préoccupation.
- d. La sécurité veut un système de management qui relie risques, mesures de sécurité et amélioration continue.
- e. Le comité de direction veut définir qui décide, qui accepte les risques et comment piloter le SI par objectifs et indicateurs.
- f. La direction veut une méthode pour conduire, par étapes, la transformation de l’existant vers la cible.

**Référentiels disponibles :** TOGAF, COBIT, ITIL, ISO/IEC/IEEE 42010, BPMN, ISO/IEC 27001 et 27002.

- **A5-1.1.1** — Créez `A5-referentiels-vue.txt` avec cette trame, puis enregistrez-le :

```text
Besoins et choix motivés :
Combinaison minimale :
Fiche de vue : partie prenante | préoccupation | conventions | éléments | preuve
Écarts détectés et décisions :
Affirmations corrigées et questions cloud :
```

- **A5-1.1.2** — Associez chaque besoin (a à f) à un référentiel. Pour chacun, écrivez en une ligne ce qu’il apporte et ce qu’il ne prouve pas.

  Exemple de forme : `a → … : apporte … ; ne prouve pas …`
- **A5-1.1.3** — Trois autres références existent : Zachman (grille de classement des descriptions d’architecture), CMMI (amélioration de la maturité des pratiques) et IT4IT (organisation de la chaîne de valeur du numérique). Pour chacune, écrivez une situation Novalys où elle deviendrait utile. Choisissez ensuite, dans « Combinaison minimale », trois approches pour démarrer le dossier de reprise, avec une raison par choix.

**Résultat attendu :** un choix par besoin, sans classement universel des référentiels. Une entreprise n’a pas besoin d’appliquer tous les cadres pour prendre une première décision utile : trois approches bien choisies suffisent souvent pour démarrer.

## 2. Décrire une vue centrée sur la continuité

### 2.1. Relier la préoccupation d’Hugo aux éléments techniques et à une preuve de test

**Données :** le portail appelle l’API commandes, qui lit et écrit dans la base de données. L’API a besoin de l’identité et du DNS. La production est sur le site A. L’application et la base sont copiées sur le site B. L’identité n’existe que sur le site A. Les comptes d’administration de secours n’ont jamais été testés.

- **A5-2.1.1** — Rédigez la fiche de vue en suivant la trame :
  - partie prenante : Hugo ;
  - préoccupation : « utiliser le portail sous 4 heures après la perte du site A » ;
  - conventions : comment vous notez une dépendance et le site où se trouve un élément ;
  - éléments nécessaires au service ;
  - preuve qui démontrerait la capacité de reprise.
- **A5-2.1.2** — Écrivez les dépendances sous forme de flèches textuelles, en indiquant pour chaque élément le ou les sites où il existe.

  Exemple de forme : `Portail [A, B] → API commandes [A, B]`

  Identifiez deux écarts qui empêchent d’affirmer que la reprise sur B fonctionne.
- **A5-2.1.3** — Dans « Écarts détectés et décisions », proposez une décision par écart. Ajoutez un contrôle de cohérence entre la vue applicative (ce dont l’application a besoin) et la vue technique (ce qui existe sur chaque site). Enregistrez.

**Résultat attendu :** une vue qui rend un défaut visible. On ne corrige pas un SPOF en effaçant sa flèche du schéma : il faut changer le système (ajouter une identité sur B), le scénario ou l’objectif, avec une décision de la direction.

## 3. Employer les normes avec le bon niveau d’affirmation

### 3.1. Corriger trois affirmations et préparer trois questions pour un projet cloud

- **A5-3.1.1** — Dans « Affirmations corrigées et questions cloud », réécrivez correctement ces trois phrases :
  - « Notre schéma est conforme, donc le service est disponible. »
  - « ISO/IEC 17789 est la référence cloud actuelle, sans réserve. »
  - « Avec un SaaS, nous n’avons plus à gérer les droits ni les données. »
- **A5-3.1.2** — Novalys envisage un service cloud. Écrivez trois questions à poser au fournisseur, sur la répartition des responsabilités, la reprise et la récupération des données en fin de contrat. Utilisez NIST SP 800-145 pour nommer le modèle de service (IaaS, PaaS ou SaaS), sans lui attribuer un engagement du fournisseur. Enregistrez.

**Résultat attendu :** des affirmations limitées à ce qui est réellement démontré. La conformité d’un schéma, l’engagement contractuel d’un fournisseur et le fonctionnement constaté lors d’un test sont trois choses différentes.

## Contrôle final

Une autre combinaison est recevable si chaque choix répond au besoin, sans confondre démarche, norme, langage et preuve de fonctionnement.

Votre fichier contient six associations motivées, une combinaison de trois approches, une vue avec deux écarts et leurs décisions, trois affirmations corrigées et trois questions cloud. Si vous avez associé un logiciel ou un outil à la place d’un référentiel, reprenez **A5-1.1.2** ; si votre vue ne montre pas où se trouve l’identité, reprenez **A5-2.1.2**. Conservez ce fichier pour l’atelier 6.

Bonus facultatif : proposez un indicateur qui signale qu’une vue n’est plus à jour après un changement, avec son propriétaire et l’événement qui déclenche la mise à jour.
