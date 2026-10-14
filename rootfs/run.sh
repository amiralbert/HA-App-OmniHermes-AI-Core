#!/bin/bash
set -e

echo "=== Initialisiere Kombi-App: OmniHermes AI Core ==="

# 1. Basis-Speicher persistent machen
mkdir -p /data/hermes_memory
rm -rf /opt/data
ln -s /data/hermes_memory /opt/data

mkdir -p /data/omniroute_data
rm -rf /opt/omniroute/data
ln -s /data/omniroute_data /opt/omniroute/data

# 2. HA-Optionen per jq auslesen (leere Felder abfangen)
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
                                    fi

                                    # 3. Workspaces anlegen (Persistent im /data-Bereich von Home Assistant)
                                    echo "Richte persistente Workspaces ein..."
                                    WORKSPACE_BASE="/data/workspaces"
                                    HERMES_WS_BASE="$WORKSPACE_BASE/hermes_workspaces"
                                    HA_WS_DIR="$WORKSPACE_BASE/home_assistant_workspace"

                                    # Hauptordner erstellen
                                    mkdir -p "$HERMES_WS_BASE"
                                    mkdir -p "$HA_WS_DIR"

                                    # Dynamische Hermes-Workspaces aus der UI (kommagetrennt) anlegen
                                    if [ -n "$CUSTOM_WS" ]; then
                                        IFS=',' read -ra WS_ARRAY <<< "$CUSTOM_WS"
                                            for ws in "${WS_ARRAY[@]}"; do
                                                    # Führende und nachfolgende Leerzeichen entfernen
                                                            ws_clean=$(echo "$ws" | xargs)
                                                                    if [ -n "$ws_clean" ]; then
                                                                                mkdir -p "$HERMES_WS_BASE/$ws_clean"
                                                                                            echo "Hermes Workspace angelegt: $HERMES_WS_BASE/$ws_clean"
                                                                                                    fi
                                                                                                        done
                                                                                                        fi

                                                                                                        # Verknüpfung erstellen, damit Hermes im Root-Verzeichnis sofort Zugriff hat
                                                                                                        ln -sfn "$WORKSPACE_BASE" /opt/workspaces

                                                                                                        # 4. Git global konfigurieren
                                                                                                        if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
                                                                                                            echo "Konfiguriere Git für Benutzer: $GIT_USER"
                                                                                                                git config --global user.name "$GIT_USER"
                                                                                                                    git config --global user.email "$GIT_EMAIL"
                                                                                                                        
                                                                                                                            if [ -n "$GIT_TOKEN" ]; then
                                                                                                                                    # Speichere das Token für automatische Authentifizierung (GitHub/GitLab)
                                                                                                                                            git config --global credential.helper store
                                                                                                                                                    # ~/.git-credentials für Root anlegen, damit autonome push/pulls ohne Passwort-Prompt durchlaufen
                                                                                                                                                            echo "https://${GIT_USER}:${GIT_TOKEN}@github.com" > ~/.git-credentials
                                                                                                                                                                    echo "https://${GIT_USER}:${GIT_TOKEN}@gitlab.com" >> ~/.git-credentials
                                                                                                                                                                            chmod 600 ~/.git-credentials
                                                                                                                                                                                    echo "Git Credentials (Token) wurden sicher im Container hinterlegt."
                                                                                                                                                                                        fi
                                                                                                                                                                                        fi

                                                                                                                                                                                        # 5. Start-Modus und OmniRoute Konfiguration
                                                                                                                                                                                        export DISABLE_SQLITE_AUTO_BACKUP="true"
                                                                                                                                                                                        export PORT=20128

                                                                                                                                                                                        # OpenRouter API-Key immer exportieren, falls in der UI hinterlegt
                                                                                                                                                                                        if [ -n "$OPENROUTER_KEY" ]; then
                                                                                                                                                                                            export OPENROUTER_API_KEY="$OPENROUTER_KEY"
                                                                                                                                                                                            fi

                                                                                                                                                                                            # Startmodus auswerten
                                                                                                                                                                                            if [ "$START_MODE" == "gateway" ]; then
                                                                                                                                                                                                HERMES_ARGS="gateway run"
                                                                                                                                                                                                else
                                                                                                                                                                                                    HERMES_ARGS="dashboard --host 0.0.0.0 --no-open"
                                                                                                                                                                                                    fi

                                                                                                                                                                                                    # Hermes zwingen, den lokalen OmniRoute Gateway zu nutzen
                                                                                                                                                                                                    export OPENAI_BASE_URL="http://127.0.0.1:${PORT}/v1"
                                                                                                                                                                                                    export OPENAI_API_BASE="http://127.0.0.1:${PORT}/v1"
                                                                                                                                                                                                    export OPENAI_API_KEY="omniroute-local-key" 

                                                                                                                                                                                                    # 6. Dienste starten
                                                                                                                                                                                                    echo "Fahre lokales OmniRoute Gateway hoch..."
                                                                                                                                                                                                    cd /opt/omniroute
                                                                                                                                                                                                    npm start &

                                                                                                                                                                                                    # OmniRoute kurz Zeit zum Starten geben
                                                                                                                                                                                                    sleep 5

                                                                                                                                                                                                    echo "Starte Hermes Agent (Argumente: $HERMES_ARGS)..."
                                                                                                                                                                                                    export HERMES_UID=0
                                                                                                                                                                                                    export HERMES_GID=0

                                                                                                                                                                                                    eval "set -- $HERMES_ARGS"
                                                                                                                                                                                                    exec /init /opt/hermes/docker/main-wrapper.sh "$@"
                                                                                                                                                                                                    