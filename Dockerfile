FROM femtopixel/google-lighthouse

# 安裝 jq
USER root
RUN rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install -y jq

# 設置工作目錄
WORKDIR /home/chrome

# 將處理腳本添加到 image 中
COPY entrypoint.sh /home/chrome/entrypoint.sh
RUN chmod +x /home/chrome/entrypoint.sh

USER chrome

# 預設的啟動命令
ENTRYPOINT ["/home/chrome/entrypoint.sh"]
