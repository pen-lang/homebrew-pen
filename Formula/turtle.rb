# frozen_string_literal: true

class Turtle < Formula
  version '0.3.0'
  desc 'Ninja-compatible build system for high-level programming languages'
  homepage 'https://github.com/raviqqe/turtle'
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v#{version}.tar.gz"
  sha256 '70d1f0faf9d3b23b94e329adf262844bfe10f14e817bcf350ae260ebf1eb9b4f'
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
