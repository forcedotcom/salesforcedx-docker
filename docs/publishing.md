Publishing means building the docker image using the Dockerfile, tagging it with
the right tags, and pushing it onto our DockerHub repository at
https://hub.docker.com/r/salesforce/salesforcedx.

Some guidelines:

1. We publish from the master branch.
1. We specify a specific tag that matches the Salesforce CLI version for each image.
1. We also have a `latest` tag that matches the `latest` tag on the Salesforce CLI.

For those interested in publishing, here are some pre-requisites:

1. Ensure that you have a dockerhub account and are a member of https://hub.docker.com/r/salesforce/salesforcedx
1. Ensure that you have the Docker CLI installed -- we need to build, tag, and push the images.
1. Ensure that you have Node.js installed -- the publishing scripts uses it.

Steps:

1. Clone this repository.
1. If necessary, ensure that you are on the `master` branch.
1. Run `yarn` to bring in the dependencies without making unnecessary changes to the lock files.
1. From the command line execute `SALESFORCE_CLI_VERSION=x.y.z scripts/publish.js` where x.y.z matches the version of the Salesforce CLI that you are releasing for.
