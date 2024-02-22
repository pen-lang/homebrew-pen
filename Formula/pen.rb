# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "ab9d511a9fdae27c1b31c0941583a1000c0060172256c6543674837e8adf3029"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c0523657df1c5cec76be5c7ff40c73b6b1a515836b62937cbfdaa549ec8ae32"
  end

  depends_on "rust" => [:build, :test]
  depends_on "git"
  depends_on "jq"
  depends_on "llvm"
  depends_on "ninja"
  depends_on "pen-lang/pen/turtle"
  depends_on "rust" => :optional

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
