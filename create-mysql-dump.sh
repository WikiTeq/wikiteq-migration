#!/bin/bash

echo "Checking parameters..."

result_path=$1

if [ -z "$result_path" ]; then
    echo 'Error: PATH parameter is required' >&2
    exit 1
fi

if [ -z "$WIKI_MYSQL_HOST" ]; then
    echo 'Error: WIKI_MYSQL_HOST env is required' >&2
    exit 1
fi

if [ -z "$WIKI_MYSQL_ROOT_PASSWORD" ]; then
    echo 'Error: WIKI_MYSQL_ROOT_PASSWORD env is required' >&2
    exit 1
fi

result_filename=$(basename "$result_path")
result_dirname=$(dirname "$result_path")

if [ ! -d "$result_dirname" ]; then
    echo "Dir ${result_dirname} must exist!";
    exit 1;
fi

echo "Rotating old dumps..."

if [ -f "${result_dirname}/${result_filename}" ]; then
    ctime=$(stat --format '%Y' "${result_dirname}/${result_filename}")
    mv "${result_dirname}/${result_filename}" "${result_dirname}/${result_filename}.${ctime}"
    find "${result_dirname}" -name "${result_filename}.*" | tail -n +4 | xargs -I %% rm %%
fi

echo "Creating dump..."

mysqldump --host "$WIKI_MYSQL_HOST" \
  --all-databases \
  --single-transaction \
  --skip-lock-tables \
  --column-statistics \
  --user root \
  --password "$WIKI_MYSQL_ROOT_PASSWORD" | gzip > "${result_path}"

echo "Dump created successfully!"
