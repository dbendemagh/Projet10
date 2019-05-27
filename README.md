# Projet 10 - Reciplease

Reciplease est une application qui permet de rechercher des recettes.

Les fonctionnalités sont :

- Recherche à partir d'ingrédients
- Sauvegarde des recettes favorites
- Ajout des ingrédients dans la Shopping list

## Configuration

Pour fonctionner, l'application nécessite l'installation de Cocoapods. Vous avez besoin aussi d'un identifiant pour l'Api Yummly.

### Cocoapods

**Installation**
```
$ sudo gem install cocoapods
```

Dans le dossier contenant le projet Reciplease :
```
$ pod install
```

### APIs

Dans le dossier "Supporting Files", créer un fichier de type Property List nommé ApiKeys.plist.

Il doit contenir les informations suivantes :

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>yummlyId</key>
	<string>Votre Api Id</string>
	<key>yummlyKey</key>
	<string>Votre Api key</string>
</dict>
</plist>
```


