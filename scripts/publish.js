#!/usr/bin/env node

const shell = require('shelljs');
shell.set('-e');
shell.set('+v');

// This needs to change when we are ready to publish
const DOCKER_HUB_REPOSITORY = 'vazexqi/salesforcedx';

// Checks that you have the Docker CLI installed
if (!shell.which('docker')) {
  shell.echo('You do not have the Docker CLI installed.');
  shell.exit(-1);
}

// Checks that you have logged into docker hub
// Unfortunately I don't think there is a way to check what repositories you have access to
const AUTH_REGEX = '"https://index.docker.io/v1/"';
if (
  !new RegExp(AUTH_REGEX).test(
    shell.grep(AUTH_REGEX, '~/.docker/config.json').stdout
  )
) {
  shell.echo('You are not logged into Docker Hub. Try `docker login`.');
  shell.exit(-1);
}

// Checks that there are no uncommitted changes
const gitStatus = shell.exec(`git status --porcelain`).stdout.trim();
if (gitStatus) {
  shell.echo(
    'You have git changes in the current branch. You should probably not be releasing until you have commited your changes.'
  );
  shell.exit(-1);
}

const SALESFORCE_CLI_VERSION = process.env['SALESFORCE_CLI_VERSION'];
if (!SALESFORCE_CLI_VERSION) {
  shell.echo(
    'You need to specify the version that you want to publish using the SALESFORCE_CLI_VERSION environment variable.'
  );
  shell.exit(-1);
}

// Proceed to build using the right CLI version
const dockerBuildExitCode = shell.exec(
  `docker build --build-arg SALESFORCE_CLI_VERSION=${SALESFORCE_CLI_VERSION} --tag ${DOCKER_HUB_REPOSITORY}:${SALESFORCE_CLI_VERSION} .`
);

// Push to the Docker Hub Registry
const dockerPushExitCode = shell.exec(
  `docker push ${DOCKER_HUB_REPOSITORY}:${SALESFORCE_CLI_VERSION}`
);

// If we are on the master branch, also update the latest tag
const currentBranch = shell.exec('git rev-parse --abbrev-ref HEAD', {
  silent: true
}).stdout;
if (/master/.test(currentBranch)) {
  shell.echo(
    'We are on the master branch. Proceeding to also tag it as latest'
  );
  shell.exec(
    `docker tag ${DOCKER_HUB_REPOSITORY}:${SALESFORCE_CLI_VERSION} ${DOCKER_HUB_REPOSITORY}:latest`
  );
  shell.exec(`docker push ${DOCKER_HUB_REPOSITORY}:latest`);
}
