#!/bin/zsh

set -eu

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install-test.XXXXXX")"
home_dir="$tmpdir/home"

cleanup() {
  rm -rf "$tmpdir"
}

fail() {
  printf "FAIL: %s\n" "$1" >&2
  exit 1
}

trap cleanup EXIT

mkdir -p "$home_dir"

if HOME="$home_dir" "$repo_root/install.sh" --definitely-not-a-real-flag >"$tmpdir/unknown.out" 2>&1; then
  fail "unknown flags should fail"
else
  unknown_status=$?
fi
[ "$unknown_status" -eq 2 ] || fail "unknown flags should exit 2"

if HOME="$home_dir" "$repo_root/install.sh" --verify >"$tmpdir/pre-verify.out" 2>&1; then
  fail "verify should fail before installation"
fi
grep -q "MISSING" "$tmpdir/pre-verify.out" || fail "pre-install verify should report missing files"

HOME="$home_dir" "$repo_root/install.sh" --dry-run >"$tmpdir/dry-run.out" 2>&1
[ ! -e "$home_dir/.zshrc" ] || fail "dry-run should not create files"

HOME="$home_dir" "$repo_root/install.sh" >"$tmpdir/install.out" 2>&1
[ -L "$home_dir/.zshrc" ] || fail "install should link .zshrc"
[ -L "$home_dir/.config/oh-my-zsh/aliases.zsh" ] || fail "install should link tracked .config files"
[ -f "$home_dir/.gitconfig" ] || fail "install should create ~/.gitconfig from example"

HOME="$home_dir" "$repo_root/install.sh" --verify >"$tmpdir/post-verify.out" 2>&1 || fail "verify should pass after installation"

printf "install test passed\n"
