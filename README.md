# docker-jetty
A docker image based on [`jetty`](https://hub.docker.com/_/jetty/) that allows to fetch WAR packaged applications from S3 automatically and includes out-of-the-box New Relic monitoring support

## Environment variables
### Mandatory
- `AWS_ACCESS_KEY_ID`: AWS Access Key ID to get WAR file through programmatic API access
- `AWS_SECRET_ACCESS_KEY`: AWS Secret Key to get WAR file through programmatic API access
- `WAR_S3_URL`: S3 URL where the WAR file is located (e.g. `s3://my-app-bucket/prod-releases/my-app-build-988.war`)

### Optional
#### To enable New Relic monitoring
- `NEW_RELIC_APP_NAME`: Name of the app as it should be shown in New Relic APM console
- `NEW_RELIC_LICENSE_KEY`: New Relic license key to identify the account

#### To refine Java parameters
- `EXTRA_JAVA_OPTIONS`: extra options passed to the JVM (for instance, `-Xmx14g`)
