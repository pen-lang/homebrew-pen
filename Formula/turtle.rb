# frozen_string_literal: true

class Turtle < Formula
  version '0.3.1'
  desc 'Ninja-compatible build system for high-level programming languages'
  homepage 'https://github.com/raviqqe/turtle'
  url "https://github.com/raviqqe/turtle/archive/refs/tags/v#{version}.tar.gz"
  sha256 '43b8a132134fa970af2dd736acc6b1918a620870f47be249d34ae82a2895751d'
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
