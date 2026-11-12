#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

for tool in emacs nvim; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "FATAL: $tool is required" >&2
        exit 2
    fi
done

cleanup() {
    rm --force emacs/rza-mode.elc
}
trap cleanup EXIT

emacs -Q --batch -L emacs --eval '(setq byte-compile-error-on-warn t)' \
    -f batch-byte-compile emacs/rza-mode.el
emacs -Q --batch -L emacs -L test -l test/rza-mode-test.el \
    -f ert-run-tests-batch-and-exit
nvim --headless -u NONE -i NONE -n -l test/nvim.lua
printf '\nEditor plugin tests passed\n'
