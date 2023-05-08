# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "290a224ee7d09535c94234ac93bfdab135606a34b627e059051c8ee63f22947f"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.2"
    sha256 cellar: :any_skip_relocation, monterey:     "9faf3db2f4b57261d462d32b0f7ac99bc0f70a63c22f36aeac88017b84075b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6837d2f0404a7563e32bcf426b1fb57abaa8043df3faf1042765036cf1c94bde"
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
