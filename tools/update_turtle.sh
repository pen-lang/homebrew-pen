#!/bin/sh

set -e

rm -rf tmp
mkdir -p tmp

git clone https://github.com/raviqqe/turtle-build tmp/turtle

version=$(cd tmp/turtle && cat Cargo.toml | grep '^version = ' | cut -f 2 -d '"')

sed -i "s/version .*/version '$version'/" Formula/turtle.rb

hash=$(curl -fsSL https://github.com/raviqqe/turtle-build/archive/refs/tags/v$version.tar.gz | sha256sum | cut -f 1 -d ' ')

sed -i "s/sha256 .*/sha256 '$hash'/" Formula/turtle.rb
