# Mini Quiz (Flutter)

Mini module de quiz mobile (Flutter) simple utilisant l’API Open Trivia DB.

## Exécution
1. Installer Flutter et un émulateur/smartphone.
2. Dans le dossier du projet, exécuter:
   - `flutter pub get`
   - `flutter run`

## Architecture
- models: `Question`, `QuizCategory`
- services: `QuizService` (appels HTTP OpenTDB)
- screens: `HomeScreen` (liste des catégories), `QuizScreen` (questions), `ResultScreen` (score)
- State: `StatefulWidget` + `FutureBuilder` (sans lib externe de state management)

## Réalisé
- Liste des catégories depuis OpenTDB
- 10 questions par quiz, réponses mélangées
- Calcul et affichage du score final

## Non réalisé (par simplicité)
- Sélection de difficulté/nombre de questions
- Persistance locale / reprise de session
- Tests unitaires