#! /usr/bin/env bash

set -Eeuo pipefail
set -x

# Filter out arguments that are not available to this action
# args:
#   $@: Arguments to be filtered
parse_args() {
  local opts=""
  while (( "$#" )); do
    case "$1" in
      -q|--quiet)
        opts="$opts -q"
        shift
        ;;
      --) # end argument parsing
        shift
        break
        ;;
      -*|--*=) # unsupported flags
        >&2 echo "ERROR: Unsupported flag: '$1'"
        exit 1
        ;;
      *) # positional arguments
        shift  # ignore
        ;;
    esac
  done

  # set remaining positional arguments (if any) in their proper place
  eval set -- "$opts"

  echo "${opts/ /}"
  return 0
}

# Generates client.
# args:
#   $@: additional options
# env:
#   [required] TARGETS : Files or directories (i.e., playbooks, tasks, handlers etc..) to be linted
ansible::molecule() {
  local opts=$(parse_args "$@" || exit 1)
  molecule test
}

ansible::molecule::install() {
  pip install molecule
}

args=("$@")

if [ "$0" = "$BASH_SOURCE" ] ; then
  >&2 echo -E "\nRunning Molecule...\n"
  ansible::molecule::install
  ansible::molecule ${args[@]}
fi