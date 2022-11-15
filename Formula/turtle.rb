# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "30b10db4d9e09476aa99040e4c0d8939941281cfd31c4ea7c24a06da661e281f"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/turtle-0.3.9"
    sha256 cellar: :any_skip_relocation, big_sur:      "482eae016e992c5770448ac2d188c6555dfa48a67c9a7a1b02728a3da5083c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63188cff04ceb6719413569e6ba8beafa32b438ef24c194624caefa88b3534e6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
