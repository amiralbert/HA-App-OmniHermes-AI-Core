#!/bin/bash
set -euo pipefail

echo "=== Initialisiere Kombi-App: OmniHermes AI Core ==="

# 1) Persistente Datenbereiche anlegen
mkdir -p /data/hermes_memory
mkdir -p /data/omniroute_data
mkdir -p /data/workspaces

# 2) Optionale Laufzeitdaten konfigurieren
OPTIONS_FILE="/data/options.json"

if [ -f "$OPTIONS_FILE" ]; then
    START_MODE=$(jq -r '.start_mode // "dashboard"' "$OPTIONS_FILE")
    OPENROUTER_KEY=$(jq -r '.openrouter_api_key // empty' "$OPTIONS_FILE")
    GIT_USER=$(jq -r '.git_username // empty' "$OPTIONS_FILE")
    GIT_EMAIL=$(jq -r '.git_email // empty' "$OPTIONS_FILE")
    GIT_TOKEN=$(jq -r '.git_token // empty' "$OPTIONS_FILE")
    CUSTOM_WS=$(jq -r '.hermes_workspaces // empty' "$OPTIONS_FILE")
else
    START_MODE="dashboard"
    OPENROUTER_KEY=""
    GIT_USER=""
    GIT_EMAIL=""
    GIT_TOKEN=""
    CUSTOM_WS=""
fi

# 3) Links für /opt/data und /opt/omniroute/data
rm -rf /opt/data
ln -s /data/hermes_memory /opt/data

rm -rf /opt/omniroute/data
ln -s /data/omniroute_data /opt/omniroute/data

# 4) Workspaces anlegen
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

# 5) Git konfigurieren
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"

    if [ -n "$GIT_TOKEN" ]; then
        git config --global credential.helper store
        printf "https://%s:%s@github.com\n" "$GIT_USER" "$GIT_TOKEN" > ~/.git-credentials
        chmod 600 ~/.git-credentials
    fi
fi

# 6) OpenRouter-Env setzen
if [ -n "$OPENROUTER_KEY" ]; then
    export OPENROUTER_API_KEY="$OPENROUTER_KEY"
fi

# 7) Startmodus setzen
export START_MODE="$START_MODE"

# 8) Wichtig: echten Foreground-Prozess starten
# Das hängt davon ab, was im Base-Image / der App laut package oder Dockerfile wirklich läuft.
# Wenn du den eigentlichen Startbefehl kennst, muss hier "exec ..." stehen.
# Beispiel:
#
# cd /opt/omniroute
# exec npm start
#
# oder:
# exec /usr/local/bin/your-app --port 9119
#
# Ohne den echten Startbefehl ist der Container nicht sauber lauffähig.

cd /opt/omniroute
exec npm start