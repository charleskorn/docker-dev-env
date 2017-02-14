#!/usr/bin/env bash

set -e

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
  runGradle assemble
  echo "TODO: build Docker image"
}

function unitTest {
  runGradle test
}

function continuousUnitTest {
  runGradle --continuous test
}

function integrationTest {
  runCommandInBuildContainer $SOURCE_DIR/infra/integration-test.yml build-env ./gradlew integrationTest
}

function ci {
  build
  unitTest
  integrationTest
  journeyTest
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
  docker-compose -f $env run --rm $service $command || (cleanUp $env && exit 1)

  cleanUp $env
}

function cleanUp {
  env=$1

  echoWhiteText 'Cleaning up...'
  docker-compose -f $env down --volumes --remove-orphans
}

function echoWhiteText {
  RESET=$(tput sgr0)
  WHITE=$(tput setaf 7)

  echo "${WHITE}${@}${RESET}"
}

main "$@"
