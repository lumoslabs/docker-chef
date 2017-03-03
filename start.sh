#!/bin/sh
test -n "${_DEBUG}" && set -x
for d in /mnt/root/bin /mnt/root/usr/bin /mnt/root/sbin /mnt/root/usr/sbin /mnt/root/usr/local/bin /mnt/root/usr/local/sbin; do
  test -d "$d" && export PATH=$d:${PATH}
done
cmd=$1 ; shift
exec "$cmd" "$@"
