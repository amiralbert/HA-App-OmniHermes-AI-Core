# Stufe 1: Wir holen uns das bereits fertig kompilierte OmniRoute-Image
FROM diegosouzapw/omniroute:latest AS omniroute-base

# Stufe 2: Unser eigentliches Hermes-Agent Basis-Image
FROM nousresearch/hermes-agent:latest

USER root
# jq und git installieren
RUN apt-get update && \
    apt-get install -y jq git && \
    rm -rf /var/lib/apt/lists/*

# Wir kopieren den fertigen OmniRoute-Ordner (/app) aus Stufe 1 direkt in unseren Container
COPY --from=omniroute-base /app /opt/omniroute

WORKDIR /
# Skripte aus dem rootfs-Ordner in den Container kopieren
COPY rootfs /

# run.sh ausführbar machen
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
