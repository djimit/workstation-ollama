---
name: ollama-chat
description: Send a one-shot prompt to an Ollama model and display the response
argument-hint: "<model> <prompt>"
allowed-tools: Bash(curl *)
---

Stuur een one-shot prompt naar een Ollama model.

De Ollama host wordt bepaald door de `OLLAMA_HOST` omgevingsvariabele (default: `http://localhost:11434`).

## Als $1 of $2 leeg is

Toon:
"Gebruik: /ollama-chat <model> <prompt>

Voorbeeld: /ollama-chat llama3.1:8b Wat is de hoofdstad van Frankrijk?"

## Als beide argumenten aanwezig zijn

Stuur de chat request met stream=false voor een enkel antwoord:

!`curl -s --max-time 120 -X POST ${OLLAMA_HOST:-http://localhost:11434}/api/chat -d '{"model": "'$1'", "messages": [{"role": "user", "content": "'$2'"}], "stream": false}' | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    msg = data.get('message', {})
    content = msg.get('content', '')
    model = data.get('model', '')
    eval_count = data.get('eval_count', 0)
    eval_duration = data.get('eval_duration', 0)
    tokens_per_sec = eval_count / (eval_duration / 1e9) if eval_duration > 0 else 0
    print(content)
    print()
    print(f'[{model}] {eval_count} tokens, {tokens_per_sec:.0f} tok/s')
except Exception as e:
    print(f'Error: {e}')
"`

Als de response "Error" bevat of leeg is:
- Check of het model bestaat met `/ollama-models`
- Als het model niet draait kan er koude-start vertraging zijn

## Response bevat error field

Als de JSON een `error` veld bevat, toon de foutmelding en suggereer: "Controleer of het model beschikbaar is met /ollama-models"
