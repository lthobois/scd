# Atelier 3 — Traiter les risques et simuler une politique MFA

**Situation :** vous assistez Inès, responsable de la sécurité (RSSI) de Novalys. Elle vous demande de classer trois risques, d’analyser un courriel suspect et de décider qui peut faire quoi sur le portail.

**Objectif :** prioriser des risques et prendre des décisions d’accès compréhensibles et vérifiables.

**Livrable :** un fichier texte `A3-risques-acces.txt`, réutilisé dans l’atelier 6.

**Matériel :** un éditeur de texte. Aucun compte, téléphone, droit administrateur ni licence : les politiques d’accès sont simulées sur papier et n’activent aucune MFA réelle. Le [message fictif](Donnees/message-phishing.txt) est fourni ; s’il ne s’ouvre pas, utilisez sa description dans la partie 2. Ne suivez aucun lien et ne saisissez aucun identifiant.

**Contrôle :** vous travaillez seul. En cas de blocage, communiquez au formateur la référence de la tâche, par exemple **A3-3.1.2**.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple Novalys |
|---|---|---|
| Vraisemblance | Probabilité estimée que le scénario se produise, notée ici de 1 (faible) à 3 (forte) | Un compte sans MFA partagé par plusieurs personnes : 3 |
| Impact | Gravité des conséquences, notée de 1 à 3 | Destruction des sauvegardes : 3 |
| Score | Vraisemblance × impact ; il sert à trier, ce n’est pas un montant | 3 × 3 = 9 |
| Propriétaire d’une mesure | Personne qui répond de sa mise en place | Malik pour les comptes d’administration |
| MFA | Authentification multifacteur : au moins deux preuves de catégories différentes (ce que je sais, ce que je possède, ce que je suis) | Mot de passe + clé de sécurité |
| RBAC | Droits accordés selon le rôle | Une lectrice consulte, un gestionnaire modifie |
| Condition contextuelle | Exigence liée aux circonstances de l’accès | Appareil conforme exigé pour modifier une commande |
| Appareil conforme | Poste géré par l’entreprise, à jour et protégé | Ordinateur portable fourni par Novalys |
| Poste d’administration | Poste réservé aux tâches d’administration, distinct d’un poste ordinaire | Poste dédié utilisé uniquement pour administrer |
| Refus par défaut | Tout ce qui n’est pas explicitement autorisé est refusé | Un rôle inconnu n’obtient aucun droit |

**Acteurs :** Malik coordonne l’exploitation informatique ; Hugo représente le métier « commandes » et approuve les rôles métier ; Inès définit les règles de sécurité et suit les risques.

**Question directrice :** Quels risques peuvent empêcher cette reprise ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A3 est une pièce du dossier de décision.

## 1. Construire trois scénarios de risque

### 1.1. Coter les scénarios fournis et décider d’un traitement dans le fichier local

**Données :** trois faiblesses ont été constatées.

1. Le prestataire utilise un compte d’administration partagé entre plusieurs techniciens, sans MFA. Vraisemblance 3, impact 3.
2. Tous les employés peuvent exporter la liste complète des clients. Vraisemblance 2, impact 3.
3. Les sauvegardes peuvent être supprimées avec les mêmes comptes d’administration que la production. Vraisemblance 2, impact 3.

- **A3-1.1.1** — Créez `A3-risques-acces.txt` avec cette trame, puis enregistrez-le :

```text
Risques : scénario | vraisemblance | impact | score | mesure | propriétaire | preuve
Phishing : indices et conduite à tenir
Politique d’accès : règles et résultats
Enrôlement et secours :
Contrôle final :
```

- **A3-1.1.2** — Rédigez une ligne par faiblesse :
  - décrivez le scénario en une phrase « événement → faiblesse exploitée → conséquence » ;
  - calculez le score ;
  - proposez une mesure, son propriétaire parmi les acteurs ci-dessus et la preuve qui montrera qu’elle fonctionne.

  Exemple de forme : `Un salarié mécontent exporte la liste clients → export ouvert à tous → divulgation de données personnelles | 2 | 3 | 6 | … | … | …`

**Résultat attendu :** trois risques distincts, de scores 9, 6 et 6, chacun avec une mesure vérifiable. Deux scores égaux ne rendent pas deux risques identiques : l’un menace la confidentialité des clients, l’autre la capacité à reprendre après une attaque.

## 2. Analyser une demande suspecte

### 2.1. Examiner le message fictif sans ouvrir de lien ni saisir d’identifiant

**Données :** le message se présente comme venant du « Support Novalys », mais son adresse d’envoi est `support@novalys-assistance.example`. Il demande de « réactiver la MFA sous 15 minutes » sur `https://connexion-novalys.example/reset`, puis de transmettre le code reçu par téléphone. Il conseille de ne pas contacter le support habituel. Le domaine officiel de l’entreprise est `novalys.example`. Tous ces noms sont fictifs et réservés à la documentation.

- **A3-2.1.1** — Dans « Phishing », notez trois indices vérifiables, dont le domaine d’envoi et la demande de code. Expliquez en une phrase pourquoi ces indices rendent le message suspect sans prouver avec certitude qui l’a envoyé.
- **A3-2.1.2** — Écrivez la conduite à tenir en trois points : par quel canal connu vérifier, comment signaler le message en interne, ce qu’il ne faut pas faire avec le message. Enregistrez.

**Résultat attendu :** une décision fondée sur ce que demande le message et sur les domaines utilisés. Un message sans faute d’orthographe et avec un logo resterait suspect avec ces mêmes éléments : aucun support légitime ne demande de lui transmettre un code MFA.

## 3. Configurer une politique sur fiches simulées

### 3.1. Écrire les règles d’accès du portail, puis les appliquer à quatre demandes

**Politique voulue par Novalys :**

- un lecteur consulte les commandes ;
- un gestionnaire consulte et modifie les commandes de son périmètre (sa région, ses clients) ;
- un prestataire administre les serveurs, uniquement par le chemin prévu et avec une autorisation temporaire ; son rôle technique ne lui donne aucun droit sur les commandes ;
- toute connexion exige la MFA ;
- toute modification de commande exige un appareil conforme ;
- l’administration exige en plus un poste d’administration et une autorisation en cours de validité.

- **A3-3.1.1** — Dans « Politique d’accès », écrivez trois règles :
  - une règle de droits par rôle (RBAC) ;
  - une règle de conditions contextuelles (MFA, appareil, poste d’administration, autorisation) ;
  - une règle de refus par défaut.
  - Ajoutez un test de refus hors périmètre et son résultat attendu.
- **A3-3.1.2** — Appliquez vos règles aux quatre demandes suivantes. Pour chacune, notez « autorisé » ou « refusé » et la règle qui décide :
  - Paul, gestionnaire, MFA oui, appareil conforme, modifie une commande de son périmètre ;
  - Sara, lectrice, MFA oui, appareil conforme, veut modifier une commande ;
  - Prest-01, administrateur prestataire, MFA oui, appareil ordinaire, veut administrer un serveur ;
  - Paul, même demande que la première, mais sans MFA.

**Résultat attendu :** un accès autorisé et trois refus, chacun justifié par une règle. Un refus peut venir du rôle (Sara) ou du contexte (Prest-01, Paul sans MFA) : activer la MFA ne corrige pas un droit trop large.

### 3.2. Préparer l’enrôlement et la récupération sans toucher à un compte réel

- **A3-3.2.1** — Dans « Enrôlement et secours », décrivez l’enrôlement d’un nouvel utilisateur à la MFA :
  - comment vérifier son identité avant d’enregistrer son facteur ;
  - quels deux facteurs de catégories différentes utiliser ;
  - quel test d’accès réaliser ensuite.
  - Précisez qu’aucun code ni secret ne doit être écrit dans votre fichier.
- **A3-3.2.2** — Décrivez la récupération après la perte du téléphone servant de facteur, en cinq étapes : contrôle d’identité selon une procédure approuvée, révocation du facteur perdu, enregistrement d’un nouveau facteur, surveillance des connexions, accès de secours contrôlé si besoin. Enregistrez.

**Résultat attendu :** une procédure dans laquelle la récupération ne devient pas un moyen de contourner la MFA. Un attaquant qui ne peut pas passer la MFA tentera souvent d’appeler le support en se faisant passer pour l’utilisateur : la procédure de récupération fait donc partie de la protection.

## Contrôle final

Votre fichier contient trois scores, trois mesures avec propriétaire et preuve, l’analyse du message et quatre décisions d’accès justifiées. Si vous avez autorisé Sara ou Prest-01, reprenez **A3-3.1.2** ; si vous avez prévu deux mots de passe comme deux facteurs, reprenez **A3-3.2.1**. Gardez le fichier pour l’atelier 6.

Bonus facultatif : proposez un indicateur qui compte les comptes prestataires encore actifs après la fin de leur mission, avec la personne chargée de le suivre.
