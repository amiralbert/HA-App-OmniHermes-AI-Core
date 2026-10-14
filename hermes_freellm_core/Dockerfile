FROM nousresearch/hermes-agent:latest

USER root
# Install required packages
RUN apt-get update && \
    apt-get install -y jq git python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install LiteLLM (--break-system-packages prevents blocks on modern Linux)
RUN pip3 install --no-cache-dir litellm --break-system-packages

WORKDIR /
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]