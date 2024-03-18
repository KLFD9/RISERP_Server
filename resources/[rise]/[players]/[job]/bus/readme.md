# Script de travail de bus pour FiveM

Ce script permet aux joueurs de travailler comme chauffeur de bus dans FiveM. Les joueurs peuvent commencer leur travail au dépôt de bus, conduire à divers arrêts de bus, et terminer leur service au dépôt.

## Fonctionnalités

- Les joueurs peuvent commencer leur travail au dépôt de bus en appuyant sur 'E'.
- Un bus est généré pour le joueur lorsqu'il commence son travail.
- Des blips sont créés pour chaque arrêt de bus lorsque le travail commence.
- Le joueur est guidé vers chaque arrêt de bus avec un point de repère GPS et un marqueur au sol.
- Un message est affiché à l'écran lorsque le joueur atteint un arrêt de bus.
- Le service se termine lorsque le joueur retourne au dépôt de bus.

## Installation

1. Téléchargez le script et placez-le dans votre dossier de ressources.
2. Ajoutez `start bus-job` à votre fichier server.cfg.
3. Redémarrez votre serveur.

## Configuration

Vous pouvez configurer le script en modifiant le tableau `stops` dans le fichier `main.lua`. Chaque entrée dans le tableau représente les coordonnées d'un arrêt de bus.

```lua
local stops = {
    vector3(307.18, -766.03, 29.82),
    vector3(111.00, -783.56, 31.95),
    -- Ajoutez plus d'arrêts ici
}
```

## Utilisation
Pour commencer le travail, allez au dépôt de bus et appuyez sur 'E'. Un bus sera généré et vous serez guidé vers le premier arrêt de bus. Suivez le point de repère GPS et arrêtez-vous à chaque arrêt de bus jusqu'à ce que vous les ayez tous visités. Lorsque vous avez visité tous les arrêts de bus, retournez au dépôt de bus pour terminer votre service.

## Support
Si vous rencontrez des problèmes avec le script, veuillez ouvrir un problème sur GitHub.