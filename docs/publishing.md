Publishing means building the docker image using the Dockerfile, tagging it with
the right tags, and pushing it onto our DockerHub repository at
https://hub.docker.com/r/salesforce/salesforcedx.

Some guidelines:

1. We publish from the main branch.
1. We specify a specific tag that matches the Salesforce CLI version for each
   image.
1. We also have a `latest-slim` and `latest-full` tags that matches with the latest version of the Salesforce
   CLI.
1. When running `scripts/publish.js` two versions of the salesforcedx image will be published (in addition to `latest-slim` and `latest-full`) `-slim` and `-full`.

- The `-slim` image will contain only what is needed for sfdx development, any additional utilities should be added to the `-full` image.

For those interested in publishing, here are some pre-requisites:

1. Ensure that you have a dockerhub account and are a member of
   https://hub.docker.com/r/salesforce/salesforcedx
1. Ensure that you have the Docker CLI installed -- we need to build, tag, and
   push the images.
1. Ensure that you have Node.js installed -- the publishing scripts uses it.

Steps:

1. Clone this repository.
1. If necessary, ensure that you are on the `main` branch.
1. Run `yarn` to bring in the dependencies without making unnecessary changes to
   the lock files.
1. From the command line execute `SALESFORCE_CLI_VERSION=x.y.z scripts/publish.js` where x.y.z matches the version of the Salesforce CLI
   that you are releasing for.
1. If you need to publish a docker version that is _different_ from the
   Salesforce CLI version (e.g., for a security patch), do
   `SALESFORCE_CLI_VERSION=x.y.z DOCKER_IMAGE_VERSION=x1.y1.z1 scripts/publish.js`
