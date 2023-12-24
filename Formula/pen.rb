# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "41685328e3ef0dc699a6144cab0a386c59fe6e187fdb3ce921a436ddf0e15f9e"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.5"
    sha256 cellar: :any,                 monterey:     "3c8aca7b6c75f14a84e2c2800d74f0f0c227b05f6aba280caf5db8fef93d6da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "49532071536c74fce3a198046fa957e85089bee63ef2d0b3ff35a1c4719f0e0d"
  end

  depends_on "git"
  depends_on "jq"
  depends_on "llvm"
  depends_on "ninja"
  depends_on "pen-lang/pen/turtle"
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "cmd/pen")
    libexec.install "target/release/pen"

    paths = %w[
      git
      jq
      llvm
      ninja
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
