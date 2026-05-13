#!/bin/bash
# Health check: is Ollama reachable?
HOST="${OLLAMA_HOST:-http://localhost:11434}"

if curl -s --connect-timeout 3 --max-time 5 "${HOST}/api/version" > /dev/null 2>&1; then
  VERSION=$(curl -s --max-time 5 "${HOST}/api/version" | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','unknown'))" 2>/dev/null)
  echo "Ollama healthy (v${VERSION}) at ${HOST}"
  exit 0
else
  echo "Ollama UNREACHABLE at ${HOST}"
  exit 1
fi
