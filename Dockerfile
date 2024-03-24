FROM python:3.6-alpine

WORKDIR /pb
ADD . /build

RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.15/main" > /etc/apk/repositories && \
    echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.15/community" >> /etc/apk/repositories && \
    apk add --no-cache --virtual .fetch-deps curl

RUN if curl -s ipinfo.io | grep '"country": "CN"' > /dev/null; then \
        pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; \
    else \
        echo "https://dl-cdn.alpinelinux.org/alpine/v3.15/main" > /etc/apk/repositories && \
        echo "https://dl-cdn.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories; \
    fi

RUN apk add --no-cache --virtual .build-deps git && \
    pip install /build && \
    apk del .fetch-deps .build-deps

CMD ["python", "-m", "pb"]
