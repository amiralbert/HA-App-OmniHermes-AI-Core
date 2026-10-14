# Stufe 1: Wir laden das von den Entwicklern fertig kompilierte Image herunter
FROM diegosouzapw/omniroute:latest AS omniroute-base

# Stufe 2: Unser eigentliches Basis-Image für Hermes
FROM nousresearch/hermes-agent:latest

USER root
# jq und git installieren (ohne npm build!)
RUN apt-get update && \
    apt-get install -y jq git && \
    rm -rf /var/lib/apt/lists/*

# Wir kopieren den fertig gebauten Ordner (/app) aus Stufe 1 
# direkt in unseren Container als /opt/omniroute. 
# Kein "npm install" und kein "npm run build" nötig!
COPY --from=omniroute-base /app /opt/omniroute

WORKDIR /

# Deine lokalen rootfs Dateien rüberkopieren
COPY rootfs /

# Ausführungsrechte für das Startskript setzen
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
