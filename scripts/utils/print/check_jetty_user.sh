#!/bin/bash

if [ $(whoami) != "jetty" ]; then
    cat >&2 <<- EOWARN
        ********************************************************************
        WARNING: User is $(whoami)
                 The user should be (re)set to 'jetty' in the Dockerfile
        ********************************************************************
    EOWARN
fi
