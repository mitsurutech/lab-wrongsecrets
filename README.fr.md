# Lab WrongSecrets avec Docker Compose : s’entraîner à trouver des secrets codés en dur et les erreurs de gestion des secrets avec OWASP WrongSecrets

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml)

Un **lab de gestion des secrets** prêt à l’emploi pour la classe, issu de la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning), où les écoles et les établissements donnent à chaque élève ses propres bases de données, ses propres conteneurs et son propre terminal dans le navigateur. Chaque élève reçoit sa propre copie d’**OWASP WrongSecrets**, une application qui cache volontairement mal de faux secrets, dans son code, ses pages web et sa configuration, pour s’entraîner à **trouver des secrets codés en dur**, puis à expliquer où un secret aurait dû être conservé. Rien n’est installé et la machine de personne d’autre n’est en danger.

C’est un seul fichier `docker-compose`, `compose.yaml`, et il fonctionne de la même façon sur votre propre machine que sur la plateforme, où chaque élève dispose d’une copie privée sans aucune sortie vers Internet.

## La règle d’or

**Regardez dans votre propre copie et nulle part ailleurs.** Tout ce qui se trouve dans ce lab tourne à l’intérieur de votre propre copie privée, qui n’a aucune route vers Internet ni vers un autre élève : la seule chose que vous pouvez atteindre est l’application que le lab a démarrée pour vous. Ne dirigez jamais un outil vers un site web, un réseau ou une machine qui ne vous appartient pas, dans un lab comme ailleurs : au Royaume-Uni, c’est une infraction au titre du [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), et la plupart des pays ont une loi semblable. Les secrets de cette application sont inventés, et prendre l’habitude de chercher les vrais dans le dépôt de quelqu’un d’autre n’est pas un jeu : une bonne première discussion en classe porte sur la raison d’être de cette règle et sur ce à quoi ressemble une divulgation responsable.

## Ce que contient le lab

| Service | Image | Mémoire | Ce que c’est |
| --- | --- | --- | --- |
| `wrongsecrets` | [`jeroenwillemsen/wrongsecrets:1.14.1-no-vault`](https://hub.docker.com/r/jeroenwillemsen/wrongsecrets) | 512 Mo | l’application web WrongSecrets, sur le port 8080 |

L’image est la version `no-vault` du projet lui-même : elle n’a besoin d’aucun serveur Vault ni d’aucun compte cloud. Elle s’exécute sous un compte sans privilèges (utilisateur 2000) et n’a besoin d’aucune capacité. Elle démarre en quelques secondes, une fois l’image présente sur la machine, et utilise environ 235 Mo au repos. L’image est volumineuse, environ 550 Mo à télécharger : le premier démarrage sur une nouvelle machine est donc plus long.

L’image est un programme tiers, exécuté sans modification à partir de l’image publique du projet et figé sur une version (jamais `latest`), si bien que le lab ne change pas sous les pieds d’une classe d’une leçon à l’autre. Rien n’est construit ici et rien de ce dépôt n’y est distribué.

## L’utiliser sur la plateforme

La [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) donne à chaque élève sa propre copie d’un lab, dans le navigateur, avec un terminal à côté.

**Pour l’essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/fr/container), trouvez ce lab dans **Laboratoires d’exemple** et appuyez sur Démarrer. Aucun compte n’est nécessaire pour en essayer un.

**Pour le donner comme travail à une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **Dans un dépôt GitHub**.
2. Indiquez `https://github.com/mitsurutech/lab-wrongsecrets` avec la branche `main`. Le fichier compose est celui par défaut, `compose.yaml`. Faites d’abord un fork du dépôt si vous voulez modifier le fichier.
3. Publiez. La copie de chaque élève part du commit que vous avez publié : une modification ultérieure ici ne change donc pas un lab déjà donné.
4. Dites dans la tâche ce qu’il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), et distribuez-la comme n’importe quelle autre tâche.

Le [guide de ce lab](https://mitsurutech.co.uk/fr/help/lab-wrongsecrets), le [guide des labs de sécurité](https://mitsurutech.co.uk/fr/help/security-labs) et le [guide des labs de conteneurs](https://mitsurutech.co.uk/fr/help/labs) du manuel d’aide disent le reste : ce qu’un fichier compose peut contenir, combien de mémoire reçoit une copie, et comment un enseignant ouvre, observe et corrige la copie d’un élève.

Pas encore de compte d’établissement ? [La première année est gratuite](https://mitsurutech.co.uk/fr/pricing) pour 50 élèves au plus, et [s’inscrire](https://mitsurutech.co.uk/fr/signup) ne demande qu’une adresse e-mail.

## L’exécuter sur votre propre machine

Il vous faut Docker avec le plugin Compose. Le premier démarrage télécharge l’image.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://localhost:8080>. Il n’y a aucun compte à créer : choisissez un défi dans le menu **Challenges**.

`local.yaml` ne publie le port que sur `127.0.0.1`, si bien que le lab est accessible depuis votre propre ordinateur et nulle part ailleurs. Arrêtez-le avec `Ctrl-C`, et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`.

## Pas à pas

1. **Commencez par le Challenge 0.** Il explique le jeu : chaque défi consiste à trouver un secret qui n’a pas été bien caché ou bien configuré, puis à le saisir et à appuyer sur Submit. Sa propre réponse figure sur la page.
2. **Lisez l’énoncé et les indices.** Chaque défi dit de quel type de faiblesse il s’agit et propose des indices que vous pouvez ouvrir quand vous êtes bloqué.
3. **Cherchez là où chercherait un développeur ou un attaquant.** Dans ce lab, c’est la page elle-même et les outils de développement du navigateur, ainsi que le terminal à côté du lab, où `curl` atteint l’application par le nom `wrongsecrets` sur le port 8080. Par exemple, le Challenge 16 porte sur un secret laissé dans du code front-end, et le Challenge 42 sur ce que révèlent les points d’accès de supervision d’une application.
4. **Expliquez-le.** Pour chaque secret trouvé, dites où il se trouvait, comment vous l’avez trouvé, pourquoi cet endroit est mauvais et où un secret devrait être conservé.

## Pour les enseignants

Rien dans ce lab n’est corrigé automatiquement, hormis la coche verte de l’application elle-même pour une bonne réponse. L’élève rend des preuves et vous les corrigez, comme pour n’importe quel autre lab.

**Demandez des preuves en deux moitiés.** D’abord, la preuve du travail : une capture d’écran de chaque défi résolu, avec l’adresse du lab visible dans le navigateur pour qu’il soit clair que c’est sa copie. Ensuite, la compréhension : pour chacun, une explication écrite avec ses propres mots de l’endroit où se trouvait le secret, de la façon dont il l’a trouvé, de la raison pour laquelle cet endroit est mauvais et de ce qu’une équipe devrait faire à la place (un gestionnaire de secrets, une configuration d’environnement tenue hors de l’image, une recherche de secrets avant un commit). La seconde moitié vous dit si cela a été compris ou recopié d’une solution pas à pas.

**Sa place dans un cours.** WrongSecrets convient aux unités de développement sécurisé, de DevOps et de chaîne d’approvisionnement logicielle : identifiants dans le code et dans le contrôle de version, dans les images de conteneurs et la configuration, dans le code front-end, et dans les journaux et la supervision. Vérifiez le libellé exact dans l’unité de votre propre organisme certificateur ; aucun n’est cité ici.

**Qui voit quoi.** Ces labs sont souvent utilisés avec des élèves de 16 et 17 ans. Une copie est privée pour l’élève qui l’a démarrée. Un membre du personnel qui enseigne le module peut l’ouvrir pour voir ce que l’élève a fait, et l’ouverture du travail d’un élève est inscrite dans le journal d’accès, que l’élève peut lire.

## Ce qui ne marche pas dans un lab

**Seuls certains défis peuvent être résolus ici, et c’est voulu par la conception du lab, pas un défaut.** Une copie du lab n’a aucune sortie vers Internet, et l’application est la seule chose qu’elle contient. Les défis qui demandent de cloner le dépôt du projet depuis GitHub, d’ouvrir un shell dans le conteneur de l’application, d’utiliser un compte cloud, Vault ou Kubernetes, ou de parler à un service d’IA ou à un site web ailleurs ne peuvent pas être réalisés. Ceux qui portent sur la page elle-même, sur les points d’accès de l’application et sur ce que le navigateur télécharge le peuvent : les Challenges 0, 16 et 42 sont vérifiés par les tests de ce dépôt. L’image `no-vault` n’a aucun des défis Vault. L’application ne garde rien : arrêter le lab puis le redémarrer donne une partie neuve, sans aucun défi résolu mémorisé.

## Dépannage

- **La page n’apparaît pas juste après Démarrer.** Attendez quelques secondes et appuyez de nouveau sur Ouvrir : le lab se déclare prêt une fois que l’application répond à son adresse de contrôle de santé.
- **Un défi dit qu’il a besoin de quelque chose que le lab n’a pas.** C’est l’un des défis décrits ci-dessus ; choisissez-en un autre.
- **Sur votre propre machine, le port 8080 est déjà utilisé.** Changez le nombre de gauche dans `local.yaml`, par exemple `127.0.0.1:8081:8080`, et ouvrez plutôt ce port.

## Vérification du lab

`test/check.sh` démarre le lab comme le runner de la plateforme démarre chaque service (toutes les capacités retirées, `no-new-privileges`, une limite de processus, des limites de mémoire et aucune sortie vers Internet), puis vérifie depuis l’intérieur de son réseau ce que cette page promet. Il a besoin de Docker et s’exécute à chaque push, ce qu’indique le badge en haut.

```bash
test/check.sh
```

## Versions et licences

[OWASP WrongSecrets](https://github.com/OWASP/wrongsecrets) est sous licence GNU Affero General Public License v3.0 (AGPL-3.0). L’image est `jeroenwillemsen/wrongsecrets` à l’étiquette `1.14.1-no-vault`. Elle est utilisée ici sans modification, à partir de sa propre image publique, et n’est pas redistribuée.

## Licence

Cette œuvre est sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Vous pouvez la partager et l’adapter pour apprendre et enseigner, à condition de citer Mitsuru Technologies Ltd, de ne pas l’utiliser commercialement et de partager tout ce que vous en tirez sous la même licence. Le texte complet est dans le fichier `LICENSE`.

L’application qu’elle contient garde la licence de son propre projet, indiquée plus haut.

## À propos

Réalisé par [Mitsuru Technologies](https://mitsurutech.co.uk/fr) pour la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) : Python, Java, Go, Node, SQL et Linux dans le navigateur pour les écoles et les établissements, avec des labs de conteneurs, des applications web déployées depuis GitHub et des quiz qui se corrigent tout seuls. Essayez du code sans compte dans le [bac à sable](https://mitsurutech.co.uk/fr/playground).

D’autres labs du même endroit : [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) et [lab-sample](https://github.com/mitsurutech/lab-sample).
