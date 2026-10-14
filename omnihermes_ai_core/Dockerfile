FROM nousresearch/hermes-agent:latest

USER root
# jq und git installieren
RUN apt-get update && \
    apt-get install -y jq git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute
RUN npm install

# NEU: Verhindert, dass dem Raspberry Pi der RAM ausgeht!
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm run build

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
