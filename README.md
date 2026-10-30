# Horloge flottante

Une petite fenêtre macOS toujours au premier plan, qui affiche l'heure ou un chrono. Un seul fichier Swift, aucune dépendance, aucun accès réseau.

- `horloge` affiche l'heure (HH:MM:SS), blanc sur noir, en haut à droite de l'écran.
- `horloge chrono` lance un chrono depuis 00:00:00, blanc sur rouge, trois fois plus grand, juste en dessous.

La fenêtre se déplace à la souris. Clic droit pour quitter.

## Installer le build

Télécharge `horloge-macos.zip` depuis la [dernière release](https://github.com/lenir923/horloge-flottante/releases/latest), puis :

```sh
unzip horloge-macos.zip
xattr -c horloge
./horloge
```

La commande `xattr -c` est nécessaire parce que le binaire n'est pas notarié par Apple : sans elle, macOS refuse de l'ouvrir.

Le build tourne sur les Mac Apple Silicon, à partir de macOS 11. Sur un Mac Intel, compile le source (voir ci-dessous).

## Compiler soi-même

Il faut les Xcode Command Line Tools.

```sh
swiftc -O horloge_flottante.swift -o horloge
```

## Licence

MIT
