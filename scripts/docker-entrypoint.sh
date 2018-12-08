#!/bin/bash

SCRIPTS_DIR="/tmp/scripts"

set -e

sh $SCRIPTS_DIR/config/ssh_keys.sh
sh $SCRIPTS_DIR/config/properties.sh
sh $SCRIPTS_DIR/utils/print/properties_path.sh
source $SCRIPTS_DIR/config/jetty.sh

echo $JAVA_OPTIONS
echo $JETTY_START

exec "$@"
