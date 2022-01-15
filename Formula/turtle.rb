# frozen_string_literal: true

class Turtle < Formula
  version '0.2.8'
  desc 'Ninja-compatible build system for high-level programming languages'
  homepage 'https://github.com/raviqqe/turtle'
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v#{version}.tar.gz"
  sha256 '8ff6add83f114cd9f29fccd23e378dc238127953bcd665238eae5e15461510fd'
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
