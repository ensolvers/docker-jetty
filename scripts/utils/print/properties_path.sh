#!/bin/bash

if [ ! -z $PRINT_PROPERTIES_PATH ]; then
	echo "[INFO] Properties content [$PRINT_PROPERTIES_PATH]"
	cat "$PRINT_PROPERTIES_PATH"
fi