# Migration stack

This stack is designed to automate the migration of a MediaWiki database and images to a remote S3 bucket.
It includes a cron job that runs daily to create a MySQL dump of the database and uploads it to the S3 bucket
The images are also copied to the S3 bucket using rclone

## Quickstart

* Clone the stack into `~/docker/migration`
* Create the `.env` file using the `.env.example` file as a template
* Run `docker-compose up -d`

## Environment variables

* `WIKI_NETWORK` - The exact full docker network name of the MediaWiki stack
* `VOLUMENAME` - The exact full name of the volume that contains the MediaWiki images
* `DB_BUCKET_NAME` - The name of the S3 bucket to upload the database dumps to
* `IMAGES_BUCKET_NAME` - The name of the S3 bucket to upload the images to
* `S3_ACCESS_KEY` - The access key for the S3 bucket
* `S3_SECRET_KEY` - The secret key for the S3 bucket
* `WIKI_MYSQL_HOST` - The hostname of the MediaWiki MySQL database container (usuaslly `db`)
* `WIKI_MYSQL_ROOT_PASSWORD` - The root password for the MediaWiki MySQL database container

## Default schedule

`0 1 * * *` - Dump the databases
`0 4 * * *` - Upload the images to S3
`0 5 * * *` - Copy the databases to S3
