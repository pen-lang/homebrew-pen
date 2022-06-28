# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "5de1fecaf35833767cd221b68bf4e70e5dc8a8cd499e1ff75a0aaf3e99ea343b"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.4.1_1"
    sha256 cellar: :any,                 big_sur:      "1f4eda03312fe6bc60af16f7d59ecbe0ccf89ebb42fbaac9bb47fa46f38470bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "230bba0921a54d8d0b5c857549c67c54c66a3835391b3027d4e5023d17e1c1ad"
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
