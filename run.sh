#!/usr/bin/env sh

set -e

DEBUG=${DEBUG:-0}

debug() {
  if [ "$DEBUG" -eq 0 ]; then
    return
  fi

  # shellcheck disable=SC2145
  echo "DEBUG: $@"
}

repo_slug="$1"
cache_dir=~/.cache/run

if [ -z "$repo_slug" ]; then
  echo "Repository slug ex. 'RiddleMan/run' is required."
  exit 1
fi

debug "Creating .cache directory if does not exist."
mkdir -p "$cache_dir"

repo_dir="$cache_dir/$repo_slug"

if ! stat "$repo_dir" >/dev/null 2>&1; then
  debug "Cannot find repository in the cache. Cloning..."
  if ! git clone "https://github.com/$repo_slug.git" "$cache_dir/$repo_slug"; then
    echo "Cannot clone repository. Please check whether you have git installed and accessible in PATH."
    exit 2
  fi
fi

script_path="$repo_dir/run.sh"

if [ ! -x "$script_path" ]; then
  echo "Cannot find main script or script is not executable. Please contact with the maintainer of $repo_slug."
  exit 3
fi

# To remove repo_slug
shift

# shellcheck disable=SC2068
eval "$script_path" $@
