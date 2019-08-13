FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest
RUN apt-get update \
    && curl -s -o nodejs.deb https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/nodejs_10.16.2-1nodesource1_amd64.deb \
    && apt-get install --assume-yes \ 
    ./nodejs.deb \ 
    openjdk-11-jdk-headless=11.0.4+11-1ubuntu2~18.04.3 \
    && npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION} \
    && rm -rf ./nodejs.deb

RUN apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash