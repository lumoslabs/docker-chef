#!/bin/bash
test -n "${_DEBUG}" && set -x
for d in /opt/host/{bin,sbin} /opt/host/local/{bin,sbin} /var/host/{bin,sbin} /var/host/local/{bin,sbin}; do
  test -d "${d}" && export PATH=${PATH}:${d}
done
cmd=$1 ; shift
exec "$cmd" "$@"
