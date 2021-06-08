FROM haskell:8.10.4-stretch as build-env

ARG APP_NAME
ARG APP_VERSION
ARG EXE_NAME

WORKDIR /opt/app

RUN cabal update

COPY *.cabal .
RUN cabal build --builddir=dist --disable-tests -O2 --dependencies-only

COPY . .
RUN cabal build --builddir=dist --disable-tests -O2

##########################################################
FROM debian:stretch

ARG APP_NAME
ARG APP_VERSION
ARG EXE_NAME

WORKDIR /opt/app

RUN apt update
RUN apt install -y libgmp10 netbase ca-certificates openssh-client

COPY --from=build-env /opt/app/dist/build/x86_64-linux/ghc-8.10.4/$APP_NAME-$APP_VERSION/x/$EXE_NAME/opt/build/$EXE_NAME/$EXE_NAME .

EXPOSE ${PORT}

ENV EXE_NAME ${EXE_NAME}
CMD ./${EXE_NAME}
