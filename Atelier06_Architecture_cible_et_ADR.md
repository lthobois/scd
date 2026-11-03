# Atelier 6 — Concevoir une cible sécurisée et décider de la trajectoire

**Situation :** vous consolidez les travaux Novalys des ateliers précédents. La direction attend une architecture cible, la liste des échanges réseau autorisés et une décision écrite qu’elle pourra réexaminer.

**Objectif :** produire une vue de la cible, des flux maîtrisés et une décision vérifiable, puis planifier les étapes de mise en œuvre.

**Livrable :** un fichier texte `A6-architecture-decision.txt`.

**Matériel :** un éditeur de texte et, si disponible, un navigateur vers [l’éditeur BPMN](https://demo.bpmn.io/), accès **Open diagram from local file system**, sans compte pour ouvrir et modifier le modèle local. Téléchargez [commande-depart.bpmn](Donnees/commande-depart.bpmn) et [commande-reference.bpmn](Donnees/commande-reference.bpmn) en conservant leurs extensions. La vue d’architecture reste textuelle ; le processus est un fichier BPMN éditable, descriptif et non exécutable. Sans accès web, la procédure XML de l’action 2.3 permet la même modification locale. Gardez ouverts vos fichiers A1, A3 et A5. S’ils manquent, retenez : site de secours tiède B, RTO 4 h, RPO 15 min, identité présente uniquement sur le site A (à corriger), comptes prestataires à limiter.

**Contrôle :** vous travaillez seul et comparez votre fichier avec la partie « Atelier 6 » du [corrigé des ateliers](Corrige_ateliers.md). En cas de blocage, communiquez au formateur la référence de la tâche, par exemple **A6-2.2.2**.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple Novalys |
|---|---|---|
| Vue typée | Chaque élément est précédé de sa nature entre crochets | `[Application] Portail` |
| Flux | Échange réseau autorisé d’une origine vers une destination | Portail → API en HTTPS, TCP 443 |
| Point d’entrée | Seul composant exposé à Internet, qui reçoit les clients et relaie vers le portail | Répartiteur ou proxy web en zone exposée |
| Bastion | Passerelle d’administration unique : MFA, autorisation et enregistrement des sessions | Le prestataire passe par le bastion pour administrer la base |
| Moindre privilège | N’accorder que les droits strictement nécessaires | L’API n’a accès qu’à la base commandes |
| Idempotence | Rejouer une même demande ne crée pas d’effet en double | Une relance après coupure ne crée pas une deuxième commande |
| Comptes de secours | Comptes d’administration réservés à la crise, utilisables même sans le site A | Compte d’urgence conservé dans un coffre-fort numérique |
| ADR | Fiche de décision d’architecture : contexte, options, décision, raisons, conséquences, réexamen | Choix du site tiède |
| Jalon | Étape de la trajectoire validée par une preuve observable | « Connexion réussie à B sans le site A » |

**Question directrice :** Quelle cible construire et comment vérifier sa réalisation ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A6 est une pièce du dossier de décision.

## 1. Représenter la cible et ses dépendances

### 1.1. Créer le fichier et décrire en texte les éléments métier, applicatifs, techniques et de sécurité

- **A6-1.1.1** — Créez `A6-architecture-decision.txt` avec cette trame, puis enregistrez-le :

```text
Vue typée :
Flux autorisés et flux refusé :
Séquence d’une commande et refus :
ADR : contexte | options | décision | raisons | conséquences | réexamen
Trajectoire et preuves :
```

- **A6-1.1.2** — Dans « Vue typée », écrivez une ligne par dépendance, avec la nature de chaque élément et son ou ses sites. Incluez : l’activité commandes, le portail, l’API, la base, l’identité, le DNS, la collecte des journaux et les sauvegardes. Indiquez la séparation entre la zone exposée à Internet et la zone des données, et ajoutez un chemin d’administration distinct.

  Exemple de forme : `[Métier] Prise de commandes → [Application] Portail [A, B]`
- **A6-1.1.3** — Corrigez la dépendance à l’identité présente uniquement sur A. Indiquez comment les comptes de secours et les clés de chiffrement restent disponibles si le site A est perdu. Ajoutez la mention « à tester » à chaque capacité qui n’a pas encore été démontrée.

**Résultat attendu :** une cible lisible où toutes les dépendances apparaissent avec leur site. Comparez avec le corrigé, partie A6-1. La vue présente une conception : les mentions « à tester » évitent de la confondre avec une capacité déjà acquise.

## 2. Autoriser les seuls échanges nécessaires

### 2.1. Définir les flux du client vers les données et le chemin d’administration

**Données de l’exercice :** le portail et l’API utilisent HTTPS sur le port TCP 443. La base de données fictive (PostgreSQL) écoute sur le port TCP 5432. L’identité, le DNS et la collecte des journaux utilisent aussi des flux ; dans un projet réel, ils seraient détaillés dans la conception technique. Ne les ouvrez pas à toutes les sources.

- **A6-2.1.1** — Dans « Flux autorisés et flux refusé », écrivez quatre règles sous la forme `origine → destination | protocole/port | finalité | contrôle` :
  - client → point d’entrée ;
  - portail → API ;
  - API → base ;
  - administration → ressources gérées : décrivez le chemin contrôlé plutôt qu’un numéro de port.
- **A6-2.1.2** — Ajoutez une règle de refus explicite client → base. Reprenez les droits définis dans l’atelier 3 : indiquez ce que l’API vérifie avant d’accepter une modification, et ce qu’elle enregistre dans sa trace, sans mot de passe ni jeton.

**Résultat attendu :** des règles précises et une autorisation métier distincte de l’autorisation réseau. Comparez avec le corrigé, partie A6-2. Atteindre le port 443 ne doit pas suffire pour modifier n’importe quelle commande : c’est l’API qui vérifie le rôle et le périmètre.

### 2.2. Décrire le traitement d’une commande, sa branche de refus et une relance sans doublon

- **A6-2.2.1** — Dans « Séquence d’une commande et refus », écrivez les étapes dans l’ordre : demande, authentification, autorisation, validation, écriture, confirmation. Placez le refus avant toute écriture si les droits manquent. Ajoutez un identifiant de corrélation, qui permet de suivre la demande dans les journaux sans contenir de secret.
- **A6-2.2.2** — Le client ne reçoit pas de réponse et renvoie sa demande. Expliquez comment un identifiant de demande unique (clé d’idempotence) évite la création d’une deuxième commande. Enregistrez.

**Résultat attendu :** une branche autorisée et une branche refusée cohérentes. Comparez avec le corrigé, partie A6-2. Une relance réseau ne doit pas devenir une double commande : il faut définir combien de temps l’identifiant de demande est conservé.

### 2.3. Compléter le processus BPMN avec une branche de refus sans écriture

Le processus initial représente une commande reçue, un contrôle des droits et une branche vers l’enregistrement. Il manque le refus. L’objectif est de rendre ce comportement explicite dans un véritable fichier de modèle, plutôt que de décrire uniquement la séquence dans les notes.

- **A6-2.3.1** — Faites une copie locale de `commande-depart.bpmn` nommée `A6-commande.bpmn`. Ouvrez-la dans l’éditeur avec Open diagram from local file system. Repérez le cercle de début, la tâche de contrôle, le losange exclusif, la tâche Enregistrer et la fin Commande confirmée. Si l’éditeur est indisponible, ouvrez le fichier dans l’éditeur de texte et repérez `Start`, `Controler`, `Choix`, `Enregistrer` et `Confirmer`.
- **A6-2.3.2** — Dans l’éditeur graphique, nommez la passerelle « Droits suffisants ? » et le flux vers Enregistrer « Oui ». Ajoutez une seconde branche « Non » vers une tâche « Notifier le refus », puis un événement de fin « Commande refusée ». Utilisez les éléments tâche, événement de fin et flux de séquence de la palette ; le refus ne doit jamais rejoindre Enregistrer. Téléchargez le modèle modifié sous `A6-commande.bpmn`.

  En mode XML local, effectuez les mêmes changements sur les attributs `name`, puis insérez les éléments et références suivants dans `bpmn:process` avant les flux existants ; l’ordre des nœuds n’affecte pas le déroulement, ce sont les références qui le définissent :

```xml
<bpmn:task id="Refuser" name="Notifier le refus">
  <bpmn:incoming>F5</bpmn:incoming><bpmn:outgoing>F6</bpmn:outgoing>
</bpmn:task>
<bpmn:endEvent id="FinRefus" name="Commande refusée">
  <bpmn:incoming>F6</bpmn:incoming>
</bpmn:endEvent>
<bpmn:sequenceFlow id="F5" name="Non" sourceRef="Choix" targetRef="Refuser" />
<bpmn:sequenceFlow id="F6" sourceRef="Refuser" targetRef="FinRefus" />
```

  Ajoutez aussi `<bpmn:outgoing>F5</bpmn:outgoing>` à la passerelle `Choix`. Pour obtenir le placement graphique du refus, recopiez depuis le fichier de référence les deux blocs `bpmndi:BPMNShape` `Refuser_di`, `FinRefus_di` et les deux blocs `bpmndi:BPMNEdge` `F5_di`, `F6_di`, en entier, dans `bpmndi:BPMNPlane` de votre fichier. Il s’agit d’éléments XML complets, avec leurs balises de fermeture ; ne créez pas un second `BPMNPlane`.

- **A6-2.3.3** — Enregistrez puis comparez au fichier de référence : un début, deux tâches (contrôle et enregistrement) plus la tâche de refus, une passerelle exclusive, deux fins et six flux de séquence. Depuis le contrôle, la branche Oui atteint l’écriture ; la branche Non atteint uniquement le refus. Vérifiez que toutes les références visent des identifiants existants. Les identifiants générés par l’éditeur peuvent différer du corrigé : comparez le sens et les chemins, pas leur orthographe. Dans `A6-architecture-decision.txt`, notez seulement la raison du refus avant écriture ; le modèle reste dans son fichier `.bpmn`.

Résultat attendu : un modèle éditable comportant les deux issues, conservé sous `A6-commande.bpmn`. Vérification : comparez les chemins à [commande-reference.bpmn](Donnees/commande-reference.bpmn) et au corrigé 3. Interprétation : BPMN montre le processus ; le contrôle côté API doit encore être réalisé et testé dans le système. Si le fichier s’affiche en texte dans le navigateur, enregistrez sa cible avec l’extension `.bpmn`, puis ouvrez ce fichier local. Une erreur XML impose de vérifier les balises et identifiants ; l’extension seule ne garantit pas la validité du modèle.

## 3. Justifier et planifier le changement

### 3.1. Rédiger l’ADR du site tiède et ordonner trois jalons vérifiables

- **A6-3.1.1** — Comparez en trois lignes le site froid, le site tiède et le cluster local de l’atelier 1. Rédigez ensuite l’ADR du choix retenu en suivant la trame : exigence RTO/RPO, réserve sur la confiance dans la réplique, coût et complexité, condition de réexamen. Si vous reprenez les durées annoncées dans l’atelier 1, précisez qu’elles restent à prouver.
- **A6-3.1.2** — Dans « Trajectoire et preuves », définissez trois jalons dans cet ordre :
  - fondations et accès de secours ;
  - sauvegardes et restauration ;
  - service complet et reprise après un changement.
  - Pour chacun, nommez un responsable (Malik, Inès ou Hugo) et la preuve qui valide le passage.
- **A6-3.1.3** — Relisez le fichier entier et vérifiez trois points : chaque ressource critique a un moyen de reprise ; aucun flux n’accorde plus que nécessaire ; l’ADR relie le choix au RTO et au RPO. Corrigez si besoin et enregistrez la version finale.

**Résultat attendu :** une décision qui peut être réexaminée et une trajectoire contrôlable étape par étape. Comparez avec le corrigé, partie A6-3. Avoir installé des serveurs à B ne prouve pas que le service reprend : seule une recette complète, chronomètre lancé, le démontre.

## Contrôle final

Vérifiez aussi `A6-commande.bpmn` : un début, trois tâches, une passerelle exclusive, deux fins et six flux ; comparez à [commande-reference.bpmn](Donnees/commande-reference.bpmn). Le refus ne doit jamais rejoindre l’enregistrement.

Votre fichier contient une vue typée, quatre flux autorisés et un refus, une séquence avec ses deux branches, une relance sans doublon, un ADR et trois jalons avec preuve. Si un poste client atteint directement la base, reprenez **A6-2.1.2** ; si aucun jalon ne contient de recette métier chronométrée, reprenez **A6-3.1.2**.

Bonus facultatif : ajoutez un service externe de paiement et décrivez l’effet de sa panne sur le processus de commande, sur le plan de continuité et sur le test de reprise.
