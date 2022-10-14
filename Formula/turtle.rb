# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "9db8fdbbd3cd0404b6c7c8626f4511c752f46b6023f871f4439f9d8921756a12"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/turtle-0.3.8"
    sha256 cellar: :any_skip_relocation, big_sur:      "486c8297ddb7afb0f755074f0fb32b1e30ed34e6f69a78122015a7aa24f52e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7fba0bd5a2e771c66ca7720fbc6447a68e9b55e85eca1103e9a439adab01f624"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "turtle", "--version"
  end
end
