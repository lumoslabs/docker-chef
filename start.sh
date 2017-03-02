#!/bin/sh
test -n "${_DEBUG}" && set -x
dirs=(
  /mnt/root/usr/local/bin
  /mnt/root/usr/local/sbin
  /mnt/root/usr/bin
  /mnt/root/bin
  /mnt/root/usr/sbin
  /mnt/root/sbin
)
for d in "${dirs[@]}"; do
  test -d "$d" && export PATH=$d:${PATH}
done
cmd=$1 ; shift
exec "$cmd" "$@"
