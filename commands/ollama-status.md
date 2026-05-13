---
name: ollama-status
description: Show an Ollama status dashboard with version, running models, and total local model count
allowed-tools: Bash(curl *)
---

Toon een actueel overzicht van de Ollama status.

De Ollama host wordt bepaald door de `OLLAMA_HOST` omgevingsvariabele (default: `http://localhost:11434`).

Voer de volgende curl calls uit en verwerk ze met `${OLLAMA_HOST:-http://localhost:11434}`:

1. **Versie**:
   !`curl -s --max-time 5 ${OLLAMA_HOST:-http://localhost:11434}/api/version`

2. **Draaiende modellen**:
   !`curl -s --max-time 5 ${OLLAMA_HOST:-http://localhost:11434}/api/ps`

3. **Totaal aantal lokale modellen**:
   !`curl -s --max-time 5 ${OLLAMA_HOST:-http://localhost:11434}/api/tags | python3 -c "import sys,json; models=json.load(sys.stdin).get('models',[]); print(f'{len(models)} modellen totaal')"`

4. **Schijfgebruik modellen**:
   !`curl -s --max-time 5 ${OLLAMA_HOST:-http://localhost:11434}/api/tags | python3 -c "
import sys, json
models = json.load(sys.stdin).get('models', [])
total_bytes = sum(m.get('size', 0) for m in models)
print(f'{total_bytes / (1024**3):.1f} GB totaal op schijf')
"`

Presenteer de resultaten in een overzichtelijk dashboard met deze secties:

**Ollama Status Dashboard**
- Host: `<host>`
- Versie: `<version>`
- Draaiende modellen: tabel met naam, VRAM (in GB), context_length, expires_at
  - Als er geen modellen draaien: "Geen modellen in geheugen geladen"
- Modellen: `<aantal>` modellen, `<totaal GB>` op schijf

Als curl faalt met "Connection refused" of timeout: "Ollama op <host> is niet bereikbaar. Controleer of de host bereikbaar is en de ollama service draait."
