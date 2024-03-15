#!/usr/bin/env bash

source scripts/_common.sh

ensure_in_dev_shell
build_workspace
add_target_dir_to_path

export DEVIMINT_DIR="${CARGO_BUILD_TARGET_DIR:-target}/devimint"
rm -f "$DEVIMINT_DIR/devimint"

function devimint_env {
  set -euo pipefail

  export RUST_LOG=info
  export RUST_BACKTRACE=1

  if [ -n "${PS1:-}" ]; then
    PS1="[devimint] $PS1"
  else
    PS1="[devimint]"
  fi

  >&2 echo "Devimint Env Shell"
  "${SHELL}"
}
export -f devimint_env

env RUST_LOG=warn,jsonrpsee-client=off \
  devimint --link-test-dir "${CARGO_BUILD_TARGET_DIR:-$PWD/target}/devimint" "$@" dev-fed \
    --exec bash -c devimint_env