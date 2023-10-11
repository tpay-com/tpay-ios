#!/usr/bin/sh

curl --silent "https://api.github.com/repos/$1/releases/latest" |   # Get latest release from GitHub api
    grep '"tarball_url":' |                                         # Get tarball_url line
    sed -E 's/.*"([^"]+)".*/\1/' |                                  # Pluck JSON value
    xargs curl -LJs |                                               # Download tar
    tar xj --strip-components 1 -C $2                               # Extract tar to specified folder