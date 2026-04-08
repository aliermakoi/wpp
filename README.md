# Dinka–English Dictionary (Flutter)

Offline-first mobile dictionary app for Android and iOS using a single Flutter/Dart codebase.

## Features

- Sticky blue header with menu, title, and South Sudan flag
- Instant local search (word + `searchKey` fallback)
- Smooth scrollable list via `ListView/SliverList` builder approach
- Word details screen with Previous/Next navigation
- Side drawer: Home, About, Contact Us, Rate Us, Share
- Fully offline JSON asset loading (no API/database)
- Riverpod state management and `go_router` navigation

## Project Structure

```text
lib/
  core/
    router/
    theme/
    widgets/
  features/
    home/
    dictionary/
    details/
    chat/
    about/
    contact/
```


## Install Dependencies

Use the helper script to install Python extractor dependencies:

```bash
./scripts/install_dependencies.sh
```

Or install directly:

```bash
pip install -r requirements.txt
```

## Run

1. Install Flutter SDK (stable) and Dart.
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run:
   ```bash
   flutter run
   ```

## Offline Data Requirement

Dictionary data is loaded only from:

- `assets/data/dictionary.json`

The app loads this JSON once through `dictionaryProvider` and keeps data in memory.

## JSON Entry Format

```json
{
  "id": 1,
  "word": "yɛ̈n",
  "definition": "exact meaning from PDF",
  "examples": "if available",
  "partOfSpeech": "noun/adjective/etc",
  "synonyms": "if available",
  "dialects": "original dialect text",
  "searchKey": "yen",
  "rawEntry": "full original entry"
}
```

> Keep `word` exactly as it appears in source PDF. Do not normalize or alter Dinka characters.

## Extracting JSON from PDF

Script:

- `scripts/extract_dictionary.py`

Install dependency:

```bash
pip install pdfplumber
```

Usage:

```bash
python scripts/extract_dictionary.py --input dictionary.pdf --output assets/data/dictionary.json
```

Behavior:

- Preserves UTF-8 text (`ensure_ascii=False`)
- Handles multiline definitions
- Creates parse warning log for problematic lines

## Replace Sample Data with Real PDF

1. Put your PDF at project root (example: `dictionary.pdf`).
2. Run extraction script command above.
3. Verify `assets/data/dictionary.json` contains exact Dinka words.
4. Run `flutter run` and test search + details navigation.

## Tests

Includes tests for:

- Data loading
- Search behavior
- Route definitions
- Word index switching support
