---
name: ollama-models
description: List all local Ollama models or show detailed information about a specific model
argument-hint: "[model-name]"
allowed-tools: Bash(curl *)
---

Toon lokale Ollama modellen op de Linux workstation (192.168.1.28:11434).

## Als GEEN modelnaam is opgegeven ($1 is leeg)

Fetch de volledige modellenlijst en toon een tabel:

!`curl -s --max-time 5 http://192.168.1.28:11434/api/tags | python3 -c "
import sys, json
models = json.load(sys.stdin).get('models', [])
models.sort(key=lambda m: m.get('name', ''))
for m in models:
    name = m.get('name', '?')
    size_gb = m.get('size', 0) / (1024**3)
    params = (m.get('details') or {}).get('parameter_size', '?')
    quant = (m.get('details') or {}).get('quantization_level', '?')
    modified = m.get('modified_at', '?')[:10]
    print(f'{name}|{size_gb:.1f}|{params}|{quant}|{modified}')
"`

Als de lijst leeg is: "Geen modellen gevonden op de workstation. Gebruik /ollama-pull om er een te downloaden."

Toon als tabel met kolommen: **Model**, **Size (GB)**, **Params**, **Quant**, **Modified**.

## Als WEL een modelnaam is opgegeven ($1 is niet leeg)

Fetch details van dit specifieke model:

!`curl -s --max-time 10 -X POST http://192.168.1.28:11434/api/show -d "{\"model\": \"$1\"}"`

Toon deze informatie in secties:
- **Model**: naam, parameter_size, quantization_level, format, family
- **Capabilities**: de `capabilities` array (bijv. completion, vision)
- **Context**: context_length (uit model_info als beschikbaar)
- **License**: eerste 200 karakters van de license
- **Parameters**: de `parameters` string (key model parameters)
- **Template**: "aanwezig" (zonder de hele template te tonen, tenzij expliciet gevraagd)

Als de response een error bevat (bijv. `"error": "model '...' not found"`):
- Toon: "Model '$1' niet gevonden op de workstation."
- Suggestie: "Gebruik /ollama-models zonder argumenten om beschikbare modellen te zien."
