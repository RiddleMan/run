#!/usr/bin/env sh

set -e

cwd=$(dirname "$0")
root="$cwd/.."

version=${1:?Version is required and should be semver compliant ex. 0.0.2}
commit_to_tag=$2

if [ -z "$commit_to_tag" ]; then
  commit_to_tag=$(git rev-parse HEAD)
fi

dist_dir="$root/dist"
source_archive_name="$dist_dir/run-$version.tar.gz"

mkdir -p "$dist_dir"

echo "Creating artifacts"
tar -czvf "$source_archive_name" \
  "$root/run.sh" \
  "$root/install.sh" \
  "$root/README.md"
sha256sum "$source_archive_name" >"$dist_dir/checksum"

echo "Tagging commit: $commit_to_tag with version: $version"
git tag "v$version" "$commit_to_tag"
git push origin "v$version"
