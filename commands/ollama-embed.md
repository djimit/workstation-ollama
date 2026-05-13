---
name: ollama-embed
description: Generate vector embeddings from text using an Ollama embedding model
argument-hint: "<model> <text>"
allowed-tools: Bash(curl *)
---

Genereer vector embeddings van tekst met een Ollama embedding model op de Linux workstation (192.168.1.28:11434).

De standaard embedding model is `nomic-embed-text` (768 dimensies).

## Als argumenten ontbreken

Als $1 leeg is: "Geef een embedding model op. Gebruik 'nomic-embed-text' voor 768-dim embeddings, of een ander embedding model."

Als $2 leeg is: "Geef tekst op om te embedden."

Toon usage: "/ollama-embed <model> <text>"

## Embedding genereren

!`curl -s --max-time 30 -X POST http://192.168.1.28:11434/api/embed -d '{"model": "'$1'", "input": "'$2'"}' | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'error' in data:
        print(f'ERROR: {data[\"error\"]}')
        sys.exit(0)
    embeddings = data.get('embeddings', [[]])
    model = data.get('model', '?')
    prompt_eval_count = data.get('prompt_eval_count', 0)
    total_duration = data.get('total_duration', 0)
    vec = embeddings[0] if embeddings else []
    dim = len(vec)
    print(f'Model: {model}')
    print(f'Dimensies: {dim}')
    print(f'Tokens (input): {prompt_eval_count}')
    print(f'Tijd: {total_duration / 1e6:.1f} ms')
    print()
    print('Eerste 5 waarden:', [round(v, 6) for v in vec[:5]])
    print('Laatste 5 waarden:', [round(v, 6) for v in vec[-5:]])
    print(f'Waardenbereik: [{min(vec):.4f}, {max(vec):.4f}]')
except Exception as e:
    print(f'Error: {e}')
"`

## Edge cases

- Als de response "ERROR" bevat: toon de fout, suggereer een ander model (niet alle modellen ondersteunen embeddings)
- Voor batch embeddings: "Dit endpoint ondersteunt ook batch input. Vraag het mij als je meerdere teksten tegelijk wilt embedden — dan stuur ik een array van strings."
- Als de embedding leeg is: "Embedding model '$1' gaf een lege vector terug. Gebruik een dedicated embedding model zoals 'nomic-embed-text'."
