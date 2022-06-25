# frozen_string_literal: true

class Pen < Formula
  version '0.4.0'
  desc 'Pen programming language'
  homepage 'https://github.com/pen-lang/pen'
  url "https://github.com/pen-lang/pen/archive/refs/tags/v#{version}.tar.gz"
  sha256 '599d0999119a3ca928d834996ef65f603497a6ad1b813be9e30af4fc6f4a2bcf'
  license 'MIT'

  depends_on 'git'
  depends_on 'jq'
  depends_on 'llvm@14'
  depends_on 'ninja'
  depends_on 'rust'
  depends_on 'pen-lang/pen/turtle'

  def install
    system 'cargo', 'build', '--locked', '--release'
    libexec.install 'target/release/pen'

    paths = [
      'git',
      'jq',
      'llvm@14',
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

    (prefix / 'cmd').install Dir['cmd/*']
    prefix.install Dir['packages']
  end

  test do
    ENV.prepend_path 'PATH', bin

    system 'pen', 'create', '.'
    system 'pen', 'build'
    system 'pen', 'test'
    system './app'
  end
end
