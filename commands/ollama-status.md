---
name: ollama-status
description: Show an Ollama status dashboard with version, running models, and total local model count
allowed-tools: Bash(curl *)
---

Toon een actueel overzicht van de Ollama status op de Linux workstation (192.168.1.28:11434).

Voer de volgende curl calls uit en verwerk ze:

1. **Versie**:
   !`curl -s --max-time 5 http://192.168.1.28:11434/api/version`

2. **Draaiende modellen**:
   !`curl -s --max-time 5 http://192.168.1.28:11434/api/ps`

3. **Totaal aantal lokale modellen**:
   !`curl -s --max-time 5 http://192.168.1.28:11434/api/tags | python3 -c "import sys,json; models=json.load(sys.stdin).get('models',[]); print(f'{len(models)} modellen totaal')"`

4. **Schijfgebruik modellen**:
   !`curl -s --max-time 5 http://192.168.1.28:11434/api/tags | python3 -c "
import sys, json
models = json.load(sys.stdin).get('models', [])
total_bytes = sum(m.get('size', 0) for m in models)
print(f'{total_bytes / (1024**3):.1f} GB totaal op schijf')
"`

Presenteer de resultaten in een overzichtelijk dashboard met deze secties:

**Ollama Status Dashboard**
- Versie: `<version>`
- Draaiende modellen: tabel met naam, VRAM (in GB), context_length, expires_at
  - Als er geen modellen draaien: "Geen modellen in geheugen geladen"
- Modellen: `<aantal>` modellen, `<totaal GB>` op schijf

Als curl faalt met "Connection refused" of timeout, rapporteer dan: "Ollama op 192.168.1.28 is niet bereikbaar. Check of de workstation aan staat en de ollama service draait."
