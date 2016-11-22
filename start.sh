#!/bin/bash
[ -n "${_DEBUG}" ] && set -x
cmd=$1 ; shift
exec "$cmd" "$@"
