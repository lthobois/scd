# Atelier 2 — Décider dans une crise et éprouver le runbook

**Situation :** le portail de Novalys est en panne. Vous assistez la cellule de crise : vous rédigez ses décisions, vous préparez les contrôles de la procédure de reprise et le message aux équipes.

**Objectif :** lancer le bon scénario de reprise sans confondre rapidité et confiance dans les données.

**Livrable :** un fichier texte `A2-crise-runbook.txt`, réutilisé dans l’atelier 4.

**Matériel :** un éditeur de texte. Aucun compte, droit particulier ni action sur une infrastructure : toutes les données sont fictives et dans cette page. Si vous avez votre fichier `A1-bia-strategie.txt`, gardez-le ouvert ; sinon, retenez : RTO 4 h, RPO 15 min, site de secours tiède B avec sauvegardes isolées.

**Contrôle :** vous travaillez seul. En cas de blocage, communiquez au formateur la référence de la tâche, par exemple **A2-2.1.1**.

## Vocabulaire utile

| Terme | Sens dans cet atelier | Exemple Novalys |
|---|---|---|
| Cellule de crise | Petit groupe qui décide pendant l’incident | Claire (Direction), Malik (Informatique), Inès (Sécurité), Hugo (Métier) ; spécialistes selon les faits |
| Runbook | Procédure de reprise écrite pas à pas, avec ses contrôles | « Restaurer la base, vérifier les commandes, puis ouvrir » |
| Point de contrôle (go / no-go) | Vérification obligatoire avant de passer à l’étape suivante ; si elle échoue, on s’arrête | Ne pas ouvrir le portail tant que la commande test échoue |
| Réplique | Copie tenue à jour en continu sur le site B ; elle recopie aussi les modifications malveillantes | État de la base à 9 h 55 |
| Sauvegarde isolée | Copie stockée à part, que les comptes de production ne peuvent pas modifier | Sauvegarde de 9 h 30 |
| Environnement isolé | Zone de travail coupée des utilisateurs et d’Internet, pour reconstruire sans exposer | Restaurer à B sans ouvrir le portail aux clients |
| Test de bout en bout | Test qui part de la panne simulée et va jusqu’à la recette métier, sans étape faite à l’avance | Chronomètre lancé avant la restauration |

**Question directrice :** Qui décide et comment démontrer que la reprise fonctionne ?

Utilisez la [carte commune Novalys](../Programme/Carte-Novalys.md) pour situer les ressources ; votre fichier A2 est une pièce du dossier de décision.

## 1. Préparer une décision traçable

### 1.1. Créer le journal local et attribuer les rôles de crise

**Acteurs :** Claire (Direction), membre de la direction, dirige la crise : elle seule autorise l’activation du secours et l’ouverture du service. Malik (Informatique), responsable de l’exploitation informatique, coordonne la reprise technique. Inès (Sécurité) est la responsable de la sécurité (RSSI). Hugo (Métier) représente le métier « commandes ». Le prestataire est l’entreprise extérieure qui réalise les opérations techniques confiées ; ses accès et son périmètre sont préparés. Léa (DPO), déléguée à la protection des données, est consultée si les faits soulèvent une question de données personnelles. Le prestataire exécute uniquement les actions autorisées. RACI sert à répartir les responsabilités d’une action ; ce n’est pas un acteur de la cellule de crise.

**Événements :** à 10 h 00, le portail cesse de répondre. À 10 h 10, le site A reste inaccessible et personne ne peut dire quand il sera réparé.

- **A2-1.1.1** — Créez `A2-crise-runbook.txt` avec la trame suivante, puis enregistrez-le :

```text
Décision initiale : heure | faits | incertitudes | décision | autorité | action | responsable
Évolution de la décision :
Contrôles du runbook :
Message de situation :
Test et amélioration :
```

- **A2-1.1.2** — Rédigez la décision de 10 h 10 sur une ligne, en suivant les colonnes de la trame :
  - décision : préparer le site de secours B et passer en mode dégradé téléphonique ;
  - indiquez qui autorise (autorité) et qui fait exécuter (responsable) ;
  - écrivez que la cause de la panne est inconnue à ce stade.

**Résultat attendu :** une ligne datée, attribuée et exploitable par quelqu’un qui n’était pas présent. Vérifiez que l’autorité et l’exécutant sont distincts. Préparer le secours et ouvrir le portail aux clients sont deux décisions différentes : la seconde viendra plus tard, après contrôles.

## 2. Adapter le scénario aux événements

### 2.1. Traiter la suspicion d’attaque avant d’utiliser la réplique de 9 h 55

**Événements :** à 10 h 20, la réplique du site B est prête ; elle contient les données de 9 h 55. À 10 h 25, Inès (Sécurité) signale qu’un compte administrateur du prestataire a tenté de supprimer des sauvegardes à 9 h 20. Une sauvegarde isolée de 9 h 30 existe, mais on ne sait pas encore si elle est saine.

- **A2-2.1.1** — Dans « Évolution de la décision », écrivez :
  - ce que ce signal change : la panne est peut-être une attaque ;
  - pourquoi on ne peut pas ouvrir immédiatement la réplique de 9 h 55 ;
  - comment poursuivre la préparation sans exposer la réplique ni les clients.
- **A2-2.1.2** — Supposez que la sauvegarde de 9 h 30 soit retenue après vérification. Calculez la perte de données et l’écart au RPO de 15 min. Indiquez qui décide d’accepter cet écart pour le métier et qui conseille sur la confiance technique. Enregistrez.

**Résultat attendu :** une reprise conditionnée à des vérifications, avec un écart au RPO écrit noir sur blanc. Une sauvegarde isolée protège contre l’effacement, mais elle ne prouve pas que l’attaquant n’avait rien modifié avant sa création : ici, elle date de 9 h 30, après la tentative de 9 h 20.

### 2.2. Définir trois points de contrôle du runbook et un message factuel

- **A2-2.2.1** — Dans « Contrôles du runbook », écrivez trois points de contrôle, avec pour chacun la preuve attendue et ce que l’on fait s’il échoue :
  - avant la restauration ;
  - avant l’ouverture du portail aux clients ;
  - après l’ouverture.

  Exemple de forme : `Avant ouverture : preuve = … ; si échec = …`
- **A2-2.2.2** — Dans « Message de situation », rédigez un message interne de trois phrases destiné aux équipes : ce qui est établi, la conduite à tenir et l’heure du prochain point (11 h 00). N’annoncez ni cause ni heure de retour qui ne sont pas démontrées.

**Résultat attendu :** des contrôles vérifiables par oui ou non et un message cohérent avec les faits connus. Si les faits soulèvent une question de données personnelles, Léa (DPO) conseille sur les suites à examiner. Ne déduisez pas un export de clients de la seule tentative de suppression de sauvegarde : aucun export n’est ajouté aux faits de cet atelier.

## 3. Transformer l’exercice en amélioration

### 3.1. Préparer un test de bout en bout et clore une action sur preuve

**Données :** un test passé avait annoncé une reprise en 3 h. En réalité, le prestataire avait restauré la base de données avant de lancer le chronomètre, et personne n’avait utilisé les comptes d’administration de secours.

- **A2-3.1.1** — Dans « Test et amélioration », écrivez ce que ce test prouve et ce qu’il ne prouve pas. Proposez un nouveau test qui enchaîne : panne simulée, connexion avec les comptes de secours, restauration et commande de recette. Ajoutez un critère d’arrêt, c’est-à-dire une situation où l’on interrompt le test pour ne pas mettre la production en danger.
- **A2-3.1.2** — Rédigez une action d’amélioration avec un responsable, une échéance fixée par rapport au prochain exercice et la preuve qui permettra de la déclarer terminée. Enregistrez votre fichier pour l’atelier 4.

**Résultat attendu :** une conclusion limitée aux faits observés et un prochain test réellement utile. Une procédure écrite ne prouve pas que les comptes de secours fonctionnent : seule une connexion réussie le jour du test le prouve.

## Contrôle final

Votre fichier contient une décision datée, des rôles distincts, l’évolution du scénario, trois points de contrôle, un message et une action vérifiable. Si votre journal affirme « aucune donnée touchée », remplacez cette certitude par ce que l’on sait vraiment. Si l’autorité et l’exécutant sont la même personne, reprenez **A2-1.1.2**.

Bonus facultatif : le site A est réparé. Écrivez une condition de retour vers A (failback) qui empêche les deux sites d’accepter en même temps des commandes différentes.
