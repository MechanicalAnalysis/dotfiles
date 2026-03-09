#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Carrega .env
if [[ -f "$SCRIPT_DIR/.env" ]]; then
  source "$SCRIPT_DIR/.env"
else
  echo "❌ Arquivo .env não encontrado"
  exit 1
fi

if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "❌ OPENAI_API_KEY não definida"
  exit 1
fi

MODEL="gpt-5-mini"

# pasta de histórico
HISTORY_DIR="$SCRIPT_DIR/history"
mkdir -p "$HISTORY_DIR"

list_chats() {
  echo ""
  echo "📂 Chats disponíveis:"
  i=1
  for file in "$HISTORY_DIR"/*.json; do
      [[ -e "$file" ]] || { echo "Nenhum chat encontrado."; return; }
      name=$(basename "$file" .json)
      echo "$i - $name"
      ((i++))
  done
  echo ""
}

open_chat() {

  read -p "Digite o número do chat: " NUM

  FILE=$(ls "$HISTORY_DIR"/*.json 2>/dev/null | sed -n "${NUM}p")

  if [[ -z "$FILE" ]]; then
      echo "❌ Chat inválido"
      return
  fi

  HISTORY_FILE="$FILE"
  MESSAGES=$(cat "$FILE")
  FIRST_MESSAGE=false

  echo "✅ Chat carregado: $(basename "$FILE" .json)"
}

MESSAGES="[]"
FIRST_MESSAGE=true
HISTORY_FILE=""

echo "╔══════════════════════════════════╗"
echo "║   Chat Terminal – $MODEL         ║"
echo "║   LISTAR / ABRIR / sair          ║"
echo "╚══════════════════════════════════╝"
echo ""

while true; do

  printf "\033[1;32mVocê:\033[0m "
  read -er USER_INPUT
  
  if [[ "$USER_INPUT" == "LISTAR" ]]; then
    list_chats
    continue
  fi

  if [[ "$USER_INPUT" == "ABRIR" ]]; then
    list_chats
    open_chat
    continue
  fi

  [[ "$USER_INPUT" == "sair" ]] && echo "👋 Até logo!" && break
  [[ -z "$USER_INPUT" ]] && continue

  # cria nome do chat na primeira pergunta
  if $FIRST_MESSAGE; then

    CHAT_NAME=$(echo "$USER_INPUT" \
      | head -c 50 \
      | tr '[:upper:]' '[:lower:]' \
      | sed 's/[^a-z0-9 ]//g' \
      | tr ' ' '_')

    HISTORY_FILE="$HISTORY_DIR/${CHAT_NAME}.json"

    if [[ -f "$HISTORY_FILE" ]]; then
        MESSAGES=$(cat "$HISTORY_FILE")
    else
        MESSAGES="[]"
    fi

    FIRST_MESSAGE=false
  fi

  # adiciona pergunta
  MESSAGES=$(echo "$MESSAGES" | jq \
    --arg content "$USER_INPUT" \
    '. + [{"role":"user","content":$content}]')

  RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$(jq -n \
      --arg model "$MODEL" \
      --argjson messages "$MESSAGES" \
      '{model:$model, messages:$messages}')")

  REPLY=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty')

  if [[ -z "$REPLY" ]]; then
      ERROR=$(echo "$RESPONSE" | jq -r '.error.message // "Erro desconhecido"')
      echo "❌ Erro da API: $ERROR"
      continue
  fi

  # adiciona resposta
  MESSAGES=$(echo "$MESSAGES" | jq \
    --arg content "$REPLY" \
    '. + [{"role":"assistant","content":$content}]')

  # salva histórico
  echo "$MESSAGES" > "$HISTORY_FILE"

  echo ""
  printf "\033[1;34mAssistente:\033[0m\n\n"

  printf "%s\n" "$REPLY" | glow -

  echo ""

done
