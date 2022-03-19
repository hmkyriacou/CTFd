FROM python:3.7-slim-buster
WORKDIR /opt/CTFd
RUN mkdir -p /opt/CTFd /var/log/CTFd /var/uploads

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libffi-dev \
        libssl-dev \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/CTFd/

RUN pip install -r requirements.txt --no-cache-dir

COPY . /opt/CTFd

# hadolint ignore=SC2086
RUN for d in CTFd/plugins/*; do \
        if [ -f "$d/requirements.txt" ]; then \
            pip install -r $d/requirements.txt --no-cache-dir; \
        fi; \
    done;

RUN adduser \
    --disabled-login \
    -u 1001 \
    --gecos "" \
    --shell /bin/bash \
    ctfd
RUN chmod +x /opt/CTFd/docker-entrypoint.sh \
    && chown -R 1001:1001 /opt/CTFd /var/log/CTFd /var/uploads

# Set Enviorment Variables
ENV SECRET_KEY=a4J6WWq0kRxY
ENV OAUTH_PROVIDER=ctftime
ENV OAUTH_CALLBACK_ENDPOINT=http://ctf.wpictf.xyz/redirect
ENV UPLOAD_FOLDER=/var/uploads
#ENV DATABASE_URL=mysql+pymysql://ctfd:LApMhnZXG7hdA4B62Zcy@34.139.215.203/ctfd
#ENV REDIS_URL=redis://172.26.160.3:6379
ENV WORKERS=1
ENV LOG_FOLDER=/var/log/CTFd
ENV ACCESS_LOG=ENV
ENV ERROR_LOG=ENV
ENV REVERSE_PROXY=true
ENV OAUTH_CLIENT_ID=1208
ENV OAUTH_CLIENT_SECRET=1bcd18e4f77c71086bebe3866f88104a47947508a66e5ed70801c9373d414aae
ENV DEFAULT_EMAIL=cscexec.wpi@gmail.com
ENV VIRTUAL_HOST=ctf.wpictf.xyz
ENV LETSENCRYPT_HOST=ctf.wpictf.xyz
ENV LETSENCRYPT_EMAIL=cscexec.wpi@gmail.com

USER 1001
ENTRYPOINT ["/opt/CTFd/docker-entrypoint.sh"]
