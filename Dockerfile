FROM femtopixel/google-lighthouse

# 安裝 jq
USER root
RUN rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install -y jq

WORKDIR /home/chrome
COPY entrypoint.sh /home/chrome/entrypoint.sh
RUN chmod +x /home/chrome/entrypoint.sh

USER chrome

CMD ["/home/chrome/entrypoint.sh"]
