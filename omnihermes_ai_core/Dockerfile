FROM nousresearch/hermes-agent:latest

USER root
# Systempakete installieren (inkl. pkg-config und libsecret-1-dev für keytar)
RUN apt-get update && \
    apt-get install -y jq git python3 build-essential pkg-config libsecret-1-dev && \
    rm -rf /var/lib/apt/lists/*

# OmniRoute klonen
RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute

# Standard-Installation
RUN npm install

# npm 11 Workaround: Native Abhängigkeiten explizit mit Skript-Erlaubnis installieren
RUN npm install better-sqlite3 sqlite-vec keytar wreq-js @huggingface/transformers --no-save --foreground-scripts

# Bauen mit maximal 1 GB RAM (schützt den Raspberry Pi vor Abstürzen)
ENV NODE_OPTIONS="--max-old-space-size=1024"
RUN npm run build

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
