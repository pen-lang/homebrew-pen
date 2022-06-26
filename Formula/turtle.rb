# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7a71ccaf0edcf4cacd693f2e0ad61855e1b8770e7a9cdc37a22fb5a956b7c4c2"
  license "MIT"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/pen-lang/pen"
  end

  pour_bottle? do
    true
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
