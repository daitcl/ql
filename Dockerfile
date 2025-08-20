# 第一阶段: 构建 Chrome 和 ChromeDriver
FROM debian:bookworm-slim AS chrome-builder

# 安装必要的工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    gnupg \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 Google Chrome
RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable

# 安装 ChromeDriver - 简化版本
RUN CHROME_MAJOR_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1) \
    && echo "Chrome major version: $CHROME_MAJOR_VERSION" \
    && CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_MAJOR_VERSION") \
    && echo "ChromeDriver version: $CHROMEDRIVER_VERSION" \
    && curl -sS -o /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && unzip -q /tmp/chromedriver.zip -d /tmp/ \
    && mv /tmp/chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm -f /tmp/chromedriver.zip \
    && echo "ChromeDriver installed successfully."

# 第二阶段: 最终镜像
# 直接使用最新版本的基础镜像
FROM ghcr.io/whyour/qinglong:debian

# 设置环境变量
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:99 \
    CHROME_BIN=/usr/bin/google-chrome \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver

# 从第一阶段复制 Chrome 和 ChromeDriver
COPY --from=chrome-builder /opt/google/chrome/ /opt/google/chrome/
COPY --from=chrome-builder /usr/bin/google-chrome /usr/bin/google-chrome
COPY --from=chrome-builder /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable
COPY --from=chrome-builder /usr/bin/chromedriver /usr/bin/chromedriver

# 创建符号链接
RUN ln -sf /opt/google/chrome/google-chrome /usr/bin/google-chrome

# 安装运行时依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python Selenium 库
RUN pip3 install --no-cache-dir selenium

# 创建必要的目录和权限设置
RUN mkdir -p /home/qinglong/.cache/google-chrome && \
    chmod -R 777 /home/qinglong/.cache && \
    chmod -R 777 /opt/google/chrome

# 保持原始入口点
ENTRYPOINT ["./docker/docker-entrypoint.sh"]

# 保持原始工作目录
WORKDIR /ql

# 暴露端口
EXPOSE 5700

# 声明卷
VOLUME ["/ql/data"]

# 健康检查
HEALTHCHECK --interval=5s --timeout=2s --start-period=0s --retries=3 \
    CMD curl -sf --noproxy '*' http://127.0.0.1:5400/api/health || exit 1