# workstation-ollama

Claude Code plugin voor Ollama modelbeheer op de Linux workstation (192.168.1.28:11434).

## Commands

| Command | Beschrijving |
|---|---|
| `/ollama-status` | Dashboard: versie, draaiende modellen, schijfgebruik |
| `/ollama-models [naam]` | Alle modellen of details van een specifiek model |
| `/ollama-pull <model>` | Model downloaden naar de workstation |
| `/ollama-chat <model> <prompt>` | One-shot chat met een model |
| `/ollama-embed <model> <text>` | Embeddings genereren uit tekst |

## Agent

`ollama-admin` — Autonoom model lifecycle beheer. Triggered bij vragen over modellen, status, of downloads. **Let op**: delete/copy/create/push operaties worden expliciet geweigerd; de agent verwijst door naar SSH.

## Installatie

```bash
# Op de Mac (waar je Claude Code draait)
mkdir -p ~/.claude/plugins
cd ~/.claude/plugins
git clone git@github.com:djimit/workstation-ollama.git
```

Na installatie: **herstart Claude Code** om de plugin te laden.

## Vereisten

- Ollama bereikbaar op `http://192.168.1.28:11434` (LAN)
- `Bash(curl *)` permissie in `~/.claude/settings.local.json`

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
