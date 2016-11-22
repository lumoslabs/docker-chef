#!/bin/bash
[ -n "${_DEBUG}" ] && set -x
eval exec "$*"
