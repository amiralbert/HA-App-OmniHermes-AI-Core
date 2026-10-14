#!/bin/bash
set -e

echo "=== Initialisiere Kombi-App: OmniHermes AI Core ==="

# 1. Basis-Speicher persistent machen
mkdir -p /data/hermes_memory
mkdir -p /data/omniroute_data
mkdir -p /opt/data

# Workaround für festes Docker-Volume (Auto-Sync)
cp -a /data/hermes_memory/. /opt/data/ 2>/dev/null || true
(
    while true; do
        sleep 60
        cp -a /opt/data/. /data/hermes_memory/ 2>/dev/null || true
    done
) &

# OmniRoute Speicher umleiten
rm -rf /root/.omniroute 2>/dev/null || true
ln -s /data/omniroute_data /root/.omniroute

# 2. HA-Optionen per jq auslesen
OPTIONS_FILE="/data/options.json"
if [ -f "$OPTIONS_FILE" ]; then
    START_MODE=$(jq -r '.start_mode // "dashboard"' "$OPTIONS_FILE")
    OPENROUTER_KEY=$(jq -r '.openrouter_api_key // empty' "$OPTIONS_FILE")
    GIT_USER=$(jq -r '.git_username // empty' "$OPTIONS_FILE")
    GIT_EMAIL=$(jq -r '.git_email // empty' "$OPTIONS_FILE")
    GIT_TOKEN=$(jq -r '.git_token // empty' "$OPTIONS_FILE")
    CUSTOM_WS=$(jq -r '.hermes_workspaces // empty' "$OPTIONS_FILE")
    HERMES_PASS=$(jq -r '.hermes_password // "admin"' "$OPTIONS_FILE")
else
    START_MODE="dashboard"
    HERMES_PASS="admin"
fi

# 3. Hermes Authentifizierung erzwingen (Behebt den Absturz!)
echo "Setze Hermes Dashboard Passwort..."
mkdir -p /opt/data/.hermes
# Generiere den bcrypt Hash über Python, wie von Hermes gefordert
PASS_HASH=$(python3 -c "import bcrypt; print(bcrypt.hashpw(b'$HERMES_PASS', bcrypt.gensalt()).decode())")

# Erstelle oder überschreibe die Hermes config.yaml
cat <<EOF > /opt/data/.hermes/config.yaml
dashboard:
  basic_auth:
    username: "admin"
    password_hash: "$PASS_HASH"
EOF

# 4. Workspaces anlegen
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

# 5. Git global konfigurieren
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"
    if [ -n "$GIT_TOKEN" ]; then
        git config --global credential.helper store
        echo "https://${GIT_USER}:${GIT_TOKEN}@github.com" > ~/.git-credentials
        chmod 600 ~/.git-credentials
    fi
fi

# 6. Dienste starten
export DISABLE_SQLITE_AUTO_BACKUP="true"
export PORT=20128
export INITIAL_PASSWORD="omnihermes"

if [ -n "$OPENROUTER_KEY" ]; then
    export OPENROUTER_API_KEY="$OPENROUTER_KEY"
fi

if [ "$START_MODE" = "gateway" ]; then
    HERMES_ARGS="gateway run"
else
    HERMES_ARGS="dashboard --host 0.0.0.0 --no-open"
fi

export OPENAI_BASE_URL="http://127.0.0.1:${PORT}/v1"
export OPENAI_API_BASE="http://127.0.0.1:${PORT}/v1"
export OPENAI_API_KEY="omniroute-local-key" 

echo "Fahre lokales OmniRoute Gateway hoch..."
cd /opt/omniroute
# Starte OmniRoute mit Fehlerunterdrückung
(npm start || echo "OmniRoute start failed") &

sleep 5

echo "Starte Hermes Agent..."
export HERMES_UID=0
export HERMES_GID=0

eval "set -- $HERMES_ARGS"
exec /init /opt/hermes/docker/main-wrapper.sh "$@"
