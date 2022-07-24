# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "2a6bb8dfaae8ea8ae056859accdb814bb41664428d90cb73c149239b574cb10a"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.4.5"
    sha256 cellar: :any,                 big_sur:      "b8fe7fe891ddc11e4e9dd716d95d9b637377f583cb0ae0822d9430a3f42bae15"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de8d96031c3e6af7e24a68396406bd83424cbe039d48b62aad1feb8722f0f416"
  end

  depends_on "git"
  depends_on "jq"
  depends_on "llvm@14"
  depends_on "ninja"
  depends_on "pen-lang/pen/turtle"
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "cmd/pen")
    libexec.install "target/release/pen"

    paths = [
      "git",
      "jq",
      "llvm@14",
      "ninja",
    ].map do |name|
      Formula[name].opt_bin
    end.join(":")

    File.write "pen.sh", <<~EOS
      #!/bin/sh
      set -e
      export PEN_ROOT=#{prefix}
      export PATH=#{paths}:$PATH
      if ! which rustup >/dev/null; then
        export PATH=#{Formula["rust"].opt_bin}:$PATH
      fi
      #{libexec / "pen"} "$@"
    EOS

    chmod 0755, "pen.sh"
    libexec.install "pen.sh"
    bin.install_symlink (libexec / "pen.sh") => "pen"

    (prefix / "cmd").install Dir["cmd/*"]
    prefix.install "packages"
  end

  test do
    ENV.prepend_path "PATH", bin

    system "pen", "create", "."
    system "pen", "build"
    system "pen", "test"
    system "./app"
  end
end
