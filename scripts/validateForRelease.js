#!/usr/bin/env node

const shell = require('shelljs');
shell.set('-e');
shell.set('+v');

// Get the latest stable version of the CLI
const stableVersionCommand = 'npm view sfdx-cli dist-tags --json';
const latestStableCLIVersionJson = shell.exec(stableVersionCommand, {
  silent: true,
}).stdout;
const latest_stable_CLI_version = JSON.parse(
  latestStableCLIVersionJson
).latest.trim();

// Get the latest version of the docker image published
const fs = require('fs');
const path = require('path');
const imageVersionPath = path.join(__dirname, '../version.txt');
const current_image_version = fs
  .readFileSync(imageVersionPath)
  .toString()
  .trim();

console.log(
  `
  Current Image Version is: ${current_image_version}
  Current Stable CLI release is: ${latest_stable_CLI_version}\n
  `
);
const shouldPublishNewImage =
  latest_stable_CLI_version !== current_image_version;

if (shouldPublishNewImage) {
  console.log('CLI ❌ SFDX-Image. 🚀 🐳 ');
  shell.exec(
    `SALESFORCE_CLI_VERSION=${latest_stable_CLI_version} scripts/publish.js`
  );
} else {
  console.log('CLI ✅ SFDX-Image are in sync.');
}
