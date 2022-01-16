# frozen_string_literal: true

class Turtle < Formula
  version '0.2.9'
  desc 'Ninja-compatible build system for high-level programming languages'
  homepage 'https://github.com/raviqqe/turtle'
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v#{version}.tar.gz"
  sha256 'b3b34e5e0fb79604192a63c0280f62ea075228474f06406a8f94b3e5b9fa7a68'
  license 'MIT'

  conflicts_with 'turtle'

  depends_on 'rust' => :build

  def install
    system 'cargo', 'install', *std_cargo_args
  end

  test do
    system 'turtle', '--version'
  end
end
