# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7a71ccaf0edcf4cacd693f2e0ad61855e1b8770e7a9cdc37a22fb5a956b7c4c2"
  license "MIT"
  revision 3

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/turtle-0.3.3_3"
    sha256 cellar: :any_skip_relocation, big_sur:      "f5392b583711742961ba748295d62199a8b215c5f51ce7c94ac08fbc34c00ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cccbfcee750830add96d5bad50338c150c28bdbb1dc88b897eb31180eeaf0d8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
