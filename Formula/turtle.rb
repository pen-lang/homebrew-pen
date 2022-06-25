# frozen_string_literal: true

class Turtle < Formula
  version '0.3.3'
  desc 'Ninja-compatible build system for high-level programming languages'
  homepage 'https://github.com/raviqqe/turtle'
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v#{version}.tar.gz"
  sha256 '7a71ccaf0edcf4cacd693f2e0ad61855e1b8770e7a9cdc37a22fb5a956b7c4c2'
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
