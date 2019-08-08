FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt install --assume-yes openjdk-11-jdk-headless nodejs
RUN npm install --global sfdx-cli

# Create cert in order to use in JWT flow
# https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_key_and_cert.htm
RUN apt-get install --assume-yes openssl
RUN mkdir /root/JWT
RUN openssl genrsa -des3 -passout pass:xmachina -out /root/JWT/server.pass.key 2048 && \
    openssl rsa -passin pass:xmachina -in /root/JWT/server.pass.key -out /root/JWT/server.key && \
    rm /root/JWT/server.pass.key && \
    openssl req -new -key /root/JWT/server.key -out /root/JWT/server.csr \
        -subj "/C=US/ST=California/L=San Francisco/O=SFDX/OU=Dev/CN=dx.com" && \
    openssl x509 -req -sha256 -days 365 -in /root/JWT/server.csr -signkey /root/JWT/server.key -out /root/JWT/server.crt

RUN apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash