# kaamwaale_app

Anon Support Companion — a lightweight wellbeing app with anonymous chat and self-care tools.

## Features
- **Onboarding disclaimer** to set safety expectations.
- **Anonymous chat** with local Ollama endpoint fallback to a canned supportive reply.
- **Self-care tools**: 4-7-8 breathing timer, mood-tagged journal, gratitude notes (persists locally), and 5-4-3-2-1 grounding checklist.
- **Settings**: Dark-mode toggle (persisted) and region selector placeholder.

## Running locally
1. Ensure Flutter is installed and on a stable channel compatible with Dart 3.9+.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
4. Choose how you want chat replies:
   - **OpenAI (cloud)**: supply an API key at run time  
     ```bash
     flutter run --dart-define=OPENAI_API_KEY=sk-... --dart-define=OPENAI_MODEL=gpt-3.5-turbo
     ```  
     You can override the endpoint too: `--dart-define=OPENAI_BASE_URL=https://api.openai.com/v1/chat/completions`
   - **Local Ollama**: run a server on `http://localhost:11434` with a `llama3.2` model available.
   - If neither is reachable, the app cycles through empathetic canned responses.

## Notes
- Firebase packages are declared but the current UI paths run without authentication; initialize Firebase if you plan to re-enable the auth/profile flows.
- Data stored: dark-mode flag, onboarding completion, journal entries, and gratitude items (via `SharedPreferences`). No cloud storage is used.
