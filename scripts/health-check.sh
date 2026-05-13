#!/bin/bash
# Health check: is Ollama reachable at the workstation?
OLLAMA_HOST="http://192.168.1.28:11434"

if curl -s --connect-timeout 3 --max-time 5 "${OLLAMA_HOST}/api/version" > /dev/null 2>&1; then
  VERSION=$(curl -s --max-time 5 "${OLLAMA_HOST}/api/version" | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','unknown'))" 2>/dev/null)
  echo "Ollama healthy (v${VERSION}) at ${OLLAMA_HOST}"
  exit 0
else
  echo "Ollama UNREACHABLE at ${OLLAMA_HOST}"
  exit 1
fi
