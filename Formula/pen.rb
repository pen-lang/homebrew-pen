# frozen_string_literal: true

class Pen < Formula
  version '0.3.13'
  desc 'Pen programming language'
  homepage 'https://github.com/pen-lang/pen'
  url "https://github.com/pen-lang/pen/archive/refs/tags/v#{version}.tar.gz"
  sha256 'c120b209054867547659938db1499e5c0c3e2d06c1568f1f41b72603ea691ece'
  license 'MIT'

  conflicts_with 'pen'

  depends_on 'git'
  depends_on 'jq'
  depends_on 'llvm@13'
  depends_on 'ninja'
  depends_on 'rust'
  depends_on 'pen-lang/pen/turtle'

  def install
    system 'cargo', 'build', '--locked', '--release'
    libexec.install 'target/release/pen'

    paths = [
      'git',
      'jq',
      'llvm@13',
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
    lib.install Dir['lib/*']
  end

  test do
    ENV.prepend_path 'PATH', bin

    system 'pen', 'create', '.'
    system 'pen', 'build'
    system 'pen', 'test'
    system './app'
  end
end
