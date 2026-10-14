#!/bin/bash
set -e

echo "=== Initialisiere Kombi-App: Hermes & FreeLLM Core ==="

# 1. Persistent storage
mkdir -p /data/hermes_memory
mkdir -p /opt/data

# Workaround for strict docker volumes
cp -a /data/hermes_memory/. /opt/data/ 2>/dev/null || true
(
    while true; do
        sleep 60
        cp -a /opt/data/. /data/hermes_memory/ 2>/dev/null || true
    done
) &

# 2. Parse HA Options
OPTIONS_FILE="/data/options.json"
if [ -f "$OPTIONS_FILE" ]; then
    START_MODE=$(jq -r '.start_mode // "dashboard"' "$OPTIONS_FILE")
    DEFAULT_MODEL=$(jq -r '.default_model // "groq/llama-3.3-70b-versatile"' "$OPTIONS_FILE")

    GROQ_KEY=$(jq -r '.groq_api_key // empty' "$OPTIONS_FILE")
    GEMINI_KEY=$(jq -r '.gemini_api_key // empty' "$OPTIONS_FILE")
    GITHUB_TOK=$(jq -r '.github_token // empty' "$OPTIONS_FILE")

    GIT_USER=$(jq -r '.git_username // empty' "$OPTIONS_FILE")
    GIT_EMAIL=$(jq -r '.git_email // empty' "$OPTIONS_FILE")
    GIT_TOKEN=$(jq -r '.git_token // empty' "$OPTIONS_FILE")
    CUSTOM_WS=$(jq -r '.hermes_workspaces // empty' "$OPTIONS_FILE")
    HERMES_PASS=$(jq -r '.hermes_password // "admin"' "$OPTIONS_FILE")
else
    START_MODE="dashboard"
    DEFAULT_MODEL="groq/llama-3.3-70b-versatile"
    HERMES_PASS="admin"
fi

# 3. Hermes Authentication
echo "Setze Hermes Dashboard Passwort..."
mkdir -p /opt/data/.hermes
PASS_HASH=$(python3 -c "import bcrypt; print(bcrypt.hashpw(b'$HERMES_PASS', bcrypt.gensalt()).decode())")
cat <<EOF > /opt/data/.hermes/config.yaml
dashboard:
  basic_auth:
    username: "admin"
    password_hash: "$PASS_HASH"
EOF

# 4. Workspaces setup
WORKSPACE_BASE="/data/workspaces"
HERMES_WS_BASE="$WORKSPACE_BASE/hermes_workspaces"
HA_WS_DIR="$WORKSPACE_BASE/home_assistant_workspace"
mkdir -p "$HERMES_WS_BASE" "$HA_WS_DIR"

if [ -n "$CUSTOM_WS" ]; then
    IFS=',' read -ra WS_ARRAY <<< "$CUSTOM_WS"
    for ws in "${WS_ARRAY[@]}"; do
        ws_clean=$(echo "$ws" | xargs)
        if [ -n "$ws_clean" ]; then
            mkdir -p "$HERMES_WS_BASE/$ws_clean"
        fi
    done
fi
ln -sfn "$WORKSPACE_BASE" /opt/workspaces

# 5. Git configuration
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"
    if [ -n "$GIT_TOKEN" ]; then
        git config --global credential.helper store
        echo "https://${GIT_USER}:${GIT_TOKEN}@github.com" > ~/.git-credentials
        echo "https://${GIT_USER}:${GIT_TOKEN}@gitlab.com" >> ~/.git-credentials
        chmod 600 ~/.git-credentials
    fi
fi

# 6. LiteLLM Environment Variables
if [ -n "$GROQ_KEY" ]; then export GROQ_API_KEY="$GROQ_KEY"; fi
if [ -n "$GEMINI_KEY" ]; then export GEMINI_API_KEY="$GEMINI_KEY"; fi
if [ -n "$GITHUB_TOK" ]; then export GITHUB_API_KEY="$GITHUB_TOK"; fi

# 7. Start Mode
if [ "$START_MODE" == "gateway" ]; then
    HERMES_ARGS="gateway run"
else
    HERMES_ARGS="dashboard --host 0.0.0.0 --no-open"
fi

export OPENAI_BASE_URL="http://127.0.0.1:8000/v1"
export OPENAI_API_BASE="http://127.0.0.1:8000/v1"
export OPENAI_API_KEY="litellm-local-key"

# 8. Start Services
echo "Fahre lokales LiteLLM Gateway hoch (Modell: $DEFAULT_MODEL)..."
litellm --port 8000 --model "$DEFAULT_MODEL" &

sleep 5

echo "Starte Hermes Agent..."
export HERMES_
UID=0
export HERMES_GID=0

eval "set -- $HERMES_ARGS"
exec /init /opt/hermes/docker/main-wrapper.sh "$@"