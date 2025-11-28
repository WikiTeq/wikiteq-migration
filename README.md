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
* `COMPOSE_PROFILES` - The profiles (comma-separated) to use for docker-compose, defaults is `database,rclone-images,rclone-database`

## Profiles

* `database` - Dump the database
* `rclone-images` - Upload the images to S3
* `rclone-database` - Upload database dumps to S3

## Default schedule

`0 1 * * *` - Dump the databases
`0 4 * * *` - Upload the images to S3
`0 5 * * *` - Copy the databases to S3

## Running the stack to back up more than one wiki

The stack uses --all-databases to dump the database, thus one instance of the stack is enough to copy over
all the wikis databases assuming they are on the same MySQL server. However, there is also a need to copy the images
to S3 and this must be done by deploying a limited stack copy to handle just the 2nd wiki images volume:

* Clone & configure the stack copy to run for the first wiki. This first instance of the stack will be responsible
for backing up all the databases and the first wiki images volume with `COMPOSE_PROFILES=database,rclone-images,rclone-database` configured
* Clone a second copy of the stack and enable just the `COMPOSE_PROFILES=rclone-images` profile. This second instance will be responsible for backing up the second wiki images volume. Optionally configure `CRON_UPLOAD_IMAGES` to run at a different time. Makes sure to set `IMAGES_BUCKET_NAME` to the correct bucket name and the `VOLUMENAME` to the correct volume name.

For >1 wiki setup the `IMAGES_BUCKET_NAME` must contain subdir suffixes, i.e. `mywiki-bucket/wiki1` and `mywiki-bucket/wiki2`
