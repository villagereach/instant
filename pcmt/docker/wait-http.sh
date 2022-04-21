#!/bin/bash

URL=$1

echo "Waiting for $URL..."
until $(curl --output /dev/null --silent --head --fail "$URL"); do
    printf '.'
    sleep 5
done
echo "... $URL is up"