# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "9db8fdbbd3cd0404b6c7c8626f4511c752f46b6023f871f4439f9d8921756a12"
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
