# frozen_string_literal: true

class Turtle < Formula
  desc "Ninja-compatible build system for high-level programming languages"
  homepage "https://github.com/raviqqe/turtle"
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "c53c7a9eb6eba89c0d9f5d2d9f384c8a8b5b8a28d031ee0267fe84fea95da7c3"
  license "MIT"

  bottle do
    root_url "https://github.com/pen-lang/homebrew-pen/releases/download/turtle-0.4.4"
    sha256 cellar: :any_skip_relocation, monterey:     "c20a64fcfc4044a87c0ea00e058bae706b7236d41168646d2380416d5261501e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8aed9fbed3ca12feea30250cd5ef738abb102e967d25dad276bcca2cd3a7a88d"
  end

  depends_on "rust" => :build

  def install
    system "#{bin}/cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/turtle", "--version"
  end
end
