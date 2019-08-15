FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest
RUN apt-get update
RUN echo 'f6d5a254de2734ad9e7b9b02777d47a9a7454059e2d5690cf25c5ea57280f060  ./nodejs.deb' > node-file-lock.sha \
    && curl -s -o nodejs.deb https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/nodejs_10.16.2-1nodesource1_amd64.deb \
    && shasum --check node-file-lock.sha
RUN apt-get install --assume-yes \
    ./nodejs.deb \ 
    openjdk-11-jdk-headless=11.0.4+11-1ubuntu2~18.04.3 \
    && npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION} \
    && rm nodejs.deb node-file-lock.sha

RUN apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash