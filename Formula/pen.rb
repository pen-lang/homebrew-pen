# frozen_string_literal: true

class Pen < Formula
  desc "Programming language for scalable development"
  homepage "https://github.com/pen-lang/pen"
  url "https://github.com/pen-lang/pen/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "859203eda2e0b118aa34f1f78d0840b0527769b137268daa331ffe6a37337f41"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/pen-0.6.4"
    sha256 cellar: :any,                 monterey:     "da76788727bb7c686f0b7962eb38a85a30152996bbe4442ec6ce03ac6047b1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "22a16fdec0794e1df39efb6a5b7287f35802af6298f316ed7fee153da09efd4d"
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
