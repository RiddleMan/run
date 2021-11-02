#!/usr/bin/env sh

set -e

cwd=$(dirname "$0")
root="$cwd/.."

version=${1:?Version is required and should be semver compliant ex. 0.0.2}
commit_to_tag=$2

if [ -z "$commit_to_tag" ]; then
  commit_to_tag=$(git rev-parse HEAD)
fi

dist_dir=$(realpath "$root/dist")
mkdir -p "$dist_dir"

source_archive_name="run-$version.tar.gz"
source_archive_path=$(realpath "$dist_dir/$source_archive_name")

echo "Creating artifacts"
prev=$(pwd)
cd "$root"
tar -czvf "$source_archive_path" \
  "run.sh" \
  "install.sh" \
  "README.md"

cd "$dist_dir"
sha256sum "$source_archive_name" >"$dist_dir/$source_archive_name.sha256"
cd "$prev"

echo "Tagging commit: $commit_to_tag with version: $version"
git tag "v$version" "$commit_to_tag"
git push origin "v$version"
