#!/bin/sh


command -v watchman-make >/dev/null 2>&1 || {
    echo >&2 "watchman-make is not installed. Please install with 'brew install watchman'. Aborting."; exit 1; }

trap 'kill %1' SIGINT
DEBUG=1 watchman-make -p '**' 'Makefile' -t all &
cd dist; python -m SimpleHTTPServer
