# workstation-ollama

Claude Code plugin voor Ollama modelbeheer via de REST API.

## Configuratie

De Ollama host wordt ingesteld via de `OLLAMA_HOST` omgevingsvariabele:

```bash
# Default (localhost)
export OLLAMA_HOST=http://localhost:11434

# Of naar een remote host (bijv. Linux workstation op LAN)
export OLLAMA_HOST=http://192.168.1.28:11434
```

Zet dit in je `~/.zshrc` of `~/.bashrc` voor permanente configuratie.

## Commands

| Command | Beschrijving |
|---|---|
| `/ollama-status` | Dashboard: host, versie, draaiende modellen, schijfgebruik |
| `/ollama-models [naam]` | Alle modellen of details van een specifiek model |
| `/ollama-pull <model>` | Model downloaden |
| `/ollama-chat <model> <prompt>` | One-shot chat met een model |
| `/ollama-embed <model> <text>` | Embeddings genereren uit tekst |

## Agent

`ollama-admin` — Autonoom model lifecycle beheer. Triggered bij vragen over modellen, status, of downloads. **Let op**: delete/copy/create/push operaties worden expliciet geweigerd; de agent verwijst door naar directe CLI.

## Installatie

```bash
mkdir -p ~/.claude/plugins
cd ~/.claude/plugins
git clone git@github.com:djimit/workstation-ollama.git
```

Na installatie: **herstart Claude Code** om de plugin te laden.

## Vereisten

- Een draaiende Ollama instance, lokaal of remote
- `Bash(curl *)` permissie in `~/.claude/settings.local.json`
- Optioneel: `OLLAMA_HOST` env var als je niet tegen localhost praat

## Structuur

```
workstation-ollama/
├── .claude-plugin/plugin.json
├── commands/
│   ├── ollama-status.md
│   ├── ollama-models.md
│   ├── ollama-pull.md
│   ├── ollama-chat.md
│   └── ollama-embed.md
├── agents/
│   └── ollama-admin.md
└── scripts/
    └── health-check.sh
```
