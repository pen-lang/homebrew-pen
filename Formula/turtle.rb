# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "c53c7a9eb6eba89c0d9f5d2d9f384c8a8b5b8a28d031ee0267fe84fea95da7c3"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/turtle-0.4.3"
    sha256 cellar: :any_skip_relocation, monterey:     "0370dfed4205bbd42905deb87f4eac91c3d4e8a23078a5f572f945f3df19a2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c6fad0cc00cead5c05ca7e6f2156cd5669693ac82f47fc35d98bf5cbf698576"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
