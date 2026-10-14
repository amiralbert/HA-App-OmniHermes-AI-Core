FROM nousresearch/hermes-agent:latest

USER root
# Systempakete installieren
RUN apt-get update && \
    apt-get install -y jq git python3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# OmniRoute klonen und mit harter Speicherbegrenzung installieren & bauen
RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute

# Installieren ohne optionalen Schnickschnack
RUN npm install --no-optional

# Bauen mit maximal 1 GB RAM (schützt den Pi)
ENV NODE_OPTIONS="--max-old-space-size=1024"
RUN npm run build

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
