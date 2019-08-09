FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt install --assume-yes openjdk-11-jdk-headless nodejs
RUN npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION}

# Remove this instruction once the release branch is available externally
RUN echo 'y' | SFDX_NPM_REGISTRY=http://platform-cli-registry.eng.sfdc.net:4880/ sfdx plugins:install salesforcedx@release

RUN apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash