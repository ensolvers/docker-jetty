#!/bin/bash

echo "[INFO] Setting New Relic license key: [$NEW_RELIC_LICENSE_KEY]"
echo "[INFO] Setting New Relic app name: [$NEW_RELIC_APP_NAME]"

export JAVA_OPTIONS="$JAVA_OPTIONS $EXTRA_JAVA_OPTIONS -javaagent:/var/lib/jetty/newrelic/newrelic.jar"
sed -i "s/<%= license_key %>/$NEW_RELIC_LICENSE_KEY/g" /var/lib/jetty/newrelic/newrelic.yml
sed -i "s/app_name: My Application/app_name: $NEW_RELIC_APP_NAME/g" /var/lib/jetty/newrelic/newrelic.yml

if [ ! -f /webapps/ROOT.war ]; then
	mkdir /var/lib/jetty/webapps/ROOT
    echo "[INFO] Gathering WAR image [$WAR_S3_URL]"
	aws s3 cp $WAR_S3_URL /var/lib/jetty/webapps
else
	# if /webapps/ROOT.war has been mounted, then use it instead of grabbing WAR from S3
	echo "[INFO] /webapps/ROOT.war found, running container in local mode"
	cp -r /webapps/ROOT.war /var/lib/jetty/webapps/
fi

unzip /var/lib/jetty/webapps/*.war -d /var/lib/jetty/webapps/ROOT
rm /var/lib/jetty/webapps/*.war
# sed -i "s/active:/active: $ENVIRONMENT/g" $(find /var/lib/jetty/webapps/ROOT | grep application.yaml)
# sed -i "s/\$VERSION/$VERSION/g" $(find /var/lib/jetty/webapps/ROOT | grep application.yaml)

if ! command -v -- "$1" >/dev/null 2>&1 ; then
	set -- java -jar "$JETTY_HOME/start.jar" "$@"
fi

: ${TMPDIR:=/tmp/jetty}
[ -d "$TMPDIR" ] || mkdir -p $TMPDIR 2>/dev/null

: ${JETTY_START:=$JETTY_BASE/jetty.start}

case "$JAVA_OPTIONS" in
	*-Djava.io.tmpdir=*) ;;
	*) JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR $JAVA_OPTIONS" ;;
esac

if expr "$*" : 'java .*/start\.jar.*$' >/dev/null ; then
	# this is a command to run jetty

	# check if it is a terminating command
	for A in "$@" ; do
		case $A in
			--add-to-start* |\
			--create-files |\
			--create-startd |\
			--download |\
			--dry-run |\
			--exec-print |\
			--help |\
			--info |\
			--list-all-modules |\
			--list-classpath |\
			--list-config |\
			--list-modules* |\
			--stop |\
			--update-ini |\
			--version |\
			-v )\
			echo "[INFO] exit command: [$A]"
			# It is a terminating command, so exec directly
			exec "$@"
		esac
	done

	if [ -f $JETTY_START ] ; then
		if [ $JETTY_BASE/start.d -nt $JETTY_START ] ; then
			cat >&2 <<- EOWARN
			********************************************************************
			WARNING: The $JETTY_BASE/start.d directory has been modified since
			         the $JETTY_START files was generated. Either delete
			         the $JETTY_START file or re-run
			             /generate-jetty.start.sh
			         from a Dockerfile
			********************************************************************
			EOWARN
		fi
		echo $(date +'%Y-%m-%d %H:%M:%S.000'):INFO:docker-entrypoint:jetty start from $JETTY_START
		set -- $(cat $JETTY_START)
	else
		# Do a jetty dry run to set the final command
		"$@" --dry-run > $JETTY_START
		if [ $(egrep -v '\\$' $JETTY_START | wc -l ) -gt 1 ] ; then
			# command was more than a dry-run
			cat $JETTY_START \
			| awk '/\\$/ { printf "%s", substr($0, 1, length($0)-1); next } 1' \
			| egrep -v '[^ ]*java .* org\.eclipse\.jetty\.xml\.XmlConfiguration '
			exit
		fi
		set -- $(sed 's/\\$//' $JETTY_START)
	fi
fi

if [ "${1##*/}" = java -a -n "$JAVA_OPTIONS" ] ; then
	java="$1"
	shift
	set -- "$java" $JAVA_OPTIONS "$@"
fi
