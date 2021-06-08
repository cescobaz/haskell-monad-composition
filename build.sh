#!/bin/sh

docker build \
  --build-arg APP_NAME=monad-composition-example \
  --build-arg APP_VERSION=0.1.0.0 \
  --build-arg EXE_NAME=monad-composition-example \
  -t cescobaz/monad-composition-example .
