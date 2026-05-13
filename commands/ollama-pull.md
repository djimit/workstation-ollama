---
name: ollama-pull
description: Pull (download) an Ollama model to the Linux workstation
argument-hint: "<model-name>"
allowed-tools: Bash(curl *)
---

Download een Ollama model naar de Linux workstation (192.168.1.28:11434).

## Validatie

Als $1 leeg is, toon:
"Geef een modelnaam op. Voorbeelden: llama3.1:8b, qwen3:14b, phi4:14b, gemma4:latest"
En toon de huidige modellen ter referentie.

## Eerst checken of het model al bestaat

!`curl -s --max-time 5 -X POST http://192.168.1.28:11434/api/show -d "{\"model\": \"$1\"}"`

Als het model al bestaat (geen error in response), meld: "Model '$1' bestaat al op de workstation." en toon de details.

## Downloaden

Als het model niet bestaat, start de pull:

!`curl -s --max-time 600 -X POST http://192.168.1.28:11434/api/pull -d "{\"model\": \"$1\", \"stream\": false}" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    status = data.get('status', 'geen status')
    print(status)
except:
    print('pull gestart — wacht op completion...')
"`

## Na de pull

Verifieer dat het model nu in de lijst staat:

!`curl -s --max-time 5 http://192.168.1.28:11434/api/tags | python3 -c "
import sys, json
models = json.load(sys.stdin).get('models', [])
names = [m['name'] for m in models]
target = '$1'
found = any(target == n for n in names)
print('gevonden' if found else 'niet-gevonden')
"`

Als "gevonden": "Model '$1' succesvol gedownload naar de workstation."
Als "niet-gevonden": "Download lijkt gestart maar model nog niet zichtbaar. Dit kan komen door timeout bij grote modellen. Probeer handmatig via SSH: `ssh djimit@192.168.1.28 ollama pull $1`"

## Timeout / grote modellen

Als de curl na ~120 seconden timeout:
"De download duurt langer dan verwacht. Grote modellen (70B+) kunnen 30+ minuten duren. Je kunt de voortgang volgen via SSH: `ssh djimit@192.168.1.28 ollama pull $1`"
