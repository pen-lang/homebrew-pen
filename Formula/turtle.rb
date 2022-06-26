# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7a71ccaf0edcf4cacd693f2e0ad61855e1b8770e7a9cdc37a22fb5a956b7c4c2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, monterey: "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any, x86_64_linux: "0000000000000000000000000000000000000000000000000000000000000000"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
