#!/usr/bin/env bash

set -e

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GRADLE_CACHE_DIR=$SOURCE_DIR/_caches/gradle

# Create an image name based on the source directory so we know we're referring to the one that applies to this codebase
IMAGE_NAME=`echo "dev-env${SOURCE_DIR//\//-}" | awk '{print tolower($0)}'`
IMAGE_TAG="$IMAGE_NAME:latest"

function main {
  case "$1" in

  build) build;;
  unitTest) unitTest;;
  continuousUnitTest) continuousUnitTest;;
  integrationTest) integrationTest;;
  journeyTest) journeyTest;;
  ci) ci;;
  run) run;;
  runWithFakes) runWithFakes;;
  runWithReals) runWithReals;;
  startFakes) startFakes;;
  startReals) startReals;;
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
  echo " run                    builds and starts the application (but does not start any dependencies)"
  echo " runWithFakes           builds and starts the application with fake dependencies"
  echo " runWithReals           builds and starts the application with real dependencies"
  echo " startFakes             starts fake dependencies but not the application"
  echo " startReals             starts real dependencies but not the application"
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

function ci {
  build
  unitTest
  integrationTest
  journeyTest
}

function runGradle {
  createCacheDirectories
  runCommandInBuildContainer ./gradlew $@
}

function checkForDocker {
  hash docker 2>/dev/null || { echo >&2 "This script requires Docker, but it's not installed or not on your PATH."; exit 1; }
}

function buildImage {
  echoWhiteText "Building development environment container image..."
  docker build --tag "$IMAGE_TAG" "$SOURCE_DIR/dev-env"
}

function createCacheDirectories {
  mkdir -p "$GRADLE_CACHE_DIR"
}

function runCommandInBuildContainer {
  checkForDocker
  buildImage

  echoWhiteText "Running '$@' in container..."

  docker run --rm -it \
    -w /code \
    -v $SOURCE_DIR:/code \
    -v $GRADLE_CACHE_DIR:/root/.gradle \
    -e GRADLE_OPTS="-Dorg.gradle.daemon=false" \
    "$IMAGE_TAG" \
    $@
}

function echoWhiteText {
  RESET=$(tput sgr0)
  WHITE=$(tput setaf 7)

  echo "${WHITE}${@}${RESET}"
}

main "$@"
