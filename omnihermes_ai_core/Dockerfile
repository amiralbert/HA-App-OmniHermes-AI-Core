FROM nousresearch/hermes-agent:latest

USER root

# 1. Systempakete für den Build und curl installieren
RUN apt-get update && \
    apt-get install -y jq git python3 build-essential pkg-config libsecret-1-dev curl && \
    rm -rf /var/lib/apt/lists/*

# 2. Node.js downgraden auf die stabile LTS-Version (z.B. v22)
# Dies behebt die v8-external.h Kompilierungsfehler von Node 26
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# 3. OmniRoute klonen
RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute

# 4. Vollständige Installation aller Abhängigkeiten
RUN npm install

# 5. Native Abhängigkeiten explizit zulassen (npm Workaround)
RUN npm install better-sqlite3 sqlite-vec keytar wreq-js @huggingface/transformers --no-save --foreground-scripts

# 6. Kompilieren
RUN npm run build

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
