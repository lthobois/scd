# Novalys — carte commune du dossier de décision

Novalys Distribution est une entreprise fictive de 250 personnes. Les cartes projetées des six modules réutilisent les mêmes objets. Une vue représente une hypothèse de conception ; seul un test décrit permet d’en faire une capacité démontrée.

| Identifiant | Objet stable | État de départ | Cible à vérifier |
|---|---|---|---|
| ACT-01 | Traiter les commandes | Portail principal à A ; téléphone limité à 25 commandes/h | Service complet et rattrapage organisé |
| APP-01 | Portail commandes | Production A, copie de secours B à éprouver | Point d’entrée au secours, accès contrôlé |
| APP-02 | API commandes | Contrôle et enregistrement des demandes | Autorisations par rôle, objet et contexte |
| DATA-01 | Base commandes/stock | Production A, copie B à qualifier | Point restauré cohérent, mesuré et recetté |
| ID-01 | Identité | Dépendance disponible uniquement à A | Capacité d’identité utilisable sans A, à tester |
| ADM-01 | Accès prestataire | Indépendance et permissions à corriger | Nominatif, renforcé, temporaire, chemin dédié |
| BCK-01 | Copies de reprise | Droits d’administration communs à traiter | Copies protégées, états antérieurs et restauration testée |
| OBS-01 | Collecte des journaux | Couverture et corrélation à vérifier | Traces protégées, heures et résultats exploitables |

Le DNS, les certificats, les clés, le réseau et la capacité de restauration restent des dépendances à documenter. Leur présence dans un dessin ne vaut pas preuve de disponibilité. Les sites A/B doivent être vérifiés comme domaines de panne et d’administration distincts, et non supposés indépendants du seul fait de leurs noms.

| Module | Lecture nouvelle de la même carte | Décision / production |
|---|---|---|
| 1 | Activité, impacts et dépendances | A1 : objectifs 4 h / 15 min et stratégie |
| 2 | Responsabilités et conditions d’ouverture | A2 : autoriser, exécuter, contrôler et tester |
| 3 | Identités, droits et chemins d’attaque | A3 : risques, règles et tests d’accès |
| 4 | Traces et fiabilité des copies | A4 : faits, hypothèses et reprise conditionnelle |
| 5 | Existant, préoccupations et écarts | A5 : choix de cadres et vue motivée |
| 6 | Cible et preuves de réalisation | A6 : vue, BPMN, flux, ADR et trois jalons |

Claire arbitre la crise, Hugo porte le besoin commandes, Malik coordonne les moyens informatiques, Inès apprécie la sécurité et Léa conseille sur les données personnelles. Le prestataire exécute dans le périmètre autorisé. Les productions A1 à A6 forment six fiches d’un même dossier ; elles sont conservées localement sans restitution orale obligatoire.
