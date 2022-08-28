# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "d9279d1b489bf42204a2b632e7b8026d3e2b95cf0fe1f63f33f943927571c5d8"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.4.11"
    sha256 cellar: :any,                 big_sur:      "2078d80fd731604795f82e0f1061eae37dd891b370f454fedb1c212bbf0c0d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "81c46aca7c0a81af2133a629efc3bf88c0b8caa100260d803f46a6afc05d9490"
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
