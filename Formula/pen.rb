# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "14ccc4f78bc6d95c7ae201bcdd68e41ab28e0c1a381177e086d59bd896197dd2"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.1"
    sha256 cellar: :any_skip_relocation, monterey:     "62738614cfb438d42252c9da1a30ed5a3fff259fd4a636363e77206caa2f05b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "468e526d3358365dc085d9521c8a26553b7afa62f04d8c971b0f8cc562ef8e86"
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

    system "#{bin}/pen", "create", "."
    system "#{bin}/pen", "test"
    system "#{bin}/pen", "build"
    system "./app"
  end
end
