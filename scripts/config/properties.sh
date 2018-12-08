#!/bin/bash

# replace with secret keys
# TODO: add support for .properties file, not it assumes YAML
if [ -z $SECRET_PROPERTY_FILE_S3_URL ] || [ -z $APP_PROPERTY_FILE_PATH ]; then
	echo "[INFO] Secret property files *NOT* provided, no replacement will be done over properties file for env $ENVIRONMENT"
else
	echo "[INFO] Secret properties file *IS* provided, merge with current properties file will be done"
	aws s3 cp $SECRET_PROPERTY_FILE_S3_URL /tmp/properties
	yq m --overwrite $APP_PROPERTY_FILE_PATH /tmp/properties > /tmp/properties-updated
	cp /tmp/properties-updated $APP_PROPERTY_FILE_PATH
	rm /tmp/properties
fi