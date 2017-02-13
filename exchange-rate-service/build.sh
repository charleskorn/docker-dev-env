#!/usr/bin/env bash

set -e

DOCKER_IMAGE_TAG="exchange-rate-service:latest"
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main {
  echoWhiteText "Building app..."
  $SOURCE_DIR/gradlew -p $SOURCE_DIR build assembleDist
  echo

  echoWhiteText "Building container image..."
  cp $SOURCE_DIR/build/distributions/exchange-rate-service.zip $SOURCE_DIR/infra/app.zip
  docker build --tag $DOCKER_IMAGE_TAG infra
}

function echoWhiteText {
  RESET=$(tput sgr0)
  WHITE=$(tput setaf 7)

  echo "${WHITE}${@}${RESET}"
}

main
