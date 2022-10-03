# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "6e7caea9ea57e6dc5aea7eff9cbbf603fb62c7b17cb7fdeffa4be966844cfdd7"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.4.14"
    sha256 cellar: :any_skip_relocation, big_sur:      "c45fe4ad6c73e2b7d631381c7a74448a6fa15ac63df3fecd97474bf12accca98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a5a39741debd38deb6dc27e0faaf563bf4bdb482cc094a959c6b0ad40da6204"
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
