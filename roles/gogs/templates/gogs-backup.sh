#!/usr/bin/env bash

set -e

for i in {1..10}; do
  if [ -d "{{ backups }}" ]; then
    echo "{{ backups }} is ready!"
    break
  fi
  if [ "$i" -eq "10" ]; then
    echo "{{ backups }} is *not* ready!"
    exit 1
  fi
  sleep 2
done

mkdir -p {{ backups }}/gogs/{raw,native}

TIMESTAMP=$(date -u +'%Y%m%d-%H%M%S')

# raw backup
DATA="{{ root }}/var/lib/gogs"
SNAPSHOT="{{ backups }}/gogs/raw/$TIMESTAMP.tar.bz2"
echo "Creating $SNAPSHOT..."
tar -cjf "$SNAPSHOT" -C "$DATA" .

# native backup
echo "Creating native backup..."
SNAPSHOT="{{ backups }}/gogs"
sudo docker exec gogs.service /bin/bash -c 'rm -rf native && mkdir -p native && USER=git ./gogs backup && mv gogs-backup-*.zip native/.; exit'
sudo docker cp gogs.service:/app/gogs/native "$SNAPSHOT/."
sudo docker exec gogs.service /bin/bash -c 'rm -rf native; exit'

# note! how to restore: https://github.com/gogs/gogs/issues/4339 -- remember the --tempdir command-line flag

echo "Done!"
exit 0
