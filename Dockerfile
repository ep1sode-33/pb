FROM python:3.6-alpine

WORKDIR /pb
ADD . /build

RUN set -eux; \
    apk add --no-cache --virtual .fetch-deps curl; \
    if curl -s ipinfo.io | grep '"country": "CN"' > /dev/null; then \
      echo "Using Chinese mirrors"; \
      # 设置 APK 使用清华大学镜像源（确保版本号正确）
      echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.15/main" > /etc/apk/repositories; \
      echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.15/community" >> /etc/apk/repositories; \
      pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; \
    else \
      echo "Not using Chinese mirrors"; \
    fi; \
    apk del .fetch-deps; \
    apk add --no-cache --virtual .build-deps git; \
    pip install /build; \
    apk del .build-deps

CMD ["python", "-m", "pb"]
