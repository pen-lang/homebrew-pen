# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "41685328e3ef0dc699a6144cab0a386c59fe6e187fdb3ce921a436ddf0e15f9e"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.6"
    sha256 cellar: :any,                 monterey:     "cf9aaf9b62a9fc68d29f0299fc52e17566d56314d1e6e9b5bcf1daee092caf2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3caa1426fe64bbb82a8c245740d4b5010080c0d591a7a4897e8aa53e7aa109c5"
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
