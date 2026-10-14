FROM nousresearch/hermes-agent:latest

USER root
# Systempakete für den vollwertigen Build installieren
RUN apt-get update && \
    apt-get install -y jq git python3 build-essential pkg-config libsecret-1-dev && \
    rm -rf /var/lib/apt/lists/*

# OmniRoute klonen
RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute

# Vollständige Installation aller Abhängigkeiten
RUN npm install

# npm 11 Sicherheits-Workaround: Native Abhängigkeiten explizit zulassen
RUN npm install better-sqlite3 sqlite-vec keytar wreq-js @huggingface/transformers --no-save --foreground-scripts

# Kompilieren - OHNE RAM-Limitierung! 
RUN npm run build

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
