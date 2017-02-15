#!/usr/bin/env bash

set -e

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_TAG="international-transfers-service:latest"

function main {
  case "$1" in

  build) build;;
  unitTest) unitTest;;
  continuousUnitTest) continuousUnitTest;;
  integrationTest) integrationTest;;
  journeyTest) journeyTest;;
  ci) ci;;
  runWithFakes) runWithFakes;;
  runWithReals) runWithReals;;
  *)
    help
    exit 1
    ;;

  esac
}

function help {
  echo "Usage:"
  echo " build                  builds the application and packages it into a Docker image"
  echo " unitTest               runs the unit test suite once"
  echo " continuousUnitTest     runs the unit test suite once and then repeats the unit tests when code changes are detected"
  echo " integrationTest        runs the integration test suite"
  echo " journeyTest            runs the journey test suite"
  echo " ci                     equivalent to running build, unitTest, integrationTest and journeyTest"
  echo " runWithFakes           builds and starts the application with fake dependencies"
  echo " runWithReals           builds and starts the application with real dependencies"
}

function build {
  echoGreenText 'Building application...'
  runGradle assembleDist

  echoWhiteText 'Building Docker image...'
  cp $SOURCE_DIR/build/distributions/international-transfers-service.zip $SOURCE_DIR/infra/components/international-transfers-service/app.zip
  docker build --tag $DOCKER_IMAGE_TAG $SOURCE_DIR/infra/components/international-transfers-service
}

function unitTest {
  echoGreenText 'Running unit tests...'
  runGradle test
}

function continuousUnitTest {
  runGradle --continuous test
}

function integrationTest {
  echoGreenText 'Running integration tests...'
  runCommandInBuildContainer $SOURCE_DIR/infra/integration-test.yml build-env ./gradlew integrationTest
}

function journeyTest {
  build

  echoGreenText 'Running journey tests...'
  runCommandInBuildContainer $SOURCE_DIR/infra/journey-test.yml build-env ./gradlew journeyTest
}

function ci {
  build
  unitTest
  integrationTest
  journeyTest
}

function runWithFakes {
  runEnvironment $SOURCE_DIR/infra/app-with-fakes.yml
}

function runWithReals {
  runEnvironment $SOURCE_DIR/infra/app-with-reals.yml
}

function checkForDocker {
  hash docker 2>/dev/null || { echo >&2 "This script requires Docker, but it's not installed or not on your PATH."; exit 1; }
}

function runGradle {
  runCommandInBareBuildContainer ./gradlew $@
}

function runCommandInBareBuildContainer {
  runCommandInBuildContainer $SOURCE_DIR/infra/components/build-env.yml build-env $@
}

function runCommandInBuildContainer {
  checkForDocker

  env=$1
  service=$2
  command=${@:3}

  echoWhiteText 'Building environment...'
  docker-compose -f $env build

  echoWhiteText 'Cleaning up from previous runs...'
  docker-compose -f $env down --volumes --remove-orphans

  echoWhiteText "Running '$command'..."
  docker-compose -f $env run --rm $service $command || cleanUpAfterFailure

  cleanUp $env
}

function runEnvironment {
  checkForDocker

  env=$1

  echoWhiteText 'Cleaning up from previous runs...'
  docker-compose -f $env down --volumes --remove-orphans

  echoWhiteText "Starting environment..."
  docker-compose -f $env up --force-recreate --build --abort-on-container-exit --remove-orphans || cleanUp $env

  cleanUp $env
}

function cleanUpAfterFailure {
  # TODO You might like to always clean up if you're running on CI.
  echoRedText 'Command failed. Containers will not be cleaned up to make debugging this issue easier.'
  exit 1
}

function cleanUp {
  env=$1

  echoWhiteText 'Cleaning up...'
  docker-compose -f $env down --volumes --remove-orphans
}

function echoGreenText {
  RESET=$(tput sgr0)
  GREEN=$(tput setaf 2)

  echo "${GREEN}${@}${RESET}"
}

function echoRedText {
  RESET=$(tput sgr0)
  RED=$(tput setaf 1)

  echo "${RED}${@}${RESET}"
}

function echoWhiteText {
  RESET=$(tput sgr0)
  WHITE=$(tput setaf 7)

  echo "${WHITE}${@}${RESET}"
}

main "$@"
