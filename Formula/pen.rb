# frozen_string_literal: true

class Pen < Formula
  version '0.1.30'
  desc 'Pen programming language'
  homepage 'https://github.com/pen-lang/pen'
  url "https://github.com/pen-lang/pen/archive/refs/tags/v#{version}.tar.gz"
  sha256 'a44ceef3a276247e8d801ecb04a2a6a7840d99498606f20ab8202fdf9770af4c'
  license 'MIT'

  conflicts_with 'pen'

  depends_on 'git'
  depends_on 'llvm@12'
  depends_on 'ninja'
  depends_on 'rust'

  def install
    system 'cargo', 'build', '--locked', '--release'
    libexec.install 'target/release/pen'

    paths = [
      'git',
      'llvm@12',
      'ninja'
    ].map do |name|
      Formula[name].opt_bin
    end.join(':')

    File.write 'pen.sh', <<~EOS
      #!/bin/sh
      set -e
      export PEN_ROOT=#{prefix}
      export PATH=#{paths}:$PATH
      if ! which rustup >/dev/null; then
        export PATH=#{Formula['rust'].opt_bin}:$PATH
      fi
      #{libexec / 'pen'} "$@"
    EOS

    chmod 0o755, 'pen.sh'
    libexec.install 'pen.sh'
    bin.install_symlink (libexec / 'pen.sh') => 'pen'

    lib.install Dir['lib/*']
  end

  test do
    ENV.prepend_path 'PATH', bin

    system 'pen', 'create', '.'
    system 'pen', 'build'
    system './app'
  end
end
