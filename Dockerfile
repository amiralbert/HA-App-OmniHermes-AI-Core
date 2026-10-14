FROM nousresearch/hermes-agent:latest

USER root
# jq und git installieren
RUN apt-get update && \
    apt-get install -y jq git && \
        rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/diegosouzapw/omniroute.git /opt/omniroute
WORKDIR /opt/omniroute
RUN npm install

WORKDIR /
# Der gesamte Inhalt des lokalen rootfs-Ordners wird in den Container kopiert
COPY rootfs /

# Mache die run.sh (die nun im Container unter /run.sh liegt) ausführbar
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
